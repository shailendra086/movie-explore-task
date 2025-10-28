# Movie Explorer

A Flutter application that allows users to explore movies using The Movie Database (TMDb) API. Features include movie browsing, searching, and detailed movie information with a beautiful Material Design 3 interface.

## Features

- Browse popular movies
- Search for movies
- View detailed movie information
- Infinite scroll pagination
- Material Design 3 theming with light/dark mode support
- Smooth animations and transitions
- Loading state indicators with shimmer effects
- Responsive grid layout
- Cached image loading

## Prerequisites

- Flutter SDK (^3.9.2)

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/shailendra086/movie-explore-task.git
   cd movieexplorer
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

- **State Management**

  - `flutter_riverpod: ^3.0.3` - For state management

- **Networking**

  - `http: ^1.5.0` - For API requests

- **UI Components**
  - `cached_network_image: ^3.4.1` - For caching network images
  - `shimmer: ^3.0.0` - For loading state animations
  - `google_fonts: ^6.1.0` - For custom fonts

## Project Structure

- `lib/`
  - `models/` - Data models
  - `providers/` - Riverpod providers
  - `repositories/` - Data repositories
  - `services/` - API services
  - `views/` - Screen widgets
  - `widgets/` - Reusable widgets
  - `core/` - Constants and utilities

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
