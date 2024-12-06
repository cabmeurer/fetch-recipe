# Recipe App Take Home Project

## Overview

This project is a recipe application that displays a list of recipes fetched from the provided API endpoints. Each recipe shows its name, cuisine type, and a small photo. The app allows users to refresh the list at any time by dragging the list down. It handles empty or malformed data gracefully and uses in-memory caching for images to reduce unnecessary network usage.

## Architectural Approach

The application is built using a **Model-View-ViewModel (MVVM)** architecture:

- **Model**: Represents the data structures for recipes and their responses.
- **View**: SwiftUI views that display the list of recipes and their details.
- **ViewModel**: Handles the business logic, including fetching and decoding data from the network, managing states (loading, error, empty), and providing data to the view.

### Separation of Concerns

- **View Models**: Contain the application logic and state management. They fetch data from services and transform it into a form suitable for the views.
- **Network Layer**: Uses `NetworkService` to make API calls and parse responses.
- **Image Layer**: Uses `ImageService` and a caching layer to efficiently load and cache images.
- **Models**: Define the data structures (`Recipe`, `RecipeResponse`, and errors) and ensure correct decoding from JSON.

## Trade-offs and Decisions

1. **Network Layer**:
   - **Trade-off**: Chose to use `URLSession` directly with `async/await` instead of relying on a third-party library like Alamofire.
   - **Reason**: Keeping dependencies minimal and code straightforward is suitable for a small take-home project and meets performance and testability requirements.

2. **Image Caching**:
   - **Trade-off**: Implemented a simple in-memory cache rather than a more complex disk-based caching solution.
   - **Reason**: The requirement states that recipes should not be stored on disk, and a simple memory cache suffices to reduce repeated network calls for images. This decision balances complexity and performance for this project size.

3. **Architecture (MVVM)**:
   - **Trade-off**: Used MVVM to clearly separate data logic from UI, making the code more testable.
   - **Reason**: MVVM enables better test coverage of logic (via view models and services) without complex UI testing, focusing on unit tests as requested.

## Running the Project

### Steps to Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/RecipeApp.git
   cd RecipeApp
   ```
2. **Open in Xcode**:
    Open fetch-recipe.xcodeproj in Xcode (iOS 16+ recommended).

3. **Build and Run**:
    Select the RecipeApp scheme and press Command+R to run the app in the simulator or on a connected device.

## Switching Endpoints

In the UI when the app launches there is a selection tab to allow selection of each endpoint. Alternatively, open the RecipeListViewModel or the NetworkService usage and change the endpoint argument (.valid, .invalid, .malformed, .empty) before running the app. The UI should adapt and display loading, error, or empty states accordingly.

### Third-Party Libraries and Copied Code

    - **No Third-Party Libraries**: This project does not rely on third-party libraries. It uses native SwiftUI, Combine, and Foundation frameworks.
    - **Copied Code**: The patterns and code structures (such as DecoderType, NetworkService, and testing approaches) are commonly used patterns and may have been influenced by personal experience, Apple documentation, and community best practices. Some solutions were derived with the help of AI (ChatGPT) to ensure adherence to best practices.

## Testing

### Unit Tests

The project includes unit tests to ensure correctness of core functionalities:
    - **NetworkServiceTests**: Validates how NetworkService handles various network responses (valid, invalid URLs, server errors, decoding errors).
    - **ImageServiceTests**: Tests ImageService logic for loading images from the network, caching, handling invalid URLs, and network errors.
    - **ModelsTests**: Separately tests models (Endpoint, Recipe, RecipeResponse, ImageServiceError, NetworkError, DecoderType) for correct decoding, equality, error messages, and endpoints.
    - **Mock Implementations**: Uses MockURLSession and MockImageCacheService for isolating and testing network and image loading logic without real network calls.

### Running Tests

    1. **Open the project in Xcode.**
    2. **Press Command+U to run all tests.**
    3. **Review the test results in the Xcode Test Navigator.**

## Known Issues and Future Improvements

Warnings in Unit Tests

No major UI-based warnings are expected since UI tests were not implemented. If implemented, some warnings may occur due to the limited environment in unit tests. These do not affect test validity but highlight UI environment differences.

## Future Improvements

    - **UI Enhancements**: Improve the visual layout, add more details (e.g., source URL link), and better empty/error states styling.
    - **Offline Support**: Implement a disk-based cache for images and possibly recipes (if allowed in the future).
    - **More Granular Error Handling**: Present user-friendly messages or retry options for network failures.

## Conclusion

    - **Time Spent**: Approximately 5-6 hours.
    - **Allocation**: Focused on setting up a clean architecture, concurrency with async/await, caching, and thorough unit testing for logic and models.
    - **Trade-offs**: Chose simplicity and testability over complex UI or disk caching solutions.

This project showcases a clean and testable codebase, using MVVM, Swift Concurrency, and no external dependencies. The tests ensure correctness of network, image loading, and model decoding logic. Additional UI polish and offline support could further enhance the user experience.
