# Travel Buddy

## Description
Travel Buddy is a Flutter app that lets users explore and book travel accommodations, similar to Airbnb. It supports two roles: hosts who can add and manage listings, and guests who can search, browse, and book places.

Guests can filter listings by category, view detailed information, and see all places pinned on a map. The app also includes favorites, reservation tracking, and profile management.

Built with Firebase for authentication, data storage, and image hosting, and integrated with Google Maps for location features, Travel Buddy offers a smooth booking experience. It also features a basic local chatbot powered by LLaMA 2 to help users with app-related questions.

---

## Features

- **Authentication**  
  - Firebase Auth with Google Sign-In support

- **Dual Roles**  
  - **Guests** can search, favorite, book places and leave reviews 
  - **Hosts** can add and manage listings

- **Explore & Search**  
  - Scrollable list of available places  
  - Search by name or address  
  - Filter by category (e.g., beach, city, mountain)

- **Map View**  
  - Google Maps integration  
  - Pins show all available listings  
  - Clickable markers with quick info

- **Place Details & Booking**  
  - Full information screen about each listing  
  - Date selection and booking functionality

- **Favorites**  
  - Mark and view your favorite listings

- **Reservations**  
  - View all your current and past bookings
  - Leave a review after your stay

- **Host Listings**  
  - Hosts can manage and add listings via a dedicated interface

- **Profile Screen**  
  - View user information

- **In-App Help Chat**  
  - Local LLaMA 2-based chatbot assistant providing app support (basic functionality)

---

## Tech Stack

- **Frontend**: Flutter  
- **Backend**: Firebase  
  - Firestore (data storage)  
  - Firebase Storage (image uploads)  
  - Firebase Authentication (with Google Sign-In)  
- **Maps**: Google Maps SDK  
- **AI Assistant**: LLaMA 2 (local)

---

## Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/akrango/TravelBuddy.git
cd TravelBuddy
```
### 2. Install Dependencies
```bash
flutter pub get
```
### 3. Firebase Setup
- Create a Firebase project at Firebase Console

Enable:

- **Firestore Database**

- **Firebase Storage**

- **Firebase Authentication** (Email/Password & Google Sign-In)


#### Download and place the following files:

- google-services.json in android/app/

#### Ensure your android/build.gradle and android/app/build.gradle are configured for Firebase.

### 4. Local LLaMA 2 Setup
The app uses a local LLaMA 2 model for the in-app help chatbot. You need to download and set up LLaMA 2 on your device separately to enable this feature. Please refer to the official LLaMA 2 repository or [documentation](https://ollama.com/download) for installation instructions.

### 5. Run the app
```bash
flutter run
```

### Folder structure
```
lib/
├── screens/           # UI screens (Explore, Map, Favorite, Help Chat, Details, etc.)
├── models/            # Data models
├── services/          # Firebase & API interactions
├── components/        # Reusable components
├── utils/             # Constants and utilities
├── authentication/    # Auth-related logic
```
### Known Issues
- Help chatbot (LLaMA 2) is basic and locally integrated, with limited answers

