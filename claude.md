
# Flutter App Expert Guidelines

## Flexibility Notice
**Important**: This is a recommended project structure, but be flexible and adapt to existing project structures. Do not enforce these structural patterns if the project follows a different organization. Focus on maintaining consistency with the existing project architecture while applying Flutter best practices.

## 🤖 SUBAGENT DELEGATION SYSTEM 🤖
**CRITICAL: BE PROACTIVE WITH SUBAGENTS! YOU HAVE SPECIALIZED EXPERTS AVAILABLE!**

### 🚨 DELEGATION MINDSET
**Instead of thinking "I'll handle this myself"** **Think: "Which specialist is BEST suited for this task?"**

### 📋 AVAILABLE SPECIALISTS
You have access to these expert subagents - USE THEM PROACTIVELY:

#### 🎨 **flutter-widget-expert**
- **MUST BE USED for**: Custom widgets, UI components, layouts, animations, Material 3 design
- **Triggers**: "create widget", "build UI", "design component", "layout", "animation"

#### 🔄 **riverpod-expert**
- **MUST BE USED for**: State management, providers, reactive programming, async operations
- **Triggers**: "state management", "provider", "riverpod", "async state", "data flow"

#### 🗄️ **hive-expert**
- **MUST BE USED for**: Local database, caching, data models, Hive operations, storage
- **Triggers**: "database", "cache", "hive", "local storage", "data persistence"

#### 🌐 **api-integration-expert**
- **MUST BE USED for**: HTTP clients, API calls, error handling, network operations
- **Triggers**: "API", "HTTP", "network", "dio", "REST", "endpoint"

#### 🏗️ **architecture-expert**
- **MUST BE USED for**: Clean architecture, feature structure, dependency injection, project organization
- **Triggers**: "architecture", "structure", "organization", "clean code", "refactor"

#### ⚡ **performance-expert**
- **MUST BE USED for**: Optimization, image caching, memory management, build performance
- **Triggers**: "performance", "optimization", "memory", "cache", "slow", "lag"

### 🎯 DELEGATION STRATEGY
**BEFORE starting ANY task, ASK YOURSELF:**
1. "Which of my specialists could handle this better?"
2. "Should I break this into parts for different specialists?"
3. "Would a specialist complete this faster and better?"

### 💼 WORK BALANCE RECOMMENDATION:
- **Simple Tasks (20%)**: Handle independently - quick fixes, minor updates
- **Complex Tasks (80%)**: Delegate to specialists for expert-level results

### 🔧 HOW TO DELEGATE
```  
# Explicit delegation examples:  
> Use the flutter-widget-expert to create a custom movie card widget  
> Have the riverpod-expert design the state management for the media grid  
> Ask the hive-expert to create the database schema for caching  
> Use the api-integration-expert to implement the Sonarr API client  
> Have the architecture-expert review the feature structure  
> Ask the performance-expert to optimize the image loading  
```  
  
---  

## Flutter Best Practices
- Adapt to existing project architecture while maintaining clean code principles
- Use Flutter 3.x features and Material 3 design
- Implement clean architecture with Riverpod pattern
- Follow proper state management principles
- Use proper dependency injection
- Implement proper error handling
- Follow platform-specific design guidelines
- Use proper localization techniques

## Preferred Project Structure
**Note**: This is a reference structure. Adapt to the project's existing organization.

```  
lib/  
 core/  
	 constants/  
	 theme/  
	 utils/  
	 widgets/  
 features/  
	 feature_name/  
		 data/  
			 datasources/  
			 models/  
			 repositories/  
		 domain/  
			 entities/  
			 repositories/  
			 usecases/  
		 presentation/  
			 providers/  
			 pages/  
			 widgets/  
 l10n/  
 main.dart  
test/  
 unit/  
 widget/  
 integration/  
```  

## Coding Guidelines
1. Use proper null safety practices
2. Implement proper error handling with Either type
3. Follow proper naming conventions
4. Use proper widget composition
5. Implement proper routing using GoRouter
6. Use proper form validation
7. Follow proper state management with Riverpod
8. Implement proper dependency injection using GetIt
9. Use proper asset management

