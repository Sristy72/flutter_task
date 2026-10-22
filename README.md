Project Overview
This project is a Flutter application built using Dart. It follows a feature-based folder structure and uses BLoC for state management. The project integrates Firebase for authentication and other Firebase services as required. It communicates with backend APIs for application data and business logic.

Technologies Used
 - Flutter: Cross-platform UI development
 - Dart: Programming language
 - flutter_bloc: State management
 - Firebase: Authentication and other configured Firebase services
 - REST API: Backend communication
 - Dio: HTTP requests (if configured)
 - Git & GitHub: Version control

Flutter and Dart Versions
 - Flutter 3.44.8
 - Dart 3.12.2

How to Run the Project
 Step 1: Clone the Repository
 Step 2: Navigate to the Project
 Step 3: Install Dependencies
 Step 4: Configure Firebase
 Step 5: Check Available Devices
 Step 6: Run the Application

Folder structure Explain
Here is the folder structure

lib/
├── core/
│   ├── common/
│   ├── constants/
│   ├── di/
│   │   └── injection.dart
│   ├── network/
│   │   ├── constants/
│   │   │   ├── api_constant.dart
│   │   │   └── storage_constants.dart
│   │   ├── services/
│   │   │   ├── auth_storage_service.dart
│   │   │   └── secure_storage_service.dart
│   │   ├── api_client.dart
│   │   └── api_exception.dart
│   ├── notification/
│   │   ├── notification_service.dart
│   │   └── notification_navigation.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   └── navigation_menu/
│       ├── navigation_bloc/
│       ├── main_screen_view.dart
│       └── navigation_menu.dart
│
├── main.dart
└── firebase_options.dart

android/
ios/
assets/
test/
pubspec.yaml


core/ - Shared application logic and utilities

di/injection.dart - Instead of blocs and repositories manually instantiating their dependencies, GetIt provides a central service locator.
It Registers singletons (SecureStorageService, AuthStorageService, ApiClient, GoogleAuthService, AuthRepository, HomeRepository).
Registers factory instances for BLoCs (AuthBloc, HomeBloc) so fresh state management is maintained.

api_client.dart - Centralizes all HTTP operations (GET, POST, PUT, DELETE) using http. 

api_exception.dart - Custom exception model capturing HTTP status code, API error message, and error payload so BLoCs can display user-friendly error messages.

api_constant.dart - Stores base URLs and API endpoints (e.g., /auth/login, /auth/register, /prayer/dashboard).

storage_constants.dart - String key constants for storage (e.g., accessTokenKey, refreshTokenKey, userDataKey).

secure_storage_service.dart - Low-level wrapper around encrypted storage (flutter_secure_storage) for sensitive credentials on iOS Keychain and Android Keystore.
auth_storage_service.dart - Higher-level authentication session manager. Provides methods like saveToken(), getToken(), saveUser(), isLoggedIn(), and clearAuthData().

notification/ - notification_service.dart is the control center for all notifications in the app.
Asks Permission: Prompts the user (Allow notifications?) on Android 13+ and iOS.
Gets the FCM Token: Generates the phone's unique "address" so Firebase knows where to send notifications.
Handles All 3 App States:
App Open (Foreground): Catches the message and forces a heads-up pop-up banner so the user sees it immediately.
App Minimized (Background): Shows in the top status bar; tapping it brings the user back into the app.
App Closed (Terminated): Wakes up the app and displays the notification.
Deep Linking: Tapping a notification opens the exact target screen (e.g. /home) sent inside the message data.

How Firebase Push Notifications actually working in the app (in 3 Simple Steps)

Sending: i am sending a message from the Firebase Console.
Delivery: Google's servers send the message directly to phone's operating system (Android / iOS).
Display & Action: If users are outside the app: The phone's status bar displays the notification.
If users are inside the app:NotificationService displays a banner at the top of the screen.
When tapped: The app reads the payload and takes the user straight to that screen.

