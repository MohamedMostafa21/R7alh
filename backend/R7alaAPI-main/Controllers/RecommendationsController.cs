using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using R7alaAPI.Data;
using R7alaAPI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace R7alaAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class RecommendationsController : ControllerBase
    {
        private readonly ApplicationDBContext _context;
        private readonly HttpClient _httpClient;
        private readonly string _flaskApiBaseUrl;

        public RecommendationsController(
            ApplicationDBContext context,
            IHttpClientFactory httpClientFactory,
            IConfiguration configuration)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _httpClient = httpClientFactory.CreateClient("FlaskClient");
            _flaskApiBaseUrl = configuration["FlaskApi:BaseUrl"] ?? "http://localhost:5000";
        }

        [HttpGet("health")]
        public async Task<IActionResult> CheckFlaskApiHealth()
        {
            try
            {
                var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/test");
                if (response.IsSuccessStatusCode)
                {
                    var content = await response.Content.ReadAsStringAsync();
                    return Ok(new { message = "Flask API is reachable", response = content });
                }
                return StatusCode((int)response.StatusCode, new { message = "Failed to reach Flask API" });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Unexpected error: {ex.Message}" });
            }
        }

        [HttpGet("restaurants")]
        public async Task<IActionResult> GetRestaurantRecommendations(
            [FromQuery] string mode = null,
            [FromQuery] string name = null,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;

                if (mode == "restaurants")
                {
                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/restaurants?mode=restaurants");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch restaurant list." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                    var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No restaurants found." });

                    var query = _context.Restaurants
                        .Include(r => r.Reviews)
                        .Include(r => r.Meals)
                        .Where(r => names.Any(n => r.Name.ToLower() == n.ToLower()));

                    var totalRestaurants = await query.CountAsync();
                    if (totalRestaurants == 0)
                        return NotFound(new { message = "No restaurants found matching recommended names." });

                    var restaurants = await query
                        .OrderBy(r => r.Name)
                        .Skip((page - 1) * pageSize)
                        .Take(pageSize)
                        .ToListAsync();

                    var restaurantDtos = restaurants.Select(restaurant =>
                    {
                        var restaurantDto = MapToRestaurantDto(restaurant, userId, _context);
                        restaurantDto.Meals = restaurant.Meals?.Select(m => new MealDto
                        {
                            Id = m.Id,
                            RestaurantId = m.RestaurantId,
                            Name = m.Name,
                            Description = m.Description,
                            Price = m.Price,
                            ThumbnailUrl = m.ThumbnailUrl
                        }).ToList() ?? new List<MealDto>();
                        return restaurantDto;
                    }).ToList();

                    return Ok(new
                    {
                        TotalRestaurants = totalRestaurants,
                        CurrentPage = page,
                        PageSize = pageSize,
                        TotalPages = (int)Math.Ceiling(totalRestaurants / (double)pageSize),
                        Restaurants = restaurantDtos
                    });
                }
                else if (!string.IsNullOrWhiteSpace(name))
                {
                    var normalizedName = name.Trim().ToLower();
                    var validName = await _context.Restaurants
                        .AnyAsync(r => r.Name.ToLower() == normalizedName);
                    if (!validName)
                        return NotFound(new { message = $"Restaurant '{name}' not found." });

                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/restaurants?name={Uri.EscapeDataString(name)}");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch restaurant recommendations." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                    var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(10).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No similar restaurants found." });

                    var restaurants = await _context.Restaurants
                        .Include(r => r.Reviews)
                        .Include(r => r.Meals)
                        .Where(r => names.Any(n => r.Name.ToLower() == n.ToLower()))
                        .ToListAsync();

                    if (!restaurants.Any())
                        return NotFound(new { message = "No restaurants found matching recommended names." });

                    var restaurantDtos = restaurants.Select(restaurant =>
                    {
                        var restaurantDto = MapToRestaurantDto(restaurant, userId, _context);
                        restaurantDto.Meals = restaurant.Meals?.Select(m => new MealDto
                        {
                            Id = m.Id,
                            RestaurantId = m.RestaurantId,
                            Name = m.Name,
                            Description = m.Description,
                            Price = m.Price,
                            ThumbnailUrl = m.ThumbnailUrl
                        }).ToList() ?? new List<MealDto>();
                        return restaurantDto;
                    }).ToList();

                    return Ok(restaurantDtos);
                }
                else
                {
                    return BadRequest(new { message = "Provide either 'mode=restaurants' or 'name=restaurant_name'." });
                }
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch restaurant recommendations: {ex.Message}" });
            }
        }

        [HttpPost("restaurants")]
        public async Task<IActionResult> GetRestaurantRecommendations(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;
                if (!userId.HasValue)
                    return Unauthorized(new { message = "User is not authenticated." });

                // Fetch favorited restaurant names
                var favoriteRestaurants = await _context.Favorites
                    .Where(f => f.UserId == userId && f.RestaurantId != null)
                    .Join(_context.Restaurants,
                        f => f.RestaurantId,
                        r => r.Id,
                        (f, r) => r.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                if (!favoriteRestaurants.Any())
                    return BadRequest(new { message = "No favorited restaurants found for the user." });

                var request = new RecommendationRequestDto
                {
                    UserPreferences = favoriteRestaurants
                };

                var response = await _httpClient.PostAsJsonAsync($"{_flaskApiBaseUrl}/api/restaurants", request);
                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                    return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch restaurant recommendations." });
                }

                var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                if (!names.Any())
                    return NotFound(new { message = "No similar restaurants found." });

                var query = _context.Restaurants
                    .Include(r => r.Reviews)
                    .Include(r => r.Meals)
                    .Where(r => names.Any(n => r.Name.ToLower() == n.ToLower()));

                var totalRestaurants = await query.CountAsync();
                if (totalRestaurants == 0)
                    return NotFound(new { message = "No restaurants found matching recommended names." });

                var restaurants = await query
                    .OrderBy(r => r.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var restaurantDtos = restaurants.Select(restaurant =>
                {
                    var restaurantDto = MapToRestaurantDto(restaurant, userId, _context);
                    restaurantDto.Meals = restaurant.Meals?.Select(m => new MealDto
                    {
                        Id = m.Id,
                        RestaurantId = m.RestaurantId,
                        Name = m.Name,
                        Description = m.Description,
                        Price = m.Price,
                        ThumbnailUrl = m.ThumbnailUrl
                    }).ToList() ?? new List<MealDto>();
                    return restaurantDto;
                }).ToList();

                return Ok(new
                {
                    TotalRestaurants = totalRestaurants,
                    CurrentPage = page,
                    PageSize = pageSize,
                    TotalPages = (int)Math.Ceiling(totalRestaurants / (double)pageSize),
                    Restaurants = restaurantDtos
                });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch restaurant recommendations: {ex.Message}" });
            }
        }

        [HttpGet("hotels")]
        public async Task<IActionResult> GetHotelRecommendations(
            [FromQuery] string name,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (string.IsNullOrWhiteSpace(name))
                return BadRequest(new { message = "The 'name' parameter is required." });

            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;

                if (name.ToLower() == "hotels")
                {
                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/hotels?name=hotels");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch hotel list." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                    var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No hotels found." });

                    var query = _context.Hotels
                        .Include(h => h.Reviews)
                        .Include(h => h.Rooms)
                        .Where(h => names.Any(n => h.Name.ToLower() == n.ToLower()));

                    var totalHotels = await query.CountAsync();
                    if (totalHotels == 0)
                        return NotFound(new { message = "No hotels found matching recommended names." });

                    var hotels = await query
                        .OrderBy(h => h.Name)
                        .Skip((page - 1) * pageSize)
                        .Take(pageSize)
                        .ToListAsync();

                    var hotelDtos = hotels.Select(hotel =>
                    {
                        var hotelDto = MapToHotelDto(hotel, userId, _context);
                        hotelDto.Rooms = hotel.Rooms?.Select(r => new RoomDto
                        {
                            Id = r.Id,
                            HotelId = r.HotelId,
                            Type = r.Type,
                            Capacity = r.Capacity,
                            PricePerNight = r.PricePerNight,
                            Description = r.Description,
                            IsAvailable = r.IsAvailable,
                            ThumbnailUrl = r.ThumbnailUrl,
                            ImageUrls = r.ImageUrls
                        }).ToList() ?? new List<RoomDto>();
                        return hotelDto;
                    }).ToList();

                    return Ok(new
                    {
                        TotalHotels = totalHotels,
                        CurrentPage = page,
                        PageSize = pageSize,
                        TotalPages = (int)Math.Ceiling(totalHotels / (double)pageSize),
                        Hotels = hotelDtos
                    });
                }
                else
                {
                    var normalizedName = name.Trim().ToLower();
                    var validName = await _context.Hotels
                        .AnyAsync(h => h.Name.ToLower() == normalizedName);
                    if (!validName)
                        return NotFound(new { message = $"Hotel '{name}' not found." });

                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/hotels?name={Uri.EscapeDataString(name)}");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch hotel recommendations." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                    var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(10).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No similar hotels found." });

                    var hotels = await _context.Hotels
                        .Include(h => h.Reviews)
                        .Include(h => h.Rooms)
                        .Where(h => names.Any(n => h.Name.ToLower() == n.ToLower()))
                        .ToListAsync();

                    if (!hotels.Any())
                        return NotFound(new { message = "No hotels found matching recommended names." });

                    var hotelDtos = hotels.Select(hotel =>
                    {
                        var hotelDto = MapToHotelDto(hotel, userId, _context);
                        hotelDto.Rooms = hotel.Rooms?.Select(r => new RoomDto
                        {
                            Id = r.Id,
                            HotelId = r.HotelId,
                            Type = r.Type,
                            Capacity = r.Capacity,
                            PricePerNight = r.PricePerNight,
                            Description = r.Description,
                            IsAvailable = r.IsAvailable,
                            ThumbnailUrl = r.ThumbnailUrl,
                            ImageUrls = r.ImageUrls
                        }).ToList() ?? new List<RoomDto>();
                        return hotelDto;
                    }).ToList();

                    return Ok(hotelDtos);
                }
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch hotel recommendations: {ex.Message}" });
            }
        }

        [HttpPost("hotels")]
        public async Task<IActionResult> GetHotelRecommendations(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;
                if (!userId.HasValue)
                    return Unauthorized(new { message = "User is not authenticated." });

                // Fetch favorited hotel names
                var favoriteHotels = await _context.Favorites
                    .Where(f => f.UserId == userId && f.HotelId != null)
                    .Join(_context.Hotels,
                        f => f.HotelId,
                        h => h.Id,
                        (f, h) => h.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                if (!favoriteHotels.Any())
                    return BadRequest(new { message = "No favorited hotels found for the user." });

                var request = new HotelRecommendationRequestDto
                {
                    Hotels = favoriteHotels
                };

                var response = await _httpClient.PostAsJsonAsync($"{_flaskApiBaseUrl}/api/hotels", request);
                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                    return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch hotel recommendations." });
                }

                var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                if (!names.Any())
                    return NotFound(new { message = "No similar hotels found." });

                var query = _context.Hotels
                    .Include(h => h.Reviews)
                    .Include(h => h.Rooms)
                    .Where(h => names.Any(n => h.Name.ToLower() == n.ToLower()));

                var totalHotels = await query.CountAsync();
                if (totalHotels == 0)
                    return NotFound(new { message = "No hotels found matching recommended names." });

                var hotels = await query
                    .OrderBy(h => h.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var hotelDtos = hotels.Select(hotel =>
                {
                    var hotelDto = MapToHotelDto(hotel, userId, _context);
                    hotelDto.Rooms = hotel.Rooms?.Select(r => new RoomDto
                    {
                        Id = r.Id,
                        HotelId = r.HotelId,
                        Type = r.Type,
                        Capacity = r.Capacity,
                        PricePerNight = r.PricePerNight,
                        Description = r.Description,
                        IsAvailable = r.IsAvailable,
                        ThumbnailUrl = r.ThumbnailUrl,
                        ImageUrls = r.ImageUrls
                    }).ToList() ?? new List<RoomDto>();
                    return hotelDto;
                }).ToList();

                return Ok(new
                {
                    TotalHotels = totalHotels,
                    CurrentPage = page,
                    PageSize = pageSize,
                    TotalPages = (int)Math.Ceiling(totalHotels / (double)pageSize),
                    Hotels = hotelDtos
                });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch hotel recommendations: {ex.Message}" });
            }
        }

        [HttpGet("places")]
        public async Task<IActionResult> GetPlaceRecommendations(
            [FromQuery] string name,
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (string.IsNullOrWhiteSpace(name))
                return BadRequest(new { message = "The 'name' parameter is required." });

            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;

                if (name.ToLower() == "places")
                {
                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/places?name=places");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch place list." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<List<NameResponseDto>>();
                    var names = flaskResults?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No places found." });

                    var query = _context.Places
                        .Include(p => p.Reviews)
                        .Include(p => p.Activities)
                        .Where(p => names.Any(n => p.Name.ToLower() == n.ToLower()));

                    var totalPlaces = await query.CountAsync();
                    if (totalPlaces == 0)
                        return NotFound(new { message = "No places found matching recommended names." });

                    var places = await query
                        .OrderBy(p => p.Name)
                        .Skip((page - 1) * pageSize)
                        .Take(pageSize)
                        .ToListAsync();

                    var placeDtos = places.Select(place =>
                    {
                        var placeDto = MapToPlaceDto(place, userId, _context);
                        placeDto.Activities = place.Activities?.Select(a => new ActivityDto
                        {
                            Id = a.Id,
                            PlaceId = a.PlaceId,
                            Name = a.Name,
                            Description = a.Description,
                            Price = a.Price,
                            ThumbnailUrl = a.ThumbnailUrl
                        }).ToList() ?? new List<ActivityDto>();
                        return placeDto;
                    }).ToList();

                    return Ok(new
                    {
                        TotalPlaces = totalPlaces,
                        CurrentPage = page,
                        PageSize = pageSize,
                        TotalPages = (int)Math.Ceiling(totalPlaces / (double)pageSize),
                        Places = placeDtos
                    });
                }
                else
                {
                    var normalizedName = name.Trim().ToLower();
                    var validName = await _context.Places
                        .AnyAsync(p => p.Name.ToLower() == normalizedName);
                    if (!validName)
                        return NotFound(new { message = $"Place '{name}' not found." });

                    var response = await _httpClient.GetAsync($"{_flaskApiBaseUrl}/api/places?name={Uri.EscapeDataString(name)}");
                    if (!response.IsSuccessStatusCode)
                    {
                        var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                        return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch place recommendations." });
                    }

                    var flaskResults = await response.Content.ReadFromJsonAsync<PlacesResponseDto>();
                    var names = flaskResults?.Results?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(10).ToList() ?? new List<string>();
                    if (!names.Any())
                        return NotFound(new { message = "No similar places found." });

                    var places = await _context.Places
                        .Include(p => p.Reviews)
                        .Include(p => p.Activities)
                        .Where(p => names.Any(n => p.Name.ToLower() == n.ToLower()))
                        .ToListAsync();

                    if (!places.Any())
                        return NotFound(new { message = "No places found matching recommended names." });

                    var placeDtos = places.Select(place =>
                    {
                        var placeDto = MapToPlaceDto(place, userId, _context);
                        placeDto.Activities = place.Activities?.Select(a => new ActivityDto
                        {
                            Id = a.Id,
                            PlaceId = a.PlaceId,
                            Name = a.Name,
                            Description = a.Description,
                            Price = a.Price,
                            ThumbnailUrl = a.ThumbnailUrl
                        }).ToList() ?? new List<ActivityDto>();
                        return placeDto;
                    }).ToList();

                    return Ok(placeDtos);
                }
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch place recommendations: {ex.Message}" });
            }
        }

        [HttpPost("places")]
        public async Task<IActionResult> GetPlaceRecommendations(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 50)
        {
            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;
                if (!userId.HasValue)
                    return Unauthorized(new { message = "User is not authenticated." });

                // Fetch favorited place names
                var favoritePlaces = await _context.Favorites
                    .Where(f => f.UserId == userId && f.PlaceId != null)
                    .Join(_context.Places,
                        f => f.PlaceId,
                        p => p.Id,
                        (f, p) => p.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                if (!favoritePlaces.Any())
                    return BadRequest(new { message = "No favorited places found for the user." });

                var request = new RecommendationRequestDto
                {
                    UserPreferences = favoritePlaces
                };

                var response = await _httpClient.PostAsJsonAsync($"{_flaskApiBaseUrl}/api/places", request);
                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                    return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch place recommendations." });
                }

                var flaskResults = await response.Content.ReadFromJsonAsync<PlacesResponseDto>();
                var names = flaskResults?.Results?.Select(r => r.Name?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(50).ToList() ?? new List<string>();
                if (!names.Any())
                    return NotFound(new { message = "No similar places found." });

                var query = _context.Places
                    .Include(p => p.Reviews)
                    .Include(p => p.Activities)
                    .Where(p => names.Any(n => p.Name.ToLower() == n.ToLower()));

                var totalPlaces = await query.CountAsync();
                if (totalPlaces == 0)
                    return NotFound(new { message = "No places found matching recommended names." });

                var places = await query
                    .OrderBy(p => p.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var placeDtos = places.Select(place =>
                {
                    var placeDto = MapToPlaceDto(place, userId, _context);
                    placeDto.Activities = place.Activities?.Select(a => new ActivityDto
                    {
                        Id = a.Id,
                        PlaceId = a.PlaceId,
                        Name = a.Name,
                        Description = a.Description,
                        Price = a.Price,
                        ThumbnailUrl = a.ThumbnailUrl
                    }).ToList() ?? new List<ActivityDto>();
                    return placeDto;
                }).ToList();

                return Ok(new
                {
                    TotalPlaces = totalPlaces,
                    CurrentPage = page,
                    PageSize = pageSize,
                    TotalPages = (int)Math.Ceiling(totalPlaces / (double)pageSize),
                    Places = placeDtos
                });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch place recommendations: {ex.Message}" });
            }
        }

        [HttpPost("recommend")]
        public async Task<IActionResult> GetGeneralRecommendations(
            [FromQuery] int page = 1,
            [FromQuery] int pageSize = 20)
        {
            if (page <= 0 || pageSize <= 0)
                return BadRequest(new { message = "Page and pageSize must be greater than 0." });

            try
            {
                var userId = User.Identity.IsAuthenticated ? int.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value) : (int?)null;
                if (!userId.HasValue)
                    return Unauthorized(new { message = "User is not authenticated." });

                // Fetch favorited names
                var favoriteHotels = await _context.Favorites
                    .Where(f => f.UserId == userId && f.HotelId != null)
                    .Join(_context.Hotels,
                        f => f.HotelId,
                        h => h.Id,
                        (f, h) => h.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                var favoriteRestaurants = await _context.Favorites
                    .Where(f => f.UserId == userId && f.RestaurantId != null)
                    .Join(_context.Restaurants,
                        f => f.RestaurantId,
                        r => r.Id,
                        (f, r) => r.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                var favoritePlaces = await _context.Favorites
                    .Where(f => f.UserId == userId && f.PlaceId != null)
                    .Join(_context.Places,
                        f => f.PlaceId,
                        p => p.Id,
                        (f, p) => p.Name)
                    .Select(n => n.Trim())
                    .ToListAsync();

                if (!favoriteHotels.Any() && !favoriteRestaurants.Any() && !favoritePlaces.Any())
                    return BadRequest(new { message = "No favorited hotels, restaurants, or places found for the user." });

                var request = new GeneralRecommendationRequestDto
                {
                    Hotels = favoriteHotels,
                    Restaurants = favoriteRestaurants,
                    TouristPlaces = favoritePlaces
                };

                var response = await _httpClient.PostAsJsonAsync($"{_flaskApiBaseUrl}/recommend", request);
                if (!response.IsSuccessStatusCode)
                {
                    var error = await response.Content.ReadFromJsonAsync<ErrorResponseDto>();
                    return StatusCode((int)response.StatusCode, new { message = error?.Error ?? "Failed to fetch general recommendations." });
                }

                var flaskResults = await response.Content.ReadFromJsonAsync<GeneralRecommendationResponseFlaskDto>();
                if (flaskResults == null)
                    return StatusCode(500, new { message = "Invalid response from Flask API." });

                var hotelNames = flaskResults.Hotels?.Select(n => n?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(20).ToList() ?? new List<string>();
                var restaurantNames = flaskResults.Restaurants?.Select(n => n?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(20).ToList() ?? new List<string>();
                var placeNames = flaskResults.TouristPlaces?.Select(n => n?.Trim()).Where(n => !string.IsNullOrEmpty(n)).Take(20).ToList() ?? new List<string>();

                var hotelQuery = _context.Hotels
                    .Include(h => h.Reviews)
                    .Include(h => h.Rooms)
                    .Where(h => hotelNames.Any(n => h.Name.ToLower() == n.ToLower()));
                var restaurantQuery = _context.Restaurants
                    .Include(r => r.Reviews)
                    .Include(r => r.Meals)
                    .Where(r => restaurantNames.Any(n => r.Name.ToLower() == n.ToLower()));
                var placeQuery = _context.Places
                    .Include(p => p.Reviews)
                    .Include(p => p.Activities)
                    .Where(p => placeNames.Any(n => p.Name.ToLower() == n.ToLower()));

                var totalHotels = await hotelQuery.CountAsync();
                var totalRestaurants = await restaurantQuery.CountAsync();
                var totalPlaces = await placeQuery.CountAsync();

                if (totalHotels == 0 && totalRestaurants == 0 && totalPlaces == 0)
                    return NotFound(new { message = "No hotels, restaurants, or places found matching recommended names." });

                var hotels = await hotelQuery
                    .OrderBy(h => h.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();
                var restaurants = await restaurantQuery
                    .OrderBy(r => r.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();
                var places = await placeQuery
                    .OrderBy(p => p.Name)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToListAsync();

                var responseDto = new GeneralRecommendationResponseDto
                {
                    Hotels = hotels.Select(hotel =>
                    {
                        var hotelDto = MapToHotelDto(hotel, userId, _context);
                        hotelDto.Rooms = hotel.Rooms?.Select(r => new RoomDto
                        {
                            Id = r.Id,
                            HotelId = r.HotelId,
                            Type = r.Type,
                            Capacity = r.Capacity,
                            PricePerNight = r.PricePerNight,
                            Description = r.Description,
                            IsAvailable = r.IsAvailable,
                            ThumbnailUrl = r.ThumbnailUrl,
                            ImageUrls = r.ImageUrls
                        }).ToList() ?? new List<RoomDto>();
                        return hotelDto;
                    }).ToList(),
                    Restaurants = restaurants.Select(restaurant =>
                    {
                        var restaurantDto = MapToRestaurantDto(restaurant, userId, _context);
                        restaurantDto.Meals = restaurant.Meals?.Select(m => new MealDto
                        {
                            Id = m.Id,
                            RestaurantId = m.RestaurantId,
                            Name = m.Name,
                            Description = m.Description,
                            Price = m.Price,
                            ThumbnailUrl = m.ThumbnailUrl
                        }).ToList() ?? new List<MealDto>();
                        return restaurantDto;
                    }).ToList(),
                    TouristPlaces = places.Select(place =>
                    {
                        var placeDto = MapToPlaceDto(place, userId, _context);
                        placeDto.Activities = place.Activities?.Select(a => new ActivityDto
                        {
                            Id = a.Id,
                            PlaceId = a.PlaceId,
                            Name = a.Name,
                            Description = a.Description,
                            Price = a.Price,
                            ThumbnailUrl = a.ThumbnailUrl
                        }).ToList() ?? new List<ActivityDto>();
                        return placeDto;
                    }).ToList()
                };

                return Ok(new
                {
                    TotalHotels = totalHotels,
                    TotalRestaurants = totalRestaurants,
                    TotalPlaces = totalPlaces,
                    CurrentPage = page,
                    PageSize = pageSize,
                    TotalPages = (int)Math.Ceiling(Math.Max(Math.Max(totalHotels, totalRestaurants), totalPlaces) / (double)pageSize),
                    Recommendations = responseDto
                });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(503, new { message = $"Failed to connect to Flask API: {ex.Message}" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Failed to fetch general recommendations: {ex.Message}" });
            }
        }

        [NonAction]
        private static RestaurantDto MapToRestaurantDto(Restaurant restaurant, int? userId, ApplicationDBContext context)
        {
            return new RestaurantDto
            {
                Id = restaurant.Id,
                Name = restaurant.Name,
                Description = restaurant.Description,
                City = restaurant.City,
                Country = restaurant.Country,
                Location = restaurant.Location,
                Latitude = restaurant.Latitude,
                Longitude = restaurant.Longitude,
                Cuisine = restaurant.Cuisine,
                AveragePrice = restaurant.AveragePrice,
                Stars = restaurant.Reviews != null && restaurant.Reviews.Any()
                    ? Math.Round(restaurant.Reviews.Average(r => r.Rating), 1)
                    : 0.0d,
                ThumbnailUrl = restaurant.ThumbnailUrl,
                ImageUrls = restaurant.ImageUrls,
                IsFavorited = userId.HasValue && context.Favorites.Any(f => f.UserId == userId && f.RestaurantId == restaurant.Id)
            };
        }

        [NonAction]
        private static HotelDto MapToHotelDto(Hotel hotel, int? userId, ApplicationDBContext context)
        {
            return new HotelDto
            {
                Id = hotel.Id,
                Name = hotel.Name,
                Description = hotel.Description,
                City = hotel.City,
                Country = hotel.Country,
                Location = hotel.Location,
                Latitude = hotel.Latitude,
                Longitude = hotel.Longitude,
                StartingPrice = hotel.StartingPrice,
                Rate = hotel.Rate,
                Stars = hotel.Reviews != null && hotel.Reviews.Any()
                    ? Math.Round(hotel.Reviews.Average(r => r.Rating), 1)
                    : 0.0d,
                ThumbnailUrl = hotel.ThumbnailUrl,
                ImageUrls = hotel.ImageUrls,
                IsFavorited = userId.HasValue && context.Favorites.Any(l => l.UserId == userId && l.HotelId == hotel.Id)
            };
        }

        [NonAction]
        private static PlaceDto MapToPlaceDto(Place place, int? userId, ApplicationDBContext context)
        {
            return new PlaceDto
            {
                Id = place.Id,
                Name = place.Name,
                Description = place.Description,
                Type = place.Type,
                City = place.City,
                Country = place.Country,
                Location = place.Location,
                Latitude = place.Latitude,
                Longitude = place.Longitude,
                AveragePrice = place.AveragePrice ?? 0.0m,
                Stars = place.Reviews != null && place.Reviews.Any()
                    ? Math.Round(place.Reviews.Average(r => r.Rating), 1)
                    : 0.0d,
                ThumbnailUrl = place.ThumbnailUrl,
                ImageUrls = place.ImageUrls,
                IsFavorited = userId.HasValue && context.Favorites.Any(l => l.UserId == userId && l.PlaceId == place.Id)
            };
        }

        private class NameResponseDto
        {
            [JsonPropertyName("name")]
            public string Name { get; set; }
        }

        private class PlacesResponseDto
        {
            [JsonPropertyName("results")]
            public List<NameResponseDto> Results { get; set; } = new List<NameResponseDto>();
        }

        private class GeneralRecommendationResponseFlaskDto
        {
            [JsonPropertyName("hotels")]
            public List<string> Hotels { get; set; } = new List<string>();
            [JsonPropertyName("restaurants")]
            public List<string> Restaurants { get; set; } = new List<string>();
            [JsonPropertyName("tourist_places")]
            public List<string> TouristPlaces { get; set; } = new List<string>();
        }

        private class ErrorResponseDto
        {
            [JsonPropertyName("error")]
            public string Error { get; set; }
        }

        public class RecommendationRequestDto
        {
            [JsonPropertyName("user_preferences")]
            public List<string> UserPreferences { get; set; } = new List<string>();
        }

        public class HotelRecommendationRequestDto
        {
            [JsonPropertyName("hotels")]
            public List<string> Hotels { get; set; } = new List<string>();
        }

        public class GeneralRecommendationRequestDto
        {
            [JsonPropertyName("hotels")]
            public List<string> Hotels { get; set; } = new List<string>();
            [JsonPropertyName("restaurants")]
            public List<string> Restaurants { get; set; } = new List<string>();
            [JsonPropertyName("tourist_places")]
            public List<string> TouristPlaces { get; set; } = new List<string>();
        }

        public class GeneralRecommendationResponseDto
        {
            public List<HotelDto> Hotels { get; set; } = new List<HotelDto>();
            public List<RestaurantDto> Restaurants { get; set; } = new List<RestaurantDto>();
            public List<PlaceDto> TouristPlaces { get; set; } = new List<PlaceDto>();
        }

        public class RestaurantDto
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string City { get; set; }
            public string Country { get; set; }
            public string Location { get; set; }
            public double Latitude { get; set; }
            public double Longitude { get; set; }
            public string Cuisine { get; set; }
            public decimal AveragePrice { get; set; }
            public double Stars { get; set; }
            public string ThumbnailUrl { get; set; }
            public List<string> ImageUrls { get; set; }
            public List<MealDto> Meals { get; set; }
            public bool IsFavorited { get; set; }
        }

        public class HotelDto
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string City { get; set; }
            public string Country { get; set; }
            public string Location { get; set; }
            public double Latitude { get; set; }
            public double Longitude { get; set; }
            public decimal StartingPrice { get; set; }
            public decimal Rate { get; set; }
            public double Stars { get; set; }
            public string ThumbnailUrl { get; set; }
            public List<string> ImageUrls { get; set; }
            public List<RoomDto> Rooms { get; set; }
            public bool IsFavorited { get; set; }
        }

        public class PlaceDto
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string Type { get; set; }
            public string City { get; set; }
            public string Country { get; set; }
            public string Location { get; set; }
            public double Latitude { get; set; }
            public double Longitude { get; set; }
            public decimal AveragePrice { get; set; }
            public double Stars { get; set; }
            public string ThumbnailUrl { get; set; }
            public List<string> ImageUrls { get; set; }
            public List<ActivityDto> Activities { get; set; }
            public bool IsFavorited { get; set; }
        }

        public class MealDto
        {
            public int Id { get; set; }
            public int RestaurantId { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public decimal Price { get; set; }
            public string ThumbnailUrl { get; set; }
        }

        public class RoomDto
        {
            public int Id { get; set; }
            public int HotelId { get; set; }
            public string Type { get; set; }
            public int Capacity { get; set; }
            public decimal PricePerNight { get; set; }
            public string Description { get; set; }
            public bool IsAvailable { get; set; }
            public string ThumbnailUrl { get; set; }
            public List<string> ImageUrls { get; set; }
        }

        public class ActivityDto
        {
            public int Id { get; set; }
            public int PlaceId { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public decimal Price { get; set; }
            public string ThumbnailUrl { get; set; }
        }
    }
}