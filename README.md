# GitHub Repository Finder

This Flutter application allows users to search for GitHub repositories using keywords, view search results, and see detailed information about each repository.

## Features

- Search GitHub repositories using keywords
- Display search results in a clean, card-based UI
- View detailed repository information (name, owner, language, stars, watchers, forks, issues)
- Open repositories directly in a browser
- Support for dark and light themes
- Responsive layout for different screen sizes
- Pull-to-refresh and infinite scrolling pagination
- Error handling with retry functionality
- Smooth animations and transitions

## Technologies Used

- Flutter (latest stable version)
- Provider for state management
- HTTP package for API calls
- URL Launcher for opening links
- Material Design 3

## Project Structure

The application follows a clean architecture pattern with separation of concerns:

- **Models**: Data classes for repositories and search results
- **Services**: GitHub API service implementation
- **Providers**: State management using Provider
- **Screens**: UI screens for searching and viewing details
- **Widgets**: Reusable UI components
- **Utils**: Helper classes and constants
- **Config**: App configuration and theming

## Setup and Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run the application using `flutter run`

## Requirements

- Flutter (latest stable version)
- Dart SDK (latest stable version)
- Android SDK (for Android development)
- Xcode (for iOS development)

## API Usage

This application uses GitHub's public API for searching repositories. Specifically, it uses the `/search/repositories` endpoint as specified in the GitHub REST API v3.

## License

This project is open source and available under the MIT License.

## Acknowledgements

This project was created as part of a coding challenge for Yumemi Inc.