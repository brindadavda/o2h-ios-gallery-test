# GalleryApp (iOS SwiftUI)

An iOS gallery application built using **SwiftUI + MVVM** with Google authentication, online image pagination, and offline caching support.

---

## 📌 Submission Details

- **Project Name:** GalleryApp
- **Repository URL (GitHub):** `https://github.com/brindadavda/o2h-ios-gallery-test.git`  

---

## ✨ Features

- Google Sign-In integration (OAuth via GoogleSignIn SDK)
- Paginated image gallery from Picsum API
- Offline support:
  - Metadata stored in Core Data 
  - Downloaded images cached in local app storage
- Profile screen with logout
- Clean architecture with dependency injection (`AppEnvironment`)

---

## 🧱 Architecture

- **Pattern:** MVVM
- **Data Flow:** View → ViewModel → Repository → Services
- **Main Layers:**
  - `Features/` → UI screens and view models
  - `Data/` → API service, auth service, repository, cache
  - `Persistence/` → Core Data stack
  - `Core/` + `Domain/` → models, protocols, app errors

---

## 🌐 API Used

- Picsum public endpoint:
  - `https://picsum.photos/v2/list?page={page}&limit={limit}`

---

## 📦 Third-Party Dependencies

This project uses Swift Package Manager dependencies:

1. **GoogleSignIn-iOS**
   - Products used: `GoogleSignIn`, `GoogleSignInSwift`
   - Repository: `https://github.com/google/GoogleSignIn-iOS`
   - Version rule: `upToNextMajorVersion` from `9.1.0`

2. **Kingfisher**
   - Product used: `Kingfisher`
   - Repository: `git@github.com:onevcat/Kingfisher.git`
   - Version rule: `upToNextMajorVersion` from `8.8.1`

---

## ⚙️ Setup & Run

### Prerequisites

- Xcode 15+
- iOS 16+ simulator/device
- Apple developer account (for real Google Sign-In testing on device)

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/brindadavda/o2h-ios-gallery-test.git
   cd GalleryApp
   ```

2. Open the project in Xcode:

   ```bash
   open GalleryApp.xcodeproj
   ```

3. Resolve Swift packages (if not auto-resolved):
   - In Xcode: **File → Packages → Resolve Package Versions**

4. Configure Google Sign-In values in app configuration (`Info.plist`/build settings):
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_REDIRECT_URI`

5. Run the app on simulator/device.

---

## 🔐 Google Sign-In Notes

Google client configuration reference used during setup:

- https://console.cloud.google.com/auth/clients/create?project=pacific-decoder-393806

For a production-ready app:
- Add `GoogleService-Info.plist` as required by your OAuth setup.
- Register URL schemes correctly.
- Use matching reversed client ID redirect URI.

---

## 🧪 Expected Output / App Flow

1. **Launch Screen / Login**
   - User sees login view.
   - Can sign in with Google or fallback demo login.
   - Screen : 
   <img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/3059dc27-60cf-4889-ba8c-cebd930e1a9a" />

2. **Gallery Screen**
   - Paginated image list loads from Picsum.
   - Scrolling fetches additional pages.
   - Screen : 
   <img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/8d7b9a86-43e3-421e-969f-0e8e880b4c73" />

3. **Offline Behavior**
   - Previously loaded images and metadata remain visible without internet.

4. **Profile Screen**
   - User details/basic profile shown.
   - Logout returns to login screen.
   - Screen : 
   <img width="1206" height="2622" alt="image" src="https://github.com/user-attachments/assets/76210c3d-96ed-4ca2-b7b4-478b03c862e4" />

---

## 📝 Notes

- First online load is required to populate local cache.
- Offline mode only shows already downloaded/cached content.
- Core Data persists metadata between app launches.

---

## 👨‍💻 Author

- Brinda Davda
- https://github.com/brindadavda
