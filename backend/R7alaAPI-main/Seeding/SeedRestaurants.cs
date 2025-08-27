using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using CsvHelper;
using CsvHelper.Configuration;
using Microsoft.EntityFrameworkCore;
using R7alaAPI.Data;
using R7alaAPI.Models;

namespace R7alaAPI.Seeding
{
    public class RestaurantSeedDto
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Location { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Cuisine { get; set; }
        public decimal AveragePrice { get; set; }
    }

    public class RestaurantSeedDtoMap : ClassMap<RestaurantSeedDto>
    {
        public RestaurantSeedDtoMap()
        {
            Map(m => m.Name).Name("name");
            Map(m => m.Description).Name("description");
            Map(m => m.City).Name("city");
            Map(m => m.Country).Name("country");
            Map(m => m.Location).Name("location");
            Map(m => m.Latitude).Name("latitude");
            Map(m => m.Longitude).Name("longitude");
            Map(m => m.Cuisine).Name("cuisine");
            Map(m => m.AveragePrice).Name("averagePrice");
        }
    }

    public class SeedRestaurants
    {
        private readonly ApplicationDBContext _context;
        private readonly string _csvFilePath = Path.Combine(Directory.GetCurrentDirectory(), "Seeding", "RestaurantSeedData.csv");
        private readonly string _seedImagesPath = Path.Combine(Directory.GetCurrentDirectory(), "Seeding", "SeedImages");
        private readonly string _defaultThumbnailUrl = "/Uploads/restaurants/thumbnails/default.jpg";

        public SeedRestaurants(ApplicationDBContext context)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
        }

        public async Task SeedAsync()
        {
            if (!File.Exists(_csvFilePath))
            {
                Console.WriteLine($"CSV file not found at: {_csvFilePath}");
                return;
            }

            if (!Directory.Exists(_seedImagesPath))
            {
                Console.WriteLine($"Images folder not found at: {_seedImagesPath}");
                return;
            }

            var config = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                HeaderValidated = null,
                MissingFieldFound = null,
                BadDataFound = null,
                Delimiter = ",",
                TrimOptions = TrimOptions.Trim,
                IgnoreBlankLines = true
            };

            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                using var reader = new StreamReader(_csvFilePath);
                using var csv = new CsvReader(reader, config);
                csv.Context.RegisterClassMap<RestaurantSeedDtoMap>();

                var records = csv.GetRecords<RestaurantSeedDto>().ToList();
                Console.WriteLine($"Read {records.Count} restaurant records from CSV.");

                foreach (var record in records)
                {
                    if (string.IsNullOrWhiteSpace(record.Name) || string.IsNullOrWhiteSpace(record.City) ||
                        string.IsNullOrWhiteSpace(record.Country) || string.IsNullOrWhiteSpace(record.Cuisine))
                    {
                        Console.WriteLine($"Skipping record: Name, City, Country, or Cuisine is empty for '{record.Name}'.");
                        continue;
                    }

                    if (_context.Restaurants.Any(r => r.Name == record.Name && r.City == record.City))
                    {
                        Console.WriteLine($"Skipping {record.Name} in {record.City}: Already exists.");
                        continue;
                    }

                    // Validate model constraints
                    if (record.Name.Length > 100 || record.City.Length > 50 || record.Country.Length > 50 || record.Cuisine.Length > 50)
                    {
                        Console.WriteLine($"Skipping {record.Name}: Name, City, Country, or Cuisine exceeds length limits.");
                        continue;
                    }

                    if (record.Latitude < -90 || record.Latitude > 90 || record.Longitude < -180 || record.Longitude > 180 || record.AveragePrice < 0)
                    {
                        Console.WriteLine($"Skipping {record.Name}: Invalid Latitude, Longitude, or AveragePrice.");
                        continue;
                    }

                    var description = string.IsNullOrWhiteSpace(record.Description) ? "" : record.Description.Length > 1000 ? record.Description.Substring(0, 1000) : record.Description;
                    var location = string.IsNullOrWhiteSpace(record.Location) ? "" : record.Location.Length > 200 ? record.Location.Substring(0, 200) : record.Location;

                    var restaurant = new Restaurant
                    {
                        Name = record.Name,
                        Description = description,
                        City = record.City,
                        Country = record.Country,
                        Location = location,
                        Latitude = record.Latitude,
                        Longitude = record.Longitude,
                        Cuisine = record.Cuisine,
                        AveragePrice = record.AveragePrice,
                        ThumbnailUrl = _defaultThumbnailUrl,
                        ImageUrls = new List<string>(),
                        Meals = new List<Meal>(),
                        Reviews = new List<Review>()
                    };

                    // Handle images
                    var folderName = SanitizeFileName(record.Name);
                    var restaurantFolderPath = Path.Combine(_seedImagesPath, folderName);
                    if (Directory.Exists(restaurantFolderPath))
                    {
                        var imageFiles = Directory.GetFiles(restaurantFolderPath)
                            .Where(f => new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" }
                            .Contains(Path.GetExtension(f)?.ToLowerInvariant()))
                            .OrderBy(f => f)
                            .ToList();

                        // Assign first valid image as ThumbnailUrl
                        if (imageFiles.Any())
                        {
                            try
                            {
                                restaurant.ThumbnailUrl = await CopyFileAsync(imageFiles[0], "restaurants/thumbnails");
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine($"Failed to copy thumbnail for {record.Name}: {ex.Message}");
                            }
                        }

                        // Add all valid images to ImageUrls
                        foreach (var imagePath in imageFiles)
                        {
                            try
                            {
                                var imageUrl = await CopyFileAsync(imagePath, "restaurants/images");
                                restaurant.ImageUrls.Add(imageUrl);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine($"Failed to copy image for {record.Name} at {imagePath}: {ex.Message}");
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine($"Image folder not found for {record.Name} at {restaurantFolderPath}");
                    }

                    _context.Restaurants.Add(restaurant);
                    Console.WriteLine($"Added {record.Name} in {record.City} to database.");
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                Console.WriteLine("Restaurant seeding completed.");
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                Console.WriteLine($"Seeding failed: {ex.Message}");
            }
        }

        private async Task<string> CopyFileAsync(string sourcePath, string subfolder)
        {
            var extension = Path.GetExtension(sourcePath)?.ToLowerInvariant();
            if (!new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" }.Contains(extension))
            {
                throw new ArgumentException($"Invalid file format for {sourcePath}. Supported formats: jpg, jpeg, png, gif, webp.");
            }

            var fileInfo = new FileInfo(sourcePath);
            if (fileInfo.Length > 300 * 1024 * 1024)
            {
                throw new ArgumentException($"File size exceeds 300MB limit for {sourcePath}.");
            }

            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Uploads", subfolder);
            Directory.CreateDirectory(uploadsFolder);

            var uniqueFileName = $"{Guid.NewGuid()}{extension}";
            var destPath = Path.Combine(uploadsFolder, uniqueFileName);

            using (var sourceStream = new FileStream(sourcePath, FileMode.Open, FileAccess.Read))
            using (var destStream = new FileStream(destPath, FileMode.Create))
            {
                await sourceStream.CopyToAsync(destStream);
            }

            return $"/Uploads/{subfolder}/{uniqueFileName}";
        }

        private string SanitizeFileName(string name)
        {
            var invalidChars = Path.GetInvalidFileNameChars();
            return string.Concat(name.Select(c => invalidChars.Contains(c) ? '_' : c));
        }
    }
}