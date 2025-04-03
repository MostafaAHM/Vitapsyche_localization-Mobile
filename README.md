# VitaPsyche-Graduation-Project-mobile
---
### Flutter Mobile App Features
- **Responsive UI**: Ensures the app works seamlessly on different devices with various screen sizes.  
- **State Management**: Implemented using **Provider** or **BLoC** for clean and efficient code architecture.  
- **Offline Mode**: Certain features are accessible even without an internet connection, ensuring usability in all situations.  
- **Secure Storage**: Sensitive user data is securely stored using **flutter_secure_storage** or similar libraries.  
- **Chat Integration**: The chatbot is embedded into the app for seamless user interaction without leaving the platform.  
- **Interactive Charts**: Visual representations of user assessments and progress over time for better engagement.  


---

### Flutter Setup Instructions
1. **Clone and Navigate to Mobile Directory**  
   ```bash
   git clone https://github.com/MohammedAbdElfatah0/VitaPsyche-Graduation-Project-mobile.git
   cd VitaPsyche-Graduation-Project-mobile
   ```
2. **Install Dependencies**  
   ```bash
   flutter pub get
   ```
3. **Run the App**  
   Ensure your emulator or connected device is active:  
   ```bash
   flutter run
   ```
4. **Clean Build** *(optional)*  
   To ensure no cached issues:  
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---
## Directory Structure

```plaintext
lib/
├── core/                # Core layer for shared and general utilities
│   ├── errors/          # Custom exceptions and error handling
│   ├── utils/           # General helper classes and utility functions
│   ├── themes/          # App themes and design system
│   ├── constants/       # Application-wide constants (e.g., API URLs, colors, etc.)
│   └── widgets/         # Reusable widgets used across the app
│
├── features/            # Feature modules for different parts of the app
│   ├── auth/            # Authentication feature
│   │   ├── data/        # Data layer
│   │   │   ├── models/  # Data models
│   │   │   ├── datasources/ # Local/Remote data sources
│   │   │   └── repositories/ # Repository implementations
│   │   ├── domain/      # Domain layer
│   │   │   ├── entities/ # Core entities for the feature
│   │   │   └── usecases/ # Business logic use cases
│   │   ├── presentation/ # Presentation layer
│   │       ├── screens/  # Screens for UI
│   │       ├── widgets/  # Widgets for the feature
│   │       └── providers/ # State management
│   │
│   ├── chat/            # Chat feature (similar structure as auth)
│   ├── profile/         # Profile feature
│   └── home/            # Home feature
│
└── main.dart            # Entry point of the application
```

---

## Explanation of Layers

### Core Layer
The **Core Layer** contains code that is shared across multiple features:
- `errors/`: Custom exception classes for error handling.
- `utils/`: Helper classes for common operations.
- `themes/`: Centralized app theme definitions.
- `constants/`: Application-wide constants like API URLs, colors, etc.
- `widgets/`: Reusable UI components not tied to a specific feature.

### Features Layer
The **Features Layer** is where each app feature/module is defined, and each feature follows the Clean Architecture layers:
1. **Data Layer**: 
   - Handles data fetching, storage, and transformation.
   - Includes models, data sources (e.g., API, database), and repositories.
2. **Domain Layer**:
   - Focused on business logic and independent of frameworks.
   - Contains use cases (business logic) and entities (core objects).
3. **Presentation Layer**:
   - Handles UI and state management.
   - Includes screens, widgets, and providers for state management.

---

## Benefits of this Structure
- **Scalability**: Adding new features without affecting existing ones is easy.
- **Maintainability**: Clear separation of concerns ensures code is easier to debug and test.
- **Reusability**: Shared utilities and widgets can be reused across features.
- **Testability**: Business logic and UI are decoupled, making it easier to write unit tests.
  
### Flutter Libraries Used

This project utilizes the following libraries to enhance functionality and streamline development:

- **[animated_splash_screen](https://pub.dev/packages/animated_splash_screen)**: Adds beautifully animated splash screens to the app.  
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)**: Provides Cupertino icons for iOS-style widgets.  
- **[firebase_core](https://pub.dev/packages/firebase_core)**: Essential for integrating Firebase services.  
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**: State management solution based on the BLoC pattern.  
- **[flutter_email_sender](https://pub.dev/packages/flutter_email_sender)**: Facilitates sending emails directly from the app.  
- **[flutter_screenutil](https://pub.dev/packages/flutter_screenutil)**: Simplifies responsive UI design for different screen sizes.  
- **[flutter_tts](https://pub.dev/packages/flutter_tts)**: Provides Text-to-Speech capabilities.  
- **[fluttertoast](https://pub.dev/packages/fluttertoast)**: Displays customizable toast messages.  
- **[google_fonts](https://pub.dev/packages/google_fonts)**: Enables the use of Google Fonts in the app.  
- **[google_maps_flutter](https://pub.dev/packages/google_maps_flutter)**: Integrates Google Maps into the app.  
- **[http](https://pub.dev/packages/http)**: Simplifies API integration and data fetching.  
- **[intl](https://pub.dev/packages/intl)**: Handles date formatting, internationalization, and localization.  
- **[model_viewer_plus](https://pub.dev/packages/model_viewer_plus)**: Displays 3D models (`.glb`/`.gltf`) in Flutter.  
- **[page_transition](https://pub.dev/packages/page_transition)**: Provides smooth page transition animations.  
- **[permission_handler](https://pub.dev/packages/permission_handler)**: Manages runtime permissions for the app.  
- **[provider](https://pub.dev/packages/provider)**: State management solution for managing application state.  
- **[shared_preferences](https://pub.dev/packages/shared_preferences)**: Stores small amounts of data locally on the device.  
- **[smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator)**: Displays customizable page indicators.  
- **[speech_to_text](https://pub.dev/packages/speech_to_text)**: Converts speech to text for voice input.  
- **[cached_network_image](https://pub.dev/packages/cached_network_image)**: Efficiently loads and caches network images.

---

### Upcoming Features (Flutter)
- **AI-Driven Personal Insights**: Integrate AI models into the mobile app for on-the-go mental health insights.  
- **Calendar and Reminders**: A built-in calendar to track appointments, sessions, and assessments.  
- **Interactive Animations**: Leverage  animations for a more engaging UI.  
---
