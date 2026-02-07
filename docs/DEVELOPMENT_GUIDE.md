# DoIt Development Guide

## Overview

This guide provides comprehensive instructions for setting up, developing, and testing the DoIt application. It covers both the backend (Python FastAPI) and frontend (SwiftUI iOS) components.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Backend Setup](#backend-setup)
- [Frontend Setup](#frontend-setup)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [Code Style Conventions](#code-style-conventions)
- [Git Workflow](#git-workflow)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Backend Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| Python | 3.9+ | Backend runtime |
| pip | Latest | Package manager |
| virtualenv | Latest | Environment isolation |
| MongoDB Atlas Account | - | Database hosting |
| Google Gemini API Key | - | AI services |

### Frontend Requirements

| Tool | Version | Purpose |
|------|---------|---------|
| Xcode | 15.0+ | iOS development |
| macOS | Sonoma (14.0+) | Operating system |
| iOS Simulator | Latest | Testing |
| CocoaPods (optional) | Latest | Dependency management |

### Optional Tools

| Tool | Purpose |
|------|---------|
| Postman | API testing |
| MongoDB Compass | Database management |
| Figma | Design collaboration |
| Git | Version control |

---

## Project Structure

```
doit/
├── backend/                    # Python FastAPI backend
│   ├── main.py                # Application entry point
│   ├── config.py              # Configuration management
│   ├── requirements.txt       # Python dependencies
│   ├── .env                   # Environment variables (not in git)
│   ├── models/                # Pydantic models
│   │   ├── user.py           # User models
│   │   └── goal.py           # Goal models
│   ├── routes/                # API route handlers
│   │   ├── auth.py           # Authentication endpoints
│   │   ├── goals.py          # Goal management endpoints
│   │   └── chat.py           # Chat endpoints
│   └── services/              # Business logic
│       ├── db.py             # Database connection
│       ├── ai.py             # AI/Gemini integration
│       └── username_generator.py  # Username generation
│
├── doit/                      # SwiftUI iOS frontend
│   ├── doitApp.swift         # App entry point
│   ├── ContentView.swift     # Root view
│   ├── PROJECT_PLAN.md       # Project documentation
│   ├── Assets.xcassets/      # Images, colors, icons
│   ├── Core/                 # Core utilities
│   │   └── Theme/
│   │       └── AppTheme.swift  # Design system
│   ├── Components/           # Reusable UI components
│   │   └── Common/
│   │       └── UIComponents.swift
│   ├── Features/             # Feature modules
│   │   ├── Auth/            # Authentication
│   │   ├── Goals/           # Goal management
│   │   ├── Home/            # Home screen
│   │   └── Onboarding/      # Onboarding flow
│   └── Services/            # Network & data services
│       ├── NetworkService.swift
│       ├── UserManager.swift
│       └── GoalService.swift
│
├── docs/                     # Documentation
│   ├── API_DOCUMENTATION.md
│   ├── DATABASE_SCHEMA.md
│   ├── DESIGN_SYSTEM.md
│   ├── DEVELOPMENT_GUIDE.md
│   └── CHANGELOG.md
│
└── .gitignore               # Git ignore rules
```

---

## Backend Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd doit
```

### 2. Set Up Python Virtual Environment

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate
# On Windows:
# venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Create a `.env` file in the `backend` directory:

```bash
# MongoDB Atlas Connection
MONGODB_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/doit_db?retryWrites=true&w=majority

# Google Gemini API Key
GEMINI_API_KEY=your_gemini_api_key_here
```

**Getting API Keys:**

1. **MongoDB Atlas:**
   - Sign up at [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
   - Create a free cluster
   - Get your connection string from the Connect dialog

2. **Google Gemini API:**
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Create a new API key
   - Copy the key to your `.env` file

### 5. Verify Database Connection

```bash
python -c "from services.db import connect_db; connect_db()"
```

You should see: `✅ Successfully connected to MongoDB!`

### 6. Run the Backend Server

```bash
# Using uvicorn (recommended)
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Or using python directly
python main.py
```

The API will be available at `http://localhost:8000`

### 7. Access API Documentation

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc

---

## Frontend Setup

### 1. Open the Project in Xcode

```bash
# Navigate to project root
cd doit

# Open the Xcode project
open doit.xcodeproj
```

### 2. Configure API Base URL

In [`doit/Services/NetworkService.swift`](doit/Services/NetworkService.swift:4), update the base URL:

```swift
struct APIConfig {
    // Use localhost for simulator
    // Use your Mac's IP for real device testing
    static let baseURL = "http://localhost:8000"
}
```

**Finding Your Mac's IP:**

```bash
# On macOS
ipconfig getifaddr en0
```

### 3. Build the Project

1. Select the target device (iPhone Simulator or physical device)
2. Press `Cmd + B` to build
3. Fix any build errors

### 4. Run the App

1. Press `Cmd + R` to run
2. The app will launch in the selected device/simulator

---

## Running the Application

### Full Stack Development

To run both backend and frontend simultaneously:

#### Terminal 1 - Backend

```bash
cd backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

#### Terminal 2 - Frontend

```bash
# Open Xcode and run the app (Cmd + R)
# Or use command line:
xcodebuild -scheme doit -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### Testing on Physical Device

1. **Backend:** Ensure your Mac and device are on the same network
2. **Frontend:** Update `baseURL` in [`NetworkService.swift`](doit/Services/NetworkService.swift:4) to your Mac's IP address
3. **Build:** Connect device, select it in Xcode, and run

---

## Testing

### Backend Testing

#### Manual API Testing with curl

```bash
# Register a user
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "1234567890"}'

# Create a goal
curl -X POST "http://localhost:8000/goals/" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Learn Python",
    "description": "Master Python programming",
    "target_date": "2026-03-09T00:00:00"
  }'

# Get user goals
curl -X GET "http://localhost:8000/goals/user/550e8400-e29b-41d4-a716-446655440000"
```

#### Using Postman

1. Import the API endpoints from the interactive docs
2. Create collections for different features
3. Save environment variables for reuse

#### Unit Testing (Future)

```bash
# Run tests (when implemented)
pytest backend/tests/
```

### Frontend Testing

#### Manual Testing Checklist

- [ ] Onboarding flow completes successfully
- [ ] Phone number registration works
- [ ] OTP verification accepts valid code (1234)
- [ ] Goal creation saves to backend
- [ ] Goal list displays correctly
- [ ] Chat interface sends/receives messages
- [ ] Roadmap displays after goal creation

#### UI Testing with Xcode

```bash
# Run UI tests (when implemented)
xcodebuild test -scheme doit -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## Code Style Conventions

### Python (Backend)

#### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variables | snake_case | `user_id`, `phone_number` |
| Functions | snake_case | `get_user()`, `create_goal()` |
| Classes | PascalCase | `User`, `GoalResponse` |
| Constants | UPPER_SNAKE_CASE | `DATABASE_NAME`, `API_KEY` |
| Private members | _leading_underscore | `_internal_method()` |

#### Code Formatting

Use **Black** for consistent formatting:

```bash
pip install black
black backend/
```

#### Linting

Use **Pylint** for code quality:

```bash
pip install pylint
pylint backend/
```

#### Docstrings

Use Google-style docstrings:

```python
def generate_roadmap(goal_title: str, goal_description: str, target_date: datetime) -> dict:
    """
    Generate a structured JSON roadmap for a goal using Gemini.

    Args:
        goal_title: The title of the goal.
        goal_description: Detailed description of the goal.
        target_date: Target completion date.

    Returns:
        A dictionary containing the roadmap with daily tasks.

    Raises:
        ValueError: If the target date is in the past.
    """
    pass
```

### Swift (Frontend)

#### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userId`, `phoneNumber` |
| Functions | camelCase | `getUser()`, `createGoal()` |
| Types | PascalCase | `User`, `GoalResponse` |
| Constants | camelCase | `databaseName`, `apiKey` |
| Private members | camelCase | `internalMethod()` |

#### Code Formatting

Xcode automatically formats Swift code. Use `Cmd + I` to re-indent.

#### Linting

Use **SwiftLint** for code quality:

```bash
brew install swiftlint
swiftlint lint
```

#### Documentation

Use standard Swift documentation comments:

```swift
/// Generates a structured roadmap for a goal using Gemini.
///
/// - Parameters:
///   - goalTitle: The title of the goal.
///   - goalDescription: Detailed description of the goal.
///   - targetDate: Target completion date.
/// - Returns: A dictionary containing the roadmap with daily tasks.
func generateRoadmap(goalTitle: String, goalDescription: String, targetDate: Date) -> [String: Any] {
    // Implementation
}
```

---

## Git Workflow

### Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code |
| `develop` | Integration branch for features |
| `feature/*` | New features |
| `bugfix/*` | Bug fixes |
| `hotfix/*` | Urgent production fixes |

### Commit Message Format

Follow conventional commits:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(auth): add OTP verification screen

- Implement OTP input field
- Add validation logic
- Connect to backend API

Closes #123
```

```
fix(goals): resolve crash when roadmap is null

- Add null check for roadmap field
- Provide fallback UI when roadmap unavailable
```

### Pull Request Process

1. Create a feature branch from `develop`
2. Make changes and commit with clear messages
3. Push to remote repository
4. Create a pull request to `develop`
5. Request review from team members
6. Address feedback and make changes
7. Merge after approval

### .gitignore

The project includes a `.gitignore` file that excludes:

- Python virtual environments (`venv/`, `.env`)
- Xcode build artifacts (`*.xcodeproj/xcuserdata/`)
- macOS system files (`.DS_Store`)
- IDE configuration files (`.vscode/`, `.idea/`)

---

## Troubleshooting

### Backend Issues

#### MongoDB Connection Failed

**Problem:** `❌ Failed to connect to MongoDB`

**Solutions:**
1. Verify your MongoDB URI is correct in `.env`
2. Check your IP is whitelisted in MongoDB Atlas
3. Ensure your cluster is running
4. Verify network connectivity

#### Gemini API Error

**Problem:** `Gemini API Error: ...`

**Solutions:**
1. Verify your API key is correct
2. Check your API key has proper permissions
3. Ensure you have available quota
4. Check the Gemini service status

#### Port Already in Use

**Problem:** `Address already in use: 8000`

**Solutions:**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use a different port
uvicorn main:app --port 8001
```

### Frontend Issues

#### Build Errors

**Problem:** Xcode shows build errors

**Solutions:**
1. Clean build folder: `Cmd + Shift + K`
2. Clean build folder: Product > Clean Build Folder
3. Restart Xcode
4. Check for missing dependencies in project settings

#### Network Connection Failed

**Problem:** App can't connect to backend

**Solutions:**
1. Verify backend is running on `http://localhost:8000`
2. Check `baseURL` in [`NetworkService.swift`](doit/Services/NetworkService.swift:4)
3. For physical device, use your Mac's IP address
4. Ensure device and Mac are on same network
5. Check firewall settings

#### Simulator Issues

**Problem:** App crashes on simulator

**Solutions:**
1. Reset simulator: Device > Erase All Content and Settings
2. Try a different simulator device
3. Update Xcode to latest version
4. Check console logs for error details

### General Issues

#### Environment Variables Not Loading

**Problem:** `.env` file not being read

**Solutions:**
1. Ensure `.env` is in the `backend/` directory
2. Verify `python-dotenv` is installed
3. Check `.env` file has correct format (no spaces around `=`)
4. Restart the backend server

#### Dependencies Not Installing

**Problem:** `pip install` fails

**Solutions:**
```bash
# Upgrade pip
pip install --upgrade pip

# Try installing individually
pip install fastapi
pip install uvicorn
pip install pymongo[srv]
pip install google-genai
pip install python-dotenv
pip install pydantic
```

---

## Development Best Practices

### Backend

1. **Use Pydantic Models:** Always use Pydantic for request/response validation
2. **Error Handling:** Implement proper error handling with HTTP status codes
3. **Async/Await:** Use async functions for I/O operations
4. **Environment Variables:** Never hardcode sensitive information
5. **Logging:** Add logging for debugging and monitoring

### Frontend

1. **MVVM Pattern:** Use ViewModels for business logic
2. **Combine Framework:** Use Combine for reactive programming
3. **Reusable Components:** Create reusable UI components
4. **State Management:** Use `@Published` and `@StateObject` appropriately
5. **Accessibility:** Add accessibility labels to all interactive elements

### Testing

1. **Write Tests:** Write unit tests for business logic
2. **Test Coverage:** Aim for >80% code coverage
3. **Integration Tests:** Test API endpoints end-to-end
4. **UI Tests:** Automate critical user flows

---

## Additional Resources

### Documentation

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Google Gemini API](https://ai.google.dev/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Combine Framework](https://developer.apple.com/documentation/combine/)

### Tools

- [Postman](https://www.postman.com/) - API testing
- [MongoDB Compass](https://www.mongodb.com/products/compass) - Database GUI
- [SwiftLint](https://github.com/realm/SwiftLint) - Swift linting
- [Black](https://black.readthedocs.io/) - Python formatting

### Community

- [FastAPI GitHub](https://github.com/tiangolo/fastapi)
- [SwiftUI Forums](https://developer.apple.com/forums/)
- [MongoDB Community](https://www.mongodb.com/community)

---

## Getting Help

If you encounter issues not covered in this guide:

1. Check the [API Documentation](API_DOCUMENTATION.md)
2. Review the [Database Schema](DATABASE_SCHEMA.md)
3. Consult the [Design System](DESIGN_SYSTEM.md)
4. Check the project [CHANGELOG](CHANGELOG.md)
5. Open an issue on the project repository

---

## Contributing

When contributing to the DoIt project:

1. Follow the code style conventions
2. Write clear commit messages
3. Update documentation as needed
4. Add tests for new features
5. Ensure all tests pass before submitting PRs

---

## License

This project is proprietary and confidential. All rights reserved.