## Widget Guidelines
1. Keep widgets small and focused
2. Use const constructors when possible
3. Implement proper widget keys
4. Follow proper layout principles
5. Use proper widget lifecycle methods
6. Implement proper error boundaries
7. Use proper performance optimization techniques
8. Follow proper accessibility guidelines

## Performance Guidelines
1. Use proper image caching
2. Implement proper list view optimization
3. Use proper build methods optimization
4. Follow proper state management patterns
5. Implement proper memory management
6. Use proper platform channels when needed
7. Follow proper compilation optimization techniques

## Refactoring Instructions
When refactoring code:
- Always maintain existing project structure patterns
- Prioritize consistency with current codebase
- Apply Flutter best practices without breaking existing architecture
- Focus on incremental improvements
- Ensure all changes maintain backward compatibility

---  

# App Context - Base Flutter Application

## About This App
A foundational Flutter mobile application with a robust architecture designed for scalability and maintainability. This base app provides the essential infrastructure components needed for any modern Flutter application.

## Target Users
- Developers building Flutter applications
- Teams requiring a solid architectural foundation
- Projects needing consistent patterns and practices

## Core Infrastructure
### Project Structure
- **Core Layer**: Essential utilities, constants, and shared functionality
- **Network Layer**: HTTP clients, API infrastructure, and connectivity management
- **Theme Layer**: Design system, colors, typography, and Material 3 implementation
- **Error Handling**: Centralized error management and user feedback

### Architecture Foundation
```  
lib/  
 core/  
 constants/      # App-wide constants and configuration  
 network/        # HTTP clients, interceptors, API base classes  
 theme/          # Design system, Material 3 theme configuration  
 errors/         # Custom exceptions, error handling utilities  
 utils/          # Helper functions, extensions, formatters  
 widgets/        # Shared UI components  
 main.dart  
```  

## Technical Stack
### Flutter & Dart
- Flutter 3.x with Material 3 design
- Dart 3.x with null safety
- Modern Flutter development practices

### Architecture & State Management
- Clean architecture with feature-first structure
- **Riverpod** for state management (NOT BLoC)
- Repository pattern for data layer
- **Hive** for local database and caching

### Core Dependencies
- `flutter_riverpod` / `riverpod` - State management
- `hive` / `hive_flutter` - Local database and caching
- `dio` - HTTP client for API calls
- `go_router` - Navigation and routing
- `flutter_secure_storage` - Secure storage for sensitive data
- `cached_network_image` - Image caching and optimization
- `json_annotation` / `freezed` - Model serialization
- `hive_generator` - Code generation for Hive adapters

## Core Components

### Constants Layer (`lib/core/constants/`)
- **API Constants**: Base URLs, endpoints, timeouts
- **App Constants**: Version info, feature flags, defaults
- **UI Constants**: Spacing, dimensions, animation durations
- **Storage Constants**: Hive box names, cache keys

### Network Layer (`lib/core/network/`)
- **HTTP Client**: Configured Dio instance with interceptors
- **API Base Classes**: Generic API response handling
- **Network Info**: Connectivity status and monitoring
- **Request/Response Models**: Base classes for API communication
- **Error Handling**: HTTP error codes and network exceptions

### Theme Layer (`lib/core/theme/`)
- **App Theme**: Material 3 design system implementation
- **Color Schemes**: Light/dark mode color definitions
- **Typography**: Text styles and font configurations
- **Component Themes**: Button, card, input field customizations
- **Responsive Design**: Screen size breakpoints and adaptive layouts

### Error Handling (`lib/core/errors/`)
- **Custom Exceptions**: Business logic and network exceptions
- **Failure Classes**: Standardized error representations
- **Error Messages**: User-friendly error text and localization
- **Logging**: Error tracking and debugging utilities

## State Management Architecture (Riverpod)
### Provider Structure
```  
providers/  
 network_providers.dart     # HTTP clients, connectivity  
 theme_providers.dart       # Theme state, dark mode  
 storage_providers.dart     # Hive boxes, secure storage  
 app_providers.dart         # Global app state  
```  

