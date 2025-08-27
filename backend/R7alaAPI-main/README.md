# R7alah Backend - Travel Recommendation API


The R7alah Backend is the core API for the R7alah travel recommendation platform, developed as a graduation project at [Your University Name]. Built entirely by Mohamed Mostafa using .NET Core and C#, this robust and scalable API powers personalized recommendations for restaurants, hotels, tourist attractions, and tour guide management, integrating seamlessly with a Flask-based machine learning engine. The backend serves as the backbone for the R7alah Flutter mobile app and React front-end website, enabling a seamless and user-centric travel planning experience.

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
The R7alah Backend provides a comprehensive set of features to support the travel recommendation platform:

- **Intelligent Recommendations**: Integrates with a Flask-based machine learning engine to deliver personalized suggestions for restaurants, hotels, and tourist attractions based on user preferences and favorited items stored in the database.
- **User Favorites Management**: Handles user interactions with favorited restaurants, hotels, and places via endpoints like `POST /api/recommendations/restaurants`, enabling tailored suggestions.
- **Tour Guide Management System**: Supports tour guide application submissions, with admin endpoints for approval (`POST /api/admin/tourguide-applications/{id}/approve`), rejection (`POST /api/admin/tourguide-applications/{id}/reject`), and revocation (`POST /api/admin/tourguides/{id}/revoke`) to ensure quality and trust.
- **Secure Authentication**: Utilizes ASP.NET Identity with JWT for secure access to protected endpoints, supporting both user and admin roles.
- **Scalable Architecture**: Leverages Entity Framework Core for efficient database operations and a modular design to handle thousands of users and diverse datasets with high performance.
- **Comprehensive Data Management**: Manages complex data for restaurants, hotels, places, reviews, meals, rooms, and activities, ensuring seamless integration with front-end clients.
- **RESTful API Design**: Offers well-documented RESTful endpoints for recommendations, user management, and admin operations, ensuring compatibility with mobile and web clients.

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

## Project Structure
```
R7alaAPI-main/
├── .vs/                          # Visual Studio configuration
├── .vscode/                      # VS Code configuration
├── Controllers/                  # API controllers (e.g., RecommendationsController, AdminController)
├── DTO/                          # Data transfer objects for API requests/responses
├── Data/                         # Database context (ApplicationDBContext)
├── Helpers/                      # Utility classes and helper methods
├── Hubs/                         # SignalR hubs (if applicable, e.g., for real-time features)
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
  - **Admin Operations**:
    - `GET /api/admin/tourguide-applications` - Lists tour guide applications
    - `POST /api/admin/tourguide-applications/{id}/approve` - Approves an application
    - `POST /api/admin/tourguide-applications/{id}/reject` - Rejects an application
    - `POST /api/admin/tourguides/{id}/revoke` - Revokes tour guide status
    - `POST /api/admin/assign-admin` - Assigns admin role to a user
  - Requires JWT authentication for protected routes. Obtain a token via `POST /api/auth/login`.

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
- **Mohamed Mostafa** ([LinkedIn](https://www.linkedin.com/in/mohamedmostafa21/)) - Sole developer of the backend, responsible for API design, implementation, database management, and Flask integration
