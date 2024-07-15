# Marvel Comic Characters App

This tvOS app showcases Marvel comic characters and their associated comics using the Marvel API. Built with SwiftUI and following a SwiftUI-first architecture, this project demonstrates modern iOS development practices without relying on third-party frameworks.

## Features

- Browse popular Marvel characters
- View detailed information about each character
- Explore comics associated with each character
- Favorite characters with animated button feedback

## Project Structure

### Swift Package Manager (SPM)

This project uses Swift Package Manager for dependency management and modularization. The core functionality is organized into several modules:

- `Core`: Contains basic models and protocols
- `API`: Handles network requests and API integration
- `Services`: Implements business logic and data management
- `CommonUI`: Provides reusable UI components
- `AppUI`: Contains the main app UI components
- `LiveApp`: Manages the live app configuration and dependency injection

### Platform Agnostic Core

While the UI is specifically designed for tvOS, the core functionality (including API interactions, data models, and business logic) is platform-agnostic. This design choice allows for:

- Easy adaptation to other Apple platforms (iOS, macOS, watchOS)
- Improved testability of core components
- Clear separation between business logic and UI concerns

## Architecture

### SwiftUI-First Architecture with MV Pattern

This project embraces a SwiftUI-first architecture, which aligns with the Model-View (MV) pattern. This approach leverages SwiftUI's native capabilities to their fullest, offering several key benefits:

1. **Direct Connection**: The View layer connects directly to the Model layer, eliminating the need for intermediate abstractions like ViewModels.
2. **State Management**: Utilizes SwiftUI's `@State`, `@Binding`, and `@Published` property wrappers for efficient and reactive state management.
3. **Declarative UI**: Takes full advantage of SwiftUI's declarative syntax, making the UI code more intuitive and maintainable.
4. **Reduced Boilerplate**: Minimizes repetitive code by leveraging SwiftUI's built-in behaviors and lifecycle management.
5. **Enhanced Testability**: Facilitates easier testing of UI components and logic through SwiftUI's preview system and isolated state management.
6. **Improved Performance**: Utilizes SwiftUI's efficient update mechanism, reducing unnecessary view updates.
7. **Flexibility**: Allows for easy adaptation to new SwiftUI features and patterns as they are introduced.

### Dependency Injection

Dependency injection is implemented throughout the app using protocols and factory methods. SwiftUI provides several mechanisms to enable efficient dependency injection:

- **Environment**: Uses the `@Environment` property wrapper to inject dependencies across the view hierarchy.
- **EnvironmentObject**: Employs `@EnvironmentObject` for sharing observable objects throughout the app.
- **View Modifiers**: Custom view modifiers are used to inject dependencies into views.
- **Factory Protocols**: Defines protocols for screen factories, allowing easy substitution of mock implementations for testing.

These mechanisms allow for:
- Improved modularity and flexibility
- Enhanced testability through easy substitution of mock objects
- Simplified management of app-wide state and services

## Data Flow

Understanding the data flow in this SwiftUI-first architecture is crucial for grasping how the app functions. Here's an overview of how data moves through the system:

### 1. API Interaction
- The `MarvelAPIClient` in the `API` module is responsible for making network requests to the Marvel API.
- It uses `async/await` for efficient, non-blocking network calls.

### 2. Service Layer
- The `MarvelService` in the `Services` module acts as an intermediary between the API and the UI.
- It processes raw API data and transforms it into app-specific models.
- Error handling and data caching (if implemented) occur at this level.

### 3. State Management
- The app uses SwiftUI's state management tools (`@State`, `@Binding`, `@Published`) to hold and update data.
- `AppState` serves as a centralized store for app-wide data, accessible via `@EnvironmentObject`.

### 4. View Updates
- Views observe changes in the state and automatically update when data changes.
- This reactive approach ensures the UI always reflects the current app state.

### 5. User Interactions
- User actions (e.g., selecting a character, favoriting) are handled by views.
- These actions can trigger state updates or service calls.

### 6. Data Persistence
- Favorited characters are stored locally (e.g., in UserDefaults or a local database).
- This persistent data is loaded into the app state on launch.

### Flow Example: Loading Character List
1. The main view requests character data on appearance.
2. This request goes through the `MarvelService`.
3. `MarvelService` uses `MarvelAPIClient` to fetch data from the API.
4. Retrieved data is processed and stored in the app's state.
5. Views observing this state automatically update to display the new data.

### Flow Example: Favoriting a Character
1. User taps the favorite button on a character.
2. The view calls a method in `AppActions` (injected via environment).
3. This action updates the local storage and the app's state.
4. The updated state triggers a UI refresh, showing the new favorite status.

This data flow architecture ensures:
- Clear separation of concerns
- Efficient updates with minimal boilerplate
- Easy testability of each component
- Scalability for adding new features or data sources

By following this flow, the app maintains a unidirectional data flow, which simplifies debugging and ensures consistency across the UI.

## Key Technologies

### Combine

Combine is used to add smooth animations to the Favorite button. A timer publisher drives the animation, creating a pulsing effect when a character is favorited. This demonstrates how Combine can be integrated with SwiftUI for reactive and efficient UI updates.

### Async/Await

The project extensively uses Swift's modern concurrency model with async/await for network calls and other asynchronous operations. This approach:

- Improves code readability and maintainability
- Simplifies error handling with structured error propagation
- Enhances performance through structured concurrency
- Aligns well with SwiftUI's declarative nature for handling asynchronous tasks

## Testing

### Unit Tests for MarvelService

The `MarvelService` is thoroughly unit tested, covering both success and failure scenarios for its key methods. The tests utilize:

- **Spy Objects**: `MarvelAPIClientSpy` and `ErrorAlertSpy` are used to monitor method calls and capture outputs.
- **Factory Method**: A `makeSUT` (System Under Test) factory method is employed to create consistent test setups.
- **JSON Fixtures**: Real API response structures are used as test fixtures to ensure accurate data handling.

Benefits of this testing approach include:

- Isolated testing of the service layer
- Verification of correct API client usage
- Validation of error handling mechanisms
- Assurance of proper data processing

## Getting Started

1. Clone the repository
2. Open the project in Xcode
3. Copy `Configuration.template.swift` to `Configuration.swift`
4. Obtain API keys from [developer.marvel.com](https://developer.marvel.com)
5. Add your Marvel API public and private keys to `Configuration.swift`
6. Build and run the project on a tvOS simulator or device
