# Changelog

All notable changes to the DoIt project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned Features
- OTP-based authentication with Twilio/Firebase integration
- JWT token authentication and refresh mechanism
- Group system for anonymous community support
- Push notifications for daily check-ins
- Streak tracking and gamification
- Roadmap rescheduling based on user progress
- User profile and settings
- Data export functionality
- Daily task verification system with AI-generated tests
- Adaptive difficulty based on verification performance
- Verification statistics and achievements

---

## [0.1.0] - 2026-02-07

### Added

#### Project Structure
- Initial project setup with backend and frontend directories
- Backend: Python FastAPI application structure
- Frontend: SwiftUI iOS application structure
- Documentation: `docs/` directory with comprehensive guides

#### Backend Features
- FastAPI application with MongoDB integration
- User registration and authentication endpoints
  - `POST /auth/register` - Register new user
  - `GET /auth/user/{phone_number}` - Get user by phone number
- Goal management endpoints
  - `POST /goals/` - Create new goal with AI-generated roadmap
  - `GET /goals/user/{user_id}` - Get all user goals
  - `GET /goals/{goal_id}` - Get specific goal
  - `DELETE /goals/{goal_id}` - Delete goal
- Chat endpoints
  - `POST /chat/send` - Send message and get AI response
  - `GET /chat/history/{goal_id}` - Get chat history
  - `POST /chat/roadmap` - Generate/regenerate roadmap
- Health check endpoint
  - `GET /health` - API and database health status

#### Backend Services
- MongoDB connection management with automatic reconnection
- Google Gemini AI integration for roadmap generation
- Fallback roadmap generation when AI API fails
- Today's tasks extraction from roadmap

#### Backend Models
- User models: `UserCreate`, `UserResponse`, `User`
- Goal models: `GoalCreate`, `GoalResponse`, `Goal`
- Chat models: `ChatMessage`, `ChatResponse`, `RoadmapRequest`

#### Frontend Features
- SwiftUI app with black/white minimalist theme
- Onboarding flow screens
  - Splash screen with app logo
  - Welcome screen with value proposition
  - Phone number input screen
  - OTP verification screen (mock with code "1234")
- Authentication UI
  - Sign-in view with phone number registration
  - OTP verification view
- Home screen with basic layout
- Goal management UI
  - Goal creation sheet
  - Goal chat view
  - Goal list display
- Network service for API communication
- User manager for authentication state
- Goal service for local goal management

#### Frontend Components
- `PrimaryButton` - Main action button with loading state
- `OnboardingInputField` - Text input field for onboarding
- Reusable UI components library

#### Frontend Theme
- App colors: Black/white minimalist palette
  - Primary background: `#000000`
  - Secondary background: `#1C1C1E`
  - Card background: `#2C2C2E`
  - Primary text: `#FFFFFF`
  - Secondary text: `#8E8E93`
  - Accent: `#FFFFFF`
  - Border: `#3A3A3C`
- App fonts: SF Pro family
  - Header: 32pt Bold
  - Subheader: 22pt Semibold
  - Body: 17pt Regular
  - Button: 17pt Semibold
  - Caption: 13pt Regular

#### Frontend Models
- `Goal` model with title, description, target date
- `Message` model for chat messages
- API response models for backend integration

#### Documentation
- API Documentation (`docs/API_DOCUMENTATION.md`)
  - Complete endpoint reference
  - Request/response examples
  - Error codes and data models
- Database Schema (`docs/DATABASE_SCHEMA.md`)
  - Users, Goals, and Groups collections
  - Field specifications and constraints
  - Indexes and relationships
- Design System (`docs/DESIGN_SYSTEM.md`)
  - Color palette with hex codes
  - Typography specifications
  - Component specifications
  - Spacing and layout rules
  - Design principles
- Development Guide (`docs/DEVELOPMENT_GUIDE.md`)
  - Backend and frontend setup instructions
  - Running the application locally
  - Testing procedures
  - Code style conventions
  - Git workflow
  - Troubleshooting guide
- Changelog (`docs/CHANGELOG.md`)

#### Assets
- App icon
- Onboarding illustrations
  - Community illustration
  - Focus illustration
  - Roadmap illustration
- Accent color set

#### Configuration
- Backend configuration with environment variables
- MongoDB Atlas connection setup
- Google Gemini API integration
- Network service configuration for API base URL

---

## [0.0.1] - 2026-02-07

### Added
- Initial project repository
- Basic project structure
- Git ignore configuration
- Project plan documentation

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 0.1.0 | 2026-02-07 | Initial release with core features |
| 0.0.1 | 2026-02-07 | Project initialization |

---

## Upcoming Releases

### Version 0.2.0 (Planned)
- Complete OTP authentication flow
- JWT token implementation
- User session management
- Enhanced error handling

### Version 0.3.0 (Planned)
- Group system implementation
- Anonymous community features
- Group chat functionality
- User matching algorithm

### Version 0.4.0 (Planned)
- Push notification system
- Daily check-in reminders
- Streak tracking
- Gamification elements

### Version 0.5.0 (Planned)
- User profile management
- Settings and preferences
- Data export functionality
- Privacy controls

### Version 1.0.0 (Planned)
- Full feature set complete
- Performance optimization
- Security audit
- App Store submission ready

---

## Categories

### Added
New features and functionality

### Changed
Changes to existing functionality

### Deprecated
Soon-to-be removed features

### Removed
Removed features

### Fixed
Bug fixes

### Security
Security improvements

---

## Links

- [API Documentation](API_DOCUMENTATION.md)
- [Database Schema](DATABASE_SCHEMA.md)
- [Design System](DESIGN_SYSTEM.md)
- [Development Guide](DEVELOPMENT_GUIDE.md)
- [Project Plan](PROJECT_PLAN.md)
