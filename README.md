# R7alh – Smart Tourism Platform

**R7alh** is a full-stack tourism platform designed to simplify travel planning, enhance cultural experiences, and provide real-time support for travelers—starting with Egypt and expanding globally. Built as a graduation project at Assiut University, R7alh combines a modern web interface, mobile app, AI-powered recommendations, and secure backend services into one seamless experience.

🌍 **Goal**: Make travel smarter, safer, and more personalized using technology.

---

## 📁 Project Structure (Monorepo)

This repository contains all components of the R7alh system:

```
R7alh/
├── backend/       → .NET Core 8 API (C#)
├── frontend/      → React web application
├── ai-api/        → Python Flask AI engine (recommendations & place recognition)
├── flutter-app/   → Flutter mobile app
└── README.md      → You are here!
```

Each module is developed to work together while remaining independent for team collaboration.

---

## 🚀 Key Features

- **Personalized Travel Recommendations** (AI-powered)
- **Explore Destinations**: Hotels, restaurants, historical sites
- **Real-Time Safety & Event Updates**
- **Tour Booking & Budget Management**
- **Camera-Based Place Recognition** (Learn about landmarks by pointing your camera)
- **Multilingual Support & Translation**
- **User Reviews & Ratings**
- **Offline Access & Emergency Info**

Designed with Egyptian tourism in mind, with global scalability.

---

## 🛠️ Technologies Used

| Component     | Tech Stack |
|--------------|-----------|
| **Backend**  | .NET Core 8, C#, Entity Framework, JWT, SQL Server |
| **Frontend** | React, Tailwind CSS, Axios |
| **AI Engine**| Python, Flask, Scikit-learn / Deep Learning (for recommendations & image recognition) |
| **Mobile App**| Flutter, Dart, Firebase |
| **Deployment**| Docker, Azure / AWS (planned) |

Integrated via RESTful APIs and real-time data sync.

---

## 🧪 Getting Started (For Developers)

### Prerequisites
- .NET 8 SDK
- Node.js & npm
- Python 3.8+
- Flutter SDK
- Git

### Setup Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/MohamedMostafa21/R7alh.git
   cd R7alh
   ```

2. Set up each component:
   - **Backend**: See `/backend/README.md`
   - **Frontend**: See `/frontend/README.md`
   - **AI API**: See `/ai-api/README.md`
   - **Flutter App**: See `/flutter-app/README.md`

3. Configure environment variables using `.env.example` files.

4. Run services and connect them via API endpoints.

> 🔐 Never commit `.env` or API keys.

---

## 🤝 Contributing

We welcome contributions! Please follow:
1. Fork the repo
2. Create a feature branch: `git checkout -b feature/new-login-flow`
3. Commit changes: `git commit -m "feat: add login validation"`
4. Push: `git push origin feature/new-login-flow`
5. Open a Pull Request

Follow coding standards and include clear descriptions.

---

## 👤 Developer

- **Mohamed Mostafa**  
  Full-Stack & AI Developer | Assiut University Graduate  
  [LinkedIn](https://www.linkedin.com/in/mohamedmostafa21/)

---

## 📄 License

This project is licensed under the **MIT License**.  
See [LICENSE](LICENSE) for details.
```

