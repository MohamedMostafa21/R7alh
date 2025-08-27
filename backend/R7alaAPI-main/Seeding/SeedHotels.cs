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
    public class HotelSeedDto
    {
        public string Name { get; set; }
        public string Location { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public decimal Rate { get; set; }
        public string Description { get; set; }
        public string Country { get; set; }
    }

    public class HotelSeedDtoMap : ClassMap<HotelSeedDto>
    {
        public HotelSeedDtoMap()
        {
            Map(m => m.Name).Name("Name");
            Map(m => m.Location).Name("Location");
            Map(m => m.Latitude).Name("Latitude");
            Map(m => m.Longitude).Name("Longitude");
            Map(m => m.Rate).Name("Rate");
            Map(m => m.Description).Name("Description");
            Map(m => m.Country).Name("Country");
        }
    }

    public class SeedHotels
    {
        private readonly ApplicationDBContext _context;
        private readonly string _csvFilePath = Path.Combine(Directory.GetCurrentDirectory(), "Seeding", "HotelSeedData.csv");
        private readonly string _seedImagesPath = Path.Combine(Directory.GetCurrentDirectory(), "Seeding", "SeedImages");
        private readonly string _defaultThumbnailUrl = "/Uploads/hotels/thumbnails/default.jpg";

        public SeedHotels(ApplicationDBContext context)
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
                csv.Context.RegisterClassMap<HotelSeedDtoMap>();

                var records = csv.GetRecords<HotelSeedDto>().ToList();
                Console.WriteLine($"Read {records.Count} hotel records from CSV.");

                foreach (var record in records)
                {
                    if (string.IsNullOrWhiteSpace(record.Name) || string.IsNullOrWhiteSpace(record.Country))
                    {
                        Console.WriteLine($"Skipping record: Name or Country is empty for '{record.Name}'.");
                        continue;
                    }

                    if (_context.Hotels.Any(h => h.Name == record.Name && h.Country == record.Country))
                    {
                        Console.WriteLine($"Skipping {record.Name} in {record.Country}: Already exists.");
                        continue;
                    }

                    // Validate model constraints
                    if (record.Name.Length > 100 || record.Country.Length > 50)
                    {
                        Console.WriteLine($"Skipping {record.Name}: Name or Country exceeds length limits.");
                        continue;
                    }

                    if (record.Latitude < -90 || record.Latitude > 90 || record.Longitude < -180 || record.Longitude > 180 ||
                        record.Rate < 0 || record.Rate > 5)
                    {
                        Console.WriteLine($"Skipping {record.Name}: Invalid Latitude, Longitude, or Rate.");
                        continue;
                    }

                    // Derive City from Location (e.g., "Alexandria" from "Alexandria")
                    var city = string.IsNullOrWhiteSpace(record.Location) ? "" : record.Location.Split(',')[0].Trim();
                    if (city.Length > 50)
                    {
                        city = city.Substring(0, 50);
                    }

                    var description = string.IsNullOrWhiteSpace(record.Description) ? "" : record.Description.Length > 1000 ? record.Description.Substring(0, 1000) : record.Description;
                    var location = string.IsNullOrWhiteSpace(record.Location) ? "" : record.Location.Length > 200 ? record.Location.Substring(0, 200) : record.Location;

                    var hotel = new Hotel
                    {
                        Name = record.Name,
                        Description = description,
                        City = city,
                        Country = record.Country,
                        Location = location,
                        Latitude = record.Latitude,
                        Longitude = record.Longitude,
                        StartingPrice = 0, // Default, as not in CSV
                        Rate = record.Rate,
                        ThumbnailUrl = _defaultThumbnailUrl,
                        ImageUrls = new List<string>()
                    };

                    // Handle images
                    var folderName = SanitizeFileName(record.Name);
                    var hotelFolderPath = Path.Combine(_seedImagesPath, folderName);
                    if (Directory.Exists(hotelFolderPath))
                    {
                        var imageFiles = Directory.GetFiles(hotelFolderPath)
                            .Where(f => new[] { ".jpg", ".jpeg", ".png", ".gif", ".webp" }
                            .Contains(Path.GetExtension(f)?.ToLowerInvariant()))
                            .OrderBy(f => f)
                            .ToList();

                        // Assign first valid image as ThumbnailUrl
                        if (imageFiles.Any())
                        {
                            try
                            {
                                hotel.ThumbnailUrl = await CopyFileAsync(imageFiles[0], "hotels/thumbnails");
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
                                var imageUrl = await CopyFileAsync(imagePath, "hotels/images");
                                hotel.ImageUrls.Add(imageUrl);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine($"Failed to copy image for {record.Name} at {imagePath}: {ex.Message}");
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine($"Image folder not found for {record.Name} at {hotelFolderPath}");
                    }

                    _context.Hotels.Add(hotel);
                    Console.WriteLine($"Added {record.Name} in {hotel.City} to database.");
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                Console.WriteLine("Hotel seeding completed.");
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