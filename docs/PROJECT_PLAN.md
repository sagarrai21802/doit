# DoIt - Goal Achievement Platform

## Project Overview

**DoIt** is a goal-tracking application designed to help users stay focused and achieve their goals through structured daily tasks, AI-generated roadmaps, streak-based motivation, daily verification tests to ensure genuine learning, and anonymous community support. The UI follows a chat-based paradigm similar to WhatsApp/ChatGPT, where each "chat" represents an individual goal with its own dedicated conversation, roadmap, and progress tracking.

---

## Core Concept

The fundamental problem this app solves: **People set goals but get distracted during breaks from working on them.** DoIt addresses this by:

1. Breaking goals into daily actionable tasks
2. Providing AI-researched roadmaps based on successful achievers
3. Creating accountability through streak systems
4. Connecting users anonymously with others pursuing similar goals
5. Verifying daily task completion through AI-generated tests to ensure genuine learning

---

## Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Frontend** | SwiftUI (iOS) | Native iOS experience, modern declarative UI |
| **Backend** | Python (FastAPI) | AI/ML integration, Gemini API compatibility |
| **Database** | MongoDB | Flexible schema for chat/goal structures |
| **AI Engine** | Google Gemini | Roadmap generation, research, task suggestions |
| **Authentication** | OTP-based (Twilio/Firebase) | Anonymous, minimal data collection |

---

## Design System

### Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Primary Background | Pure Black | `#000000` |
| Secondary Background | Dark Gray | `#1C1C1E` |
| Card Background | Charcoal | `#2C2C2E` |
| Primary Text | Pure White | `#FFFFFF` |
| Secondary Text | Light Gray | `#8E8E93` |
| Accent (Streak/Progress) | White | `#FFFFFF` |
| Success Indicator | White with opacity | `rgba(255,255,255,0.8)` |
| Border/Divider | Dark Gray | `#3A3A3C` |

### Typography

| Element | Font | Weight | Size |
|---------|------|--------|------|
| Headers | SF Pro Display | Bold | 28-34pt |
| Subheaders | SF Pro Display | Semibold | 20-24pt |
| Body | SF Pro Text | Regular | 16-17pt |
| Caption | SF Pro Text | Regular | 12-14pt |
| Button | SF Pro Text | Semibold | 16-18pt |

### Design Principles

1. **Minimalist** - Black and white creates focus, reduces visual noise
2. **High Contrast** - Easy readability in all lighting conditions
3. **Dark Mode First** - Battery efficient, modern aesthetic
4. **Chat-centric** - Familiar pattern from WhatsApp/iMessage

---

## Application Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        SwiftUI Frontend                         │
├─────────────────────────────────────────────────────────────────┤
│  Onboarding  │  Goal Chats  │  Groups  │  Dashboard  │  Profile │
└──────────────┴──────────────┴──────────┴─────────────┴──────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Python FastAPI Backend                       │
├─────────────────────────────────────────────────────────────────┤
│  Auth API  │  Goals API  │  Roadmap API  │  Groups API  │ AI API │
└────────────┴─────────────┴──────────────┴──────────────┴────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        ┌──────────┐   ┌───────────┐   ┌──────────────┐
        │ MongoDB  │   │  Gemini   │   │ Twilio/SMS   │
        │ Database │   │    API    │   │   Gateway    │
        └──────────┘   └───────────┘   └──────────────┘
```

---

## Feature Breakdown

### 1. Authentication System (Anonymous)

**Data Stored:**
- Mobile number (hashed)
- Random generated username
- User ID (UUID)

**Flow:**
1. User enters mobile number
2. OTP sent via SMS
3. OTP verified
4. Random username assigned (e.g., "CosmicLearner42")
5. JWT token issued

**Privacy First:**
- No name, email, or personal data collected
- All interactions tied to random username
- Phone number only for authentication

---

### 2. Goal Chat System

Each goal is a "chat" with:

| Component | Description |
|-----------|-------------|
| **Goal Definition** | What user wants to achieve |
| **Timeline** | Target completion date (preset or custom) |
| **Roadmap** | AI-generated daily task breakdown |
| **Chat History** | User-AI conversation about the goal |
| **Progress Dashboard** | Visual representation of completion |
| **Streak Counter** | Consecutive days of activity |

**Goal Creation Flow:**
```
User Input → Goal + Timeline
        ↓
    Gemini API
        ↓
