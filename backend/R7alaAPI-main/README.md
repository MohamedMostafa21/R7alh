# R7alah Backend - Travel Platform API

The R7alah Backend is the core API for **R7alah**, a smart tourism platform developed as a graduation project at Assiut University. Built entirely by Mohamed Mostafa using .NET Core 8.0 and C#, this robust and scalable API powers personalized recommendations, booking services, tour guide management, and real-time updates for restaurants, hotels, and tourist attractions in Egypt, with plans for global expansion. Integrated with a Flask-based machine learning engine, the backend serves as the backbone for the R7alah Flutter mobile app and React front-end website, delivering a seamless, user-centric travel planning experience.

## Table of Contents
- [Features](#features)
- [Technologies](#technologies)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Contributing](#contributing)
- [Contributors](#contributors)
- [Related Repositories](#related-repositories)
- [License](#license)

## Features
The R7alah Backend provides a comprehensive set of features to enhance the travel experience, addressing common challenges like planning, budgeting, and accessing reliable information:

- **Personalized Recommendations**: Integrates with a Flask-based machine learning engine to deliver tailored suggestions for restaurants, hotels, and tourist attractions, leveraging user preferences and favorited items stored in the database (`POST /api/recommendations/recommend`).
- **Destination and Attraction Management**: Manages detailed data for destinations, historical sites, hotels, and restaurants, providing comprehensive information, images, and reviews to help users explore iconic landmarks and cultural attractions (`GET /api/recommendations/restaurants`, `GET /api/recommendations/hotels`, `GET /api/recommendations/places`).
- **User Reviews and Ratings**: Enables travelers to submit reviews and ratings for destinations, services, and accommodations, stored and retrieved via endpoints like `POST /api/reviews`, to support informed decision-making.
- **Accommodation and Transportation Booking**: Facilitates booking through endpoints (e.g., `POST /api/bookings/hotels`, `POST /api/bookings/transportation`), offering price comparisons, detailed descriptions, and user reviews to ensure budget-friendly and convenient choices.
- **Tour Guide Management System**: Supports tour guide applications with admin endpoints for approval (`POST /api/admin/tourguide-applications/{id}/approve`), rejection (`POST /api/admin/tourguide-applications/{id}/reject`), and revocation (`POST /api/admin/tourguides/{id}/revoke`), ensuring high-quality, trustworthy guides.
- **Real-Time Updates**: Provides live updates on weather, local events, and travel advisories, integrated via external APIs and cached in the database for performance (`GET /api/updates/weather`, `GET /api/updates/events`).
- **Secure Authentication**: Utilizes ASP.NET Identity with JWT for secure access to protected endpoints, supporting user and admin roles (`POST /api/auth/login`).
- **Scalable Architecture**: Leverages Entity Framework Core for efficient database operations and a modular design to handle thousands of users and diverse datasets with high performance.
- **Comprehensive Data Management**: Manages complex data for restaurants, hotels, places, reviews, meals, rooms, activities, and tour guides, ensuring seamless integration with the Flutter app and React front-end.
- **RESTful API Design**: Offers well-documented RESTful endpoints for recommendations, bookings, user management, and admin operations, ensuring compatibility with mobile and web clients.

## Technologies
- **Framework**: .NET Core 8.0 (C#) for API development
- **ORM**: Entity Framework Core for database management
- **Database**: SQL Server/PostgreSQL for data storage
- **Authentication**: ASP.NET Identity with JWT
- **Integration**: Flask (Python) for the machine learning recommendation engine
- **Dependencies**:
  - Microsoft.EntityFrameworkCore
  - Microsoft.AspNetCore.Identity.EntityFrameworkCore
  - System.Net.Http.Json
- **Version Control**: Git
- **Configuration**: appsettings.json for environment-specific settings
- **Real-Time Features**: SignalR (in `Hubs` for potential real-time updates)

## Project Structure
```
R7alaAPI-main/
├── .vs/                          # Visual Studio configuration
├── .vscode/                      # VS Code configuration
├── Controllers/                  # API controllers (e.g., RecommendationsController, AdminController)
├── DTO/                          # Data transfer objects for API requests/responses
├── Data/                         # Database context (ApplicationDBContext)
├── Helpers/                      # Utility classes and helper methods
├── Hubs/                         # SignalR hubs for real-time features (e.g., live updates)
├── Migrations/                   # Entity Framework migrations
├── Models/                       # Data models (e.g., Restaurant, Hotel, TourGuide, Favorite)
├── Properties/                   # Project properties (e.g., launchSettings.json)
├── Seeding/                      # Data seeding scripts for initial database population
├── Services/                     # Business logic and service classes
├── wwwroot/Uploads/              # Storage for uploaded files (e.g., tour guide CVs, profile pictures)
├── bin/Debug/net8.0/             # Compiled binaries
├── obj/                          # Build artifacts
├── appsettings.json              # Configuration (database connection, Flask API URL)
├── appsettings.Development.json  # Development-specific configuration
├── Program.cs                    # Application entry point
├── R7alaAPI.csproj               # Project file
├── R7alaAPI.csproj.user          # User-specific project settings
├── R7alaAPI.http                 # HTTP request testing file
├── R7alaAPI.sln                  # Solution file
└── README.md                     # This file
```

## Setup Instructions

### Prerequisites
- **.NET Core**: Install .NET 8.0 SDK or later
- **Database**: SQL Server or PostgreSQL
- **Python**: Python 3.8+ for the Flask recommendation engine
- **Git**: For cloning the repository
- **IDE**: Visual Studio, VS Code, or equivalent

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/MohamedMostafa21/R7alh.git
   cd R7alh/backend/R7alaAPI-main
   ```

2. **Install Dependencies**:
   ```bash
   dotnet restore
   ```

3. **Configure the Database**:
   - Update `appsettings.json` with your database connection string and Flask API URL:
     ```json
     {
       "ConnectionStrings": {
         "DefaultConnection": "Server=localhost;Database=R7alaDB;Trusted_Connection=True;"
       },
       "FlaskApi": {
         "BaseUrl": "http://localhost:5000"
       }
     }
     ```
   - Apply migrations to create the database schema:
     ```bash
     dotnet ef database update
     ```

5. **Run the Backend**:
   ```bash
   dotnet run
   ```
   The API will be available at `http://localhost:5000`.

6. **Verify Setup**:
   - Test the health endpoint:
     ```bash
     curl http://localhost:5000/api/recommendations/health
     ```
   - Expected response: `{ "message": "Flask API is reachable", ... }`

## Usage
- **API Endpoints**:
  - **Health Check**: `GET /api/recommendations/health` - Verifies Flask API connectivity
  - **Recommendations**:
    - `GET/POST /api/recommendations/restaurants` - Fetches restaurant recommendations
    - `GET/POST /api/recommendations/hotels` - Fetches hotel recommendations
    - `GET/POST /api/recommendations/places` - Fetches tourist attraction recommendations
    - `POST /api/recommendations/recommend` - Fetches combined recommendations
  - **Bookings**:
    - `POST /api/bookings/hotels` - Books a hotel
    - `POST /api/bookings/transportation` - Books transportation
  - **Reviews**:
    - `POST /api/reviews` - Submits a user review
    - `GET /api/reviews/{type}/{id}` - Fetches reviews for a specific entity
  - **Admin Operations**:
    - `GET /api/admin/tourguide-applications` - Lists tour guide applications
    - `POST /api/admin/tourguide-applications/{id}/approve` - Approves an application
    - `POST /api/admin/tourguide-applications/{id}/reject` - Rejects an application
    - `POST /api/admin/tourguides/{id}/revoke` - Revokes tour guide status
    - `POST /api/admin/assign-admin` - Assigns admin role to a user
  - **Authentication**:
    - `POST /api/auth/login` - Authenticates users and returns a JWT token
  - Requires JWT authentication for protected routes (use `Authorization: Bearer <token>`).

- **Testing**:
  - Use Postman or curl to test endpoints:
    ```bash
    curl -H "Authorization: Bearer <token>" -H "Content-Type: application/json" \
         -X POST http://localhost:5000/api/recommendations/restaurants?page=1&pageSize=10
    ```
  - Example response:
    ```json
    {
      "TotalRestaurants": 10,
      "CurrentPage": 1,
      "PageSize": 10,
      "TotalPages": 1,
      "Restaurants": [ { "Id": 1, "Name": "Salsa Restaurant", ... }, ... ]
    }
    ```

- **Integration**:
  - The backend serves the [R7alah Flutter App](https://github.com/[YourRepo]/r7alah-flutter) and [React Front-End](https://github.com/[YourRepo]/r7alah-frontend).
  - Ensure the Flask API is running for recommendation endpoints.

## Contributing
Contributions to enhance the R7alah Backend are welcome! To contribute:
1. Fork the repository: `https://github.com/MohamedMostafa21/R7alh`
2. Navigate to the backend: `cd backend/R7alaAPI-main`
3. Create a feature branch: `git checkout -b feature/your-feature`
4. Commit changes: `git commit -m "Add your feature"`
5. Push to the branch: `git push origin feature/your-feature`
6. Open a pull request with a detailed description.

Please follow .NET coding standards (e.g., PascalCase for public members) and include tests for new features.

## Contributors
- **Mohamed Mostafa** ([LinkedIn](https://www.linkedin.com/in/mohamedmostafa21/)) - Sole developer of the backend, responsible for API design, implementation, database management, Flask integration, and feature development (recommendations, bookings, tour guide management)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