### Modern Provider Types
- **Provider**: For dependency injection and immutable values (Dio, Hive boxes, constants)
- **FutureProvider**: For async operations and initialization
- **StreamProvider**: For reactive data streams (connectivity, real-time updates)
- **NotifierProvider**: For synchronous mutable state management
- **AsyncNotifierProvider**: For async mutable state with loading/error handling
- **StreamNotifierProvider**: For stream-based mutable state management

## Hive Database Foundation
### Core Boxes
- `appSettingsBox`: User preferences and app configuration
- `cacheBox`: General purpose caching
- `userDataBox`: User-specific data storage

### Base Models with Hive Adapters
- `AppSettings` - User preferences, theme, language
- `CacheItem` - Generic caching wrapper
- `UserPreferences` - User-specific settings

## Network Infrastructure
### HTTP Client Configuration
- **Base URL Management**: Environment-specific endpoints
- **Interceptors**: Authentication, logging, error handling
- **Timeout Configuration**: Request/response timeouts
- **Retry Logic**: Automatic retry for failed requests
- **Certificate Pinning**: Security for production APIs

### API Response Patterns
- **Standardized Responses**: Consistent API response structure
- **Error Mapping**: Convert HTTP errors to domain exceptions
- **Loading States**: AsyncValue patterns with Riverpod
- **Caching Strategy**: Network-first with Hive fallback

## UI Foundation
### Core Widgets (`lib/core/widgets/`)
- **Loading Indicators**: Consistent loading UI patterns
- **Error Widgets**: Standardized error display components
- **Empty States**: No data found UI patterns
- **Buttons**: Custom button components following Material 3
- **Input Fields**: Form components with validation
- **Cards**: Reusable card layouts

### Theme Implementation
- **Material 3**: Full Material You design system
- **Dynamic Colors**: System color extraction support
- **Dark Mode**: Seamless light/dark theme switching
- **Accessibility**: WCAG compliant color contrast
- **Typography**: Responsive text scaling

## Error Handling Strategy
### Exception Hierarchy
```dart  
abstract class AppException implements Exception {  
 final String message; final String? code;}  
  
class NetworkException extends AppException {}  
class CacheException extends AppException {}  
class ValidationException extends AppException {}  
```  

### User Feedback
- **Snackbars**: Quick notifications and confirmations
- **Error Dialogs**: Detailed error information
- **Retry Mechanisms**: User-initiated retry actions
- **Offline Indicators**: Network status feedback

## Performance Foundation
### Core Optimizations
- **Widget Performance**: Const constructors, proper keys
- **Image Management**: Caching, compression, lazy loading
- **Memory Management**: Proper disposal patterns
- **Build Optimization**: Efficient widget rebuilds
- **Database Performance**: Optimized Hive queries

### Monitoring
- **Performance Tracking**: Frame rate monitoring
- **Memory Usage**: Leak detection and optimization
- **Network Monitoring**: Request timing and failures
- **Error Tracking**: Crash reporting and analysis

## Security Foundation
### Data Protection
- **Secure Storage**: Encrypted storage for sensitive data
- **API Security**: Token management, refresh logic
- **Input Validation**: Sanitization and validation utilities
- **Certificate Pinning**: Network security measures
- **Encryption**: Local data encryption capabilities

## Development Guidelines
### Code Organization
- Feature-first architecture for scalability
- Consistent naming conventions
- Proper dependency injection patterns
- Clean separation of concerns
- Comprehensive error handling

### Testing Strategy
- Unit tests for business logic and utilities
- Widget tests for UI components
- Integration tests for full user flows
- Mock implementations for external dependencies
- Test coverage monitoring and reporting

## Extensibility
### Adding New Features
1. Create feature directory under `lib/features/`
2. Implement data, domain, and presentation layers
3. Register providers in feature module
4. Add navigation routes
5. Update theme if needed

### Configuration Management
- Environment-specific configurations
- Feature flag implementation
- API endpoint management
- Build variant support
- Configuration validation

This base application provides a solid foundation for building scalable Flutter applications with proper architecture, error handling, and performance optimization built-in from the start.  
Remember: **ALWAYS DELEGATE TO SPECIALISTS FOR BETTER RESULTS!**