Research successful achievers
        ↓
Generate personalized roadmap
        ↓
Break into daily tasks with resources
        ↓
Store in MongoDB
        ↓
Display to user
```

---

### 3. AI Roadmap Generation (Gemini Integration)

**Process:**

1. **Input Analysis**
   - Parse goal description
   - Understand timeline constraints
   - Identify skill level indicators

2. **Research Phase** (Gemini)
   - Search for successful case studies
   - Analyze common patterns in achievement
   - Identify optimal learning paths
   - Find best resources (courses, books, tutorials)

3. **Roadmap Creation**
   - Divide total work into daily chunks
   - Assign specific tasks per day
   - Attach relevant resources to each task
   - Build in review/practice days

4. **Adaptive Adjustments**
   - If user misses a day → redistribute tasks
   - If user modifies timeline → recalculate roadmap
   - Weekly check-ins for pacing adjustments

**Example Roadmap Structure:**
```json
{
  "goal_id": "uuid",
  "total_days": 30,
  "days": [
    {
      "day": 1,
      "date": "2026-01-13",
      "tasks": [
        {
          "title": "Introduction to Python basics",
          "description": "Learn variables, data types, and basic syntax",
          "resources": [
            {"type": "video", "url": "...", "title": "Python Crash Course"},
            {"type": "article", "url": "...", "title": "Python Basics Guide"}
          ],
          "estimated_time": "2 hours"
        }
      ],
      "completed": false
    }
  ]
}
```

---

### 4. Daily Check-in System

**Evening Prompt Flow:**
1. App detects end of day (user-configurable time, default 8 PM)
2. Push notification: "How did it go today?"
3. User opens goal chat
4. Text input appears: "Tell us what you accomplished today"
5. User describes their work (free-form text)
6. AI provides encouraging response (not stored, just displayed)
7. **Verification test triggered** (see Section 7: Daily Task Verification System)
8. User completes verification test to validate task completion
9. Streak updated if check-in and verification both completed

**Streak Logic:**
- ✅ Check-in + Verification passed → Streak +1
- ❌ No check-in → Streak reset to 0
- ❌ Verification failed → Streak paused, retry allowed
- 🔔 User can inform about miss → Roadmap adjusts, streak maintains with "rest day"

---

### 5. Group System (Anonymous Community)

**Concept:** Connect users working on similar goals anonymously

**Matching Criteria:**
- Goal category (e.g., "Learning Programming", "Fitness", "Language")
- Timeline overlap
- Activity level

**Features:**
- Group chat for sharing progress
- Anonymous usernames (same as account)
- Share milestones and tips
- No personal info visible
- Report/block functionality

**Group Structure:**
```json
{
  "group_id": "uuid",
  "category": "programming",
  "subcategory": "python",
  "members": ["username1", "username2", ...],
  "max_members": 50,
  "messages": [...]
}
```

---

### 6. Dashboard (Per Goal)

**Metrics Displayed:**
- Days completed / Total days
- Current streak 🔥
- Tasks completed today
- Overall progress percentage
- Roadmap visualization (calendar view)
- Next upcoming task
- Verification score (average test performance)
- Today's verification status (pending/passed/failed)

---

### 7. Daily Task Verification System

**Concept:** At the end of each day, users must complete a verification test to confirm they've actually completed their assigned daily tasks. This ensures accountability and validates progress.

**Verification Flow:**

1. **Trigger**
   - User completes daily check-in (free-form text description)
   - System detects all tasks for the day are marked as complete
   - Verification prompt appears: "Let's verify your learning today!"

2. **Test Generation** (AI-Powered)
   - AI analyzes the day's completed tasks
   - Generates 3-5 relevant questions based on tasks
   - Questions vary by task type:
     - **Coding tasks**: Code completion, debugging, concept questions
     - **Reading tasks**: Multiple choice, short answer, key concepts
     - **Practice tasks**: Scenario-based questions, application problems
     - **Video tasks**: Key takeaways, main concepts, implementation details

3. **Test Interface**
   - Clean, distraction-free quiz interface
   - One question at a time
   - Multiple choice or short answer format
   - Time limit: 5-10 minutes total
   - Progress indicator

4. **Scoring & Feedback**
   - **Pass threshold**: 70% correct answers
   - **Pass**: Tasks marked as verified, streak maintained, progress updated
   - **Fail**: User can retry once (different questions), or mark as "needs review"
   - **Detailed feedback**: Show correct answers with explanations

5. **Adaptive Difficulty**
   - If user consistently scores high → Increase question difficulty
   - If user struggles → Provide hints, easier questions, or suggest review
   - Track performance over time to adjust roadmap pacing

**Example Test Structure:**
```json
{
  "goal_id": "uuid",
  "day": 5,
  "date": "2026-01-17",
  "verification_test": {
    "test_id": "uuid",
    "questions": [
      {
        "id": 1,
        "type": "multiple_choice",
        "question": "What is the correct syntax to create a list in Python?",
        "options": [
          "list = [1, 2, 3]",
          "list = (1, 2, 3)",
          "list = {1, 2, 3}",
          "list = <1, 2, 3>"
        ],
        "correct_answer": 0,
        "explanation": "Lists in Python are created using square brackets []"
      },
      {
        "id": 2,
        "type": "code_completion",
        "question": "Complete the following code to print 'Hello World':",
        "code_snippet": "print(______)",
        "correct_answer": "'Hello World'",
        "explanation": "The print() function outputs text to the console"
      },
      {
        "id": 3,
        "type": "short_answer",
        "question": "What does the len() function do in Python?",
        "correct_answer": "Returns the length of an object",
        "explanation": "len() returns the number of items in a container"
      }
    ],
    "pass_threshold": 0.7,
    "time_limit_minutes": 10
  },
  "user_response": {
    "answers": [0, "'Hello World'", "Returns the length"],
    "score": 1.0,
    "passed": true,
    "completed_at": "2026-01-17T20:30:00Z"
  }
}
```

**Verification States:**
| State | Description | Streak Impact |
|-------|-------------|---------------|
| **Pending** | Test not yet taken | Streak paused |
| **Passed** | Score ≥ 70% | Streak +1 |
| **Failed - Retry** | Score < 70%, first attempt | Streak paused, one retry allowed |
| **Failed - Review** | Score < 70%, retry failed | Streak reset, tasks marked for review |
| **Skipped** | User chose to skip | Streak reset, tasks marked incomplete |

**Benefits:**
- ✅ Ensures genuine learning, not just task checking
- ✅ Provides immediate feedback on understanding
- ✅ Helps identify knowledge gaps early
- ✅ Increases accountability and motivation
- ✅ Data for AI to personalize future roadmaps
- ✅ Gamification element (achievements for perfect scores)

**Edge Cases & Handling:**
- **User genuinely busy**: Can mark as "rest day" (streak maintained, tasks rescheduled)
- **Technical issues**: Can request manual review by AI
- **Multiple goals**: Verification per goal, not per day
- **Review mode**: Failed tasks appear in next day's tasks with additional resources

---

## Database Schema (MongoDB)

### Users Collection
```json
{
  "_id": "ObjectId",
  "user_id": "uuid",
  "phone_hash": "hashed_phone_number",
  "username": "RandomUsername123",
  "created_at": "timestamp",
  "goals": ["goal_id_1", "goal_id_2"]
}
```

### Goals Collection
```json
{
  "_id": "ObjectId",
  "goal_id": "uuid",
  "user_id": "uuid",
  "title": "Learn Python in 30 days",
  "description": "Master Python programming...",
  "start_date": "2026-01-13",
  "end_date": "2026-02-12",
  "roadmap": { /* daily tasks structure */ },
  "chat_history": [
    {"role": "user", "content": "...", "timestamp": "..."},
    {"role": "assistant", "content": "...", "timestamp": "..."}
  ],
  "streak": 5,
  "last_checkin": "2026-01-12",
  "status": "active", // active, completed, paused
  "daily_verifications": [
    {
      "date": "2026-01-17",
      "test_id": "uuid",
      "questions_count": 3,
      "score": 1.0,
      "passed": true,
      "completed_at": "2026-01-17T20:30:00Z"
    }
  ],
  "verification_stats": {
    "total_tests": 15,
    "passed": 14,
    "failed": 1,
    "average_score": 0.85,
    "perfect_scores": 8
  }
}
```

### Groups Collection
```json
{
  "_id": "ObjectId",
  "group_id": "uuid",
  "category": "programming",
  "name": "Python Learners",
  "members": ["user_id_1", "user_id_2"],
  "messages": [
    {"user_id": "...", "username": "...", "content": "...", "timestamp": "..."}
  ],
  "created_at": "timestamp"
}
```

---

## Development Phases

### Phase 1: Frontend Foundation
**Duration:** 2-3 weeks

**Scope:**
- SwiftUI project setup ✅
- Onboarding flow screens
- Basic navigation structure
- UI components library
- Mock data for testing

**Screens to Build:**
1. Splash Screen
2. Welcome/Intro Screen
3. Phone Number Input Screen
4. OTP Verification Screen
5. Username Display Screen
6. Main Tab Bar Structure
7. Empty States for all tabs

---

### Phase 2: Core Frontend Features
**Duration:** 3-4 weeks

**Scope:**
- Goal creation flow
- Chat interface for goals
- Dashboard per goal
- Profile screen
- Local data persistence

**Screens to Build:**
1. Goal List Screen (WhatsApp-like chat list)
2. Goal Creation Modal
3. Goal Chat Screen
4. Daily Task View
5. Dashboard View
6. Profile/Settings Screen
7. Verification Test Screen (quiz interface for daily task validation)

---

### Phase 3: Backend Development
**Duration:** 4-5 weeks

**Scope:**
- FastAPI setup
- MongoDB integration
- OTP authentication
- CRUD APIs for goals
- User management

**APIs to Build:**
```
POST   /auth/send-otp
POST   /auth/verify-otp
POST   /auth/refresh-token