app_routes.dart - Holds route name constants (/, /login, /signup, /verify-email, /home, /nav-bar). Prevents typos in screen navigation.
app_router.dart - Handles dynamic route resolution using onGenerateRoute. Contains a custom PageRouteBuilder transition with a dark background (#0C0E0D) to prevent white screen flashes during page transitions in dark mode.

theme/ - contains colours, dimensions, icons, app_theme for the whole app

/navigation_menu/ - The navigation module manages the bottom navigation bar and persistent screen swapping
main_screen_view.dart - Contains an IndexedStack or page switcher holding the 5 tabs: Home, Community, Reflect, Prayer, and Logout. 
Listens to NavigationMenuBloc and AuthBloc. When index 4 (Logout) is tapped, it displays the logout confirmation dialog. When logout succeeds, it redirects to the login screen and clears the navigation stack.


navigation_menu.dart - Implements the dark themed, rounded bottom navigation bar
navigation_bloc/ - Handles tab switching events and preserves the previous index when the user cancels logout.


Each feature handles a specific business requirement and has its own data models, repository, BLoC, and UI screens.
splash_screen.dart - Introduction screen with logo and entry animations. Directs the user to login or checks onboard status.

google_auth_service.dart - Interacts with google_sign_in package to prompt the native Google account picker.

repository/auth_repository.dart - Orchestrates network calls via ApiClient and saves tokens using AuthStorageService.
auth_bloc - Processes auth actions, updates loading/success/error statuses, and manages user session.

in the auth screens their is showing these features  onboarding, user sign-in, registration, email OTP verification, guest mode, apple sign in and Google Sign-in.
in the home screen Displays prayer times, tracking, daily goals, reflections, and shortcuts.

save_location_request_model.dart - Sends user coordinates or city name to fetch localized prayer timings.
location_response_model.dart - Parses reverse-geocoded location data.

prayer_dashboard_response_model.dart - Parses the full dashboard JSON (prayer times for Fajr, Dhuhr, Asr, Maghrib, Isha, active prayer countdown, streaks, and tracker records).

home_repository.dart - Calls home dashboard endpoints, caches/fetches prayer information, and updates tracked prayers.
home_bloc/ - Manages dashboard loading, prayer status toggling, and data refresh.

Code was written this way because UI never calls HTTP requests directly. UI calls BLoC >  BLoC calls Repository > Repository calls ApiClient. So High testability; UI can be redesigned without touching business or network logic.
All common components (buttons, text inputs, colors, dialogs) live in core/. So Changes to a color or button style update across the entire app automatically.
New features (e.g., Community or Quran) can be added as a separate folder under features/ without breaking existing code.
Auth tokens are stored via encrypted secure storage (flutter_secure_storage). Credentials are safe against unauthorized inspection on physical devices.


State Management

The project uses BLoC (Business Logic Component) for state management through the flutter_bloc package. BLoC separates UI code from business logic, making the application easier to test, maintain, and extend.

Main BLoC Components

Event: Represents an action requested by the UI.
BLoC: Receives events, executes business logic, and emits states.
State: Represents the current UI condition.
BlocProvider: Provides a BLoC instance to its widget subtree.
BlocBuilder: Rebuilds the UI when relevant states change.
BlocListener: Handles one-time effects such as navigation, dialogs, and snackbars.
BlocConsumer: Combines BlocBuilder and BlocListener.


Firebase Setup
Step 1: Create or Select a Firebase Project
Step 2: Verify Application Identifiers
 - For Android, check the applicationId in the app-level Gradle configuration.
 - For iOS, check the Bundle Identifier in Xcode.
 - These identifiers must match the applications registered in Firebase.
Step 3: Install Firebase CLI and FlutterFire CLI
Step 4: Authenticate with Firebase
Step 5: Configure the Firebase Project
Step 6: Initialize Firebase 
 - In main.dart, initialize Firebase before using Firebase services
Step 7: Configure Required Firebase Services 
 - Enable the Firebase services required by the application


Switching Between Firebase Projects

Step 1: Select the Target Firebase Project
Step 2: Select or Configure the Target Project
Step 3: Verify Configuration Files
 - Check that the following point to the intended Firebase project:
 - lib/firebase_options.dart
 - android/app/google-services.json
 - ios/Runner/GoogleService-Info.plist
Step 4: Rebuild the Application
flutter clean
flutter pub get
flutter run

Step-by-Step Guide to Adding a New Feature
Step 1: Understand the Requirement
Step 2: Create the Feature Folder
Step 3: Create Request and Response Models
Step 4: Implement the Repository
Step 5: Create BLoC Events
Step 6: Create BLoC States
Step 7: Implement the BLoC
Step 8: Register Dependencies
Step 9: Build the UI
Step 10: Add Navigation
Step 12: Review and Commit

Important
I tried to implement Google Sign-In and Sign-Up by following all the steps you provided. However, when I tested the functionality, it consistently showed an “Invalid Token” error. I reviewed the entire code, but I couldn’t find any mistakes.
So i implemented this but its not working.