GET    /goals
POST   /goals
GET    /goals/{id}
PUT    /goals/{id}
DELETE /goals/{id}

POST   /goals/{id}/checkin
GET    /goals/{id}/roadmap

POST   /goals/{id}/verification/generate
POST   /goals/{id}/verification/submit
GET    /goals/{id}/verification/stats
```

---

### Phase 4: AI Integration
**Duration:** 3-4 weeks

**Scope:**
- Gemini API integration
- Roadmap generation system
- Chat with AI functionality
- Adaptive roadmap adjustments

**AI Features:**
1. Goal analysis
2. Roadmap generation
3. Daily task suggestions
4. Resource recommendations
5. Check-in responses
6. Roadmap rescheduling
7. Verification test generation
8. Adaptive difficulty adjustment based on test performance

---

### Phase 5: Groups & Community
**Duration:** 3-4 weeks

**Scope:**
- Group creation/joining
- Group chat functionality
- Matching algorithm
- Moderation tools

---

### Phase 6: Polish & Launch
**Duration:** 2-3 weeks

**Scope:**
- Push notifications
- Performance optimization
- Bug fixes
- App Store preparation
- Beta testing

---

## Phase 1 Detailed Implementation

### SwiftUI Project Structure

```
doit/
├── doitApp.swift              # App entry point
├── ContentView.swift          # Root view with navigation
├── Assets.xcassets/           # Images, colors, icons
│
├── Core/
│   ├── Extensions/            # Swift extensions
│   ├── Utilities/             # Helper functions
│   └── Constants/             # App constants, colors
│
├── Features/
│   ├── Onboarding/
│   │   ├── Views/
│   │   │   ├── SplashView.swift
│   │   │   ├── WelcomeView.swift
│   │   │   ├── PhoneInputView.swift
│   │   │   ├── OTPVerificationView.swift
│   │   │   └── UsernameRevealView.swift
│   │   └── ViewModels/
│   │       └── OnboardingViewModel.swift
│   │
│   ├── Goals/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   │
│   ├── Groups/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   │
│   └── Profile/
│       ├── Views/
│       └── ViewModels/
│
├── Components/
│   ├── Buttons/
│   ├── Cards/
│   ├── Inputs/
│   └── Navigation/
│
├── Services/
│   ├── NetworkService.swift
│   ├── AuthService.swift
│   └── StorageService.swift
│
└── Models/
    ├── User.swift
    ├── Goal.swift
    └── Group.swift
```

### Onboarding Flow Screens

#### 1. Splash Screen
- App logo centered
- Black background, white logo
- Auto-transition after 2 seconds

#### 2. Welcome Screen
- Hero illustration/animation
- "Achieve Your Goals" headline
- Brief value proposition
- "Get Started" button

#### 3. Phone Input Screen
- Country code selector
- Phone number input field
- "Continue" button
- Privacy note: "We only use your number for login"

#### 4. OTP Verification Screen
- 6-digit OTP input boxes
- Countdown timer for resend
- "Resend OTP" link
- Auto-verify on complete

#### 5. Username Reveal Screen
- Animated reveal of random username
- "This is how others will see you"
- "Continue to App" button

### SwiftUI Components Needed

1. **PrimaryButton** - Full-width white button on black
2. **SecondaryButton** - Outlined white button
3. **InputField** - Styled text input
4. **OTPInputField** - 6-box OTP input
5. **PhoneInputField** - With country code
6. **CardView** - Rounded container
7. **TabBarView** - Custom bottom navigation
8. **QuizQuestionView** - Single question display with options
9. **QuizProgressView** - Progress indicator for verification test
10. **QuizResultView** - Score display with feedback

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Daily Active Users (DAU) | Track engagement |
| Streak Retention | % users maintaining 7+ day streaks |
| Goal Completion Rate | % goals reaching 100% |
| Group Engagement | Messages per user per week |
| NPS Score | User satisfaction |
| Verification Pass Rate | % users passing daily verification tests |
| Average Verification Score | Mean score across all verification tests |
| Perfect Score Streak | Consecutive days with 100% verification scores |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| AI roadmap quality | Human review of initial prompts, feedback loop |
| User drop-off | Push notifications, streak incentives |
| Spam in groups | Moderation, report system, rate limiting |
| Data privacy concerns | Minimal data collection, clear privacy policy |
| Gemini API costs | Caching, rate limiting, tiered usage |
| Verification test difficulty | Adaptive difficulty, retry options, manual review |
| User frustration with tests | Optional review mode, clear explanations, gamification |

---

## Competitive Analysis

| App | Strengths | Weaknesses | DoIt Advantage |
|-----|-----------|------------|----------------|
| Habitica | Gamification | Complex, gaming-focused | Simplicity, AI roadmaps, verification tests |
| Todoist | Task management | No AI, no community | AI-generated plans, task verification |
| Streaks | Streak tracking | Limited to habits | Full goal journeys, learning validation |
| Forest | Focus timer | Single purpose | Comprehensive goals, verification system |
| Strides | Goal tracking | No AI planning | AI research & roadmaps, daily verification |

---

*Document Version: 1.1*
*Created: January 12, 2026*
*Updated: February 7, 2026 - Added Daily Task Verification System*
