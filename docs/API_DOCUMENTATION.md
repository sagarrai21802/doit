# DoIt API Documentation

## Overview

The DoIt API is a RESTful API built with FastAPI that provides endpoints for user authentication, goal management, chat functionality, and AI-powered roadmap generation.

**Base URL:** `http://localhost:8000`

**API Version:** 1.0.0

---

## Table of Contents

- [Authentication](#authentication)
- [Goals](#goals)
- [Chat](#chat)
- [Verification](#verification)
- [Error Codes](#error-codes)

---

## Authentication

### Register User

Register a new user with a phone number. If the phone number already exists, returns the existing user.

**Endpoint:** `POST /auth/register`

**Request Body:**

```json
{
  "phone_number": "string (10-15 characters)"
}
```

**Response (200 OK):**

```json
{
  "id": "uuid",
  "phone_number": "string",
  "created_at": "ISO8601 datetime"
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "1234567890"}'
```

**Response Example:**

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "phone_number": "1234567890",
  "created_at": "2026-02-07T12:00:00.000000"
}
```

---

### Get User by Phone Number

Retrieve user information by phone number.

**Endpoint:** `GET /auth/user/{phone_number}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| phone_number | string | Yes | User's phone number |

**Response (200 OK):**

```json
{
  "id": "uuid",
  "phone_number": "string",
  "created_at": "ISO8601 datetime"
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "User not found"
}
```

**Example:**

```bash
curl -X GET "http://localhost:8000/auth/user/1234567890"
```

---

## Goals

### Create Goal

Create a new goal for a user. The API automatically generates an AI-powered roadmap using Google Gemini.

**Endpoint:** `POST /goals/`

**Request Body:**

```json
{
  "user_id": "uuid",
  "title": "string",
  "description": "string",
  "target_date": "ISO8601 datetime"
}
```

**Response (200 OK):**

```json
{
  "id": "uuid",
  "user_id": "uuid",
  "title": "string",
  "description": "string",
  "target_date": "ISO8601 datetime",
  "created_at": "ISO8601 datetime",
  "streak": 0,
  "progress": 0.0,
  "roadmap": {
    "total_days": 30,
    "summary": "string",
    "days": [
      {
        "day": 1,
        "date": "YYYY-MM-DD",
        "title": "string",
        "tasks": [
          {
            "task": "string",
            "duration_minutes": 30,
            "resources": ["url1", "url2"]
          }
        ],
        "tips": "string"
      }
    ]
  },
  "today_tasks": {
    "day": 1,
    "date": "YYYY-MM-DD",
    "title": "string",
    "tasks": [...],
    "tips": "string"
  }
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/goals/" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Learn Python in 30 days",
    "description": "Master Python programming from basics to advanced concepts",
    "target_date": "2026-03-09T00:00:00"
  }'
```

---

### Get User Goals

Retrieve all goals for a specific user.

**Endpoint:** `GET /goals/user/{user_id}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| user_id | string | Yes | User's UUID |

**Response (200 OK):**

```json
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "title": "string",
    "description": "string",
    "target_date": "ISO8601 datetime",
    "created_at": "ISO8601 datetime",
    "streak": 5,
    "progress": 16.67,
    "roadmap": {...},
    "today_tasks": {...}
  }
]
```

**Example:**

```bash
curl -X GET "http://localhost:8000/goals/user/550e8400-e29b-41d4-a716-446655440000"
```

---

### Get Goal by ID

Retrieve a specific goal by its ID, including today's tasks.

**Endpoint:** `GET /goals/{goal_id}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Response (200 OK):**

```json
{
  "id": "uuid",
  "user_id": "uuid",
  "title": "string",
  "description": "string",
  "target_date": "ISO8601 datetime",
  "created_at": "ISO8601 datetime",
  "streak": 5,
  "progress": 16.67,
  "roadmap": {...},
  "today_tasks": {...}
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X GET "http://localhost:8000/goals/550e8400-e29b-41d4-a716-446655440000"
```

---

### Delete Goal

Delete a goal by its ID.

**Endpoint:** `DELETE /goals/{goal_id}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Response (200 OK):**

```json
{
  "message": "Goal deleted successfully"
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X DELETE "http://localhost:8000/goals/550e8400-e29b-41d4-a716-446655440000"
```

---

## Chat

### Send Message

Send a message to the AI for a specific goal and receive a response.

**Endpoint:** `POST /chat/send`

**Request Body:**

```json
{
  "goal_id": "uuid",
  "message": "string"
}
```

**Response (200 OK):**

```json
{
  "user_message": "string",
  "ai_response": "string",
  "timestamp": "ISO8601 datetime"
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/chat/send" \
  -H "Content-Type: application/json" \
  -d '{
    "goal_id": "550e8400-e29b-41d4-a716-446655440000",
    "message": "How can I stay motivated?"
  }'
```

---

### Get Chat History

Retrieve the complete chat history for a specific goal.

**Endpoint:** `GET /chat/history/{goal_id}`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Response (200 OK):**

```json
{
  "messages": [
    {
      "content": "string",
      "is_user": true,
      "timestamp": "ISO8601 datetime string"
    },
    {
      "content": "string",
      "is_user": false,
      "timestamp": "ISO8601 datetime string"
    }
  ]
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X GET "http://localhost:8000/chat/history/550e8400-e29b-41d4-a716-446655440000"
```

---

### Generate Roadmap

Generate or regenerate a roadmap for an existing goal.

**Endpoint:** `POST /chat/roadmap`

**Request Body:**

```json
{
  "goal_id": "uuid"
}
```

**Response (200 OK):**

```json
{
  "roadmap": {
    "total_days": 30,
    "summary": "string",
    "days": [...]
  },
  "days": 30
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/chat/roadmap" \
  -H "Content-Type: application/json" \
  -d '{"goal_id": "550e8400-e29b-41d4-a716-446655440000"}'
```

---

## Verification

### Generate Verification Test

Generate an AI-powered verification test for a specific goal based on today's completed tasks.

**Endpoint:** `POST /goals/{goal_id}/verification/generate`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Response (200 OK):**

```json
{
  "test_id": "uuid",
  "goal_id": "uuid",
  "date": "YYYY-MM-DD",
  "questions": [
    {
      "id": 1,
      "type": "multiple_choice",
      "question": "string",
      "options": ["option1", "option2", "option3", "option4"],
      "correct_answer": 0,
      "explanation": "string"
    },
    {
      "id": 2,
      "type": "code_completion",
      "question": "string",
      "code_snippet": "string",
      "correct_answer": "string",
      "explanation": "string"
    },
    {
      "id": 3,
      "type": "short_answer",
      "question": "string",
      "correct_answer": "string",
      "explanation": "string"
    }
  ],
  "pass_threshold": 0.7,
  "time_limit_minutes": 10,
  "created_at": "ISO8601 datetime"
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Error Response (400 Bad Request):**

```json
{
  "detail": "No tasks completed today. Complete tasks before generating verification test."
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/goals/550e8400-e29b-41d4-a716-446655440000/verification/generate"
```

---

### Submit Verification Test

Submit answers for a verification test and receive scoring and feedback.

**Endpoint:** `POST /goals/{goal_id}/verification/submit`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Request Body:**

```json
{
  "test_id": "uuid",
  "answers": [
    {
      "question_id": 1,
      "answer": 0
    },
    {
      "question_id": 2,
      "answer": "print('Hello World')"
    },
    {
      "question_id": 3,
      "answer": "Returns the length of an object"
    }
  ]
}
```

**Response (200 OK):**

```json
{
  "test_id": "uuid",
  "goal_id": "uuid",
  "date": "YYYY-MM-DD",
  "score": 1.0,
  "passed": true,
  "correct_answers": 3,
  "total_questions": 3,
  "feedback": {
    "message": "Excellent work! You've mastered today's concepts.",
    "question_feedback": [
      {
        "question_id": 1,
        "correct": true,
        "explanation": "Lists in Python are created using square brackets []"
      },
      {
        "question_id": 2,
        "correct": true,
        "explanation": "The print() function outputs text to the console"
      },
      {
        "question_id": 3,
        "correct": true,
        "explanation": "len() returns the number of items in a container"
      }
    ]
  },
  "streak_updated": true,
  "completed_at": "ISO8601 datetime"
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Error Response (400 Bad Request):**

```json
{
  "detail": "Test not found or expired"
}
```

**Example:**

```bash
curl -X POST "http://localhost:8000/goals/550e8400-e29b-41d4-a716-446655440000/verification/submit" \
  -H "Content-Type: application/json" \
  -d '{
    "test_id": "test-uuid",
    "answers": [
      {"question_id": 1, "answer": 0},
      {"question_id": 2, "answer": "print('Hello World')"},
      {"question_id": 3, "answer": "Returns the length of an object"}
    ]
  }'
```

---

### Get Verification Statistics

Retrieve verification statistics for a specific goal.

**Endpoint:** `GET /goals/{goal_id}/verification/stats`

**Path Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| goal_id | string | Yes | Goal's UUID |

**Response (200 OK):**

```json
{
  "goal_id": "uuid",
  "verification_stats": {
    "total_tests": 15,
    "passed": 14,
    "failed": 1,
    "average_score": 0.85,
    "perfect_scores": 8,
    "current_streak": 5,
    "longest_streak": 10
  },
  "recent_verifications": [
    {
      "date": "YYYY-MM-DD",
      "score": 1.0,
      "passed": true,
      "questions_count": 3
    },
    {
      "date": "YYYY-MM-DD",
      "score": 0.67,
      "passed": true,
      "questions_count": 3
    }
  ]
}
```

**Error Response (404 Not Found):**

```json
{
  "detail": "Goal not found"
}
```

**Example:**

```bash
curl -X GET "http://localhost:8000/goals/550e8400-e29b-41d4-a716-446655440000/verification/stats"
```

---

## Health Check

### Root Endpoint

Get API welcome message.

**Endpoint:** `GET /`

**Response (200 OK):**

```json
{
  "message": "Welcome to DoIt API"
}
```

---

### Health Check

Check API and database health status.

**Endpoint:** `GET /health`

**Response (200 OK):**

```json
{
  "status": "healthy",
  "database": "connected"
}
```

---

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 404 | Resource not found |
| 422 | Validation error |
| 500 | Internal server error |

### Common Error Responses

**Validation Error (422):**

```json
{
  "detail": [
    {
      "loc": ["body", "phone_number"],
      "msg": "ensure this value has at least 10 characters",
      "type": "value_error.any_str.min_length"
    }
  ]
}
```

**Not Found (404):**

```json
{
  "detail": "User not found"
}
```

---

## Data Models

### UserCreate

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| phone_number | string | min: 10, max: 15 | User's phone number |

### UserResponse

| Field | Type | Description |
|-------|------|-------------|
| id | string (UUID) | User's unique identifier |
| phone_number | string | User's phone number |
| created_at | datetime | Account creation timestamp |

### GoalCreate

| Field | Type | Description |
|-------|------|-------------|
| user_id | string (UUID) | User's unique identifier |
| title | string | Goal title |
| description | string | Goal description |
| target_date | datetime | Target completion date |

### GoalResponse

| Field | Type | Description |
|-------|------|-------------|
| id | string (UUID) | Goal's unique identifier |
| user_id | string (UUID) | User's unique identifier |
| title | string | Goal title |
| description | string | Goal description |
| target_date | datetime | Target completion date |
| created_at | datetime | Goal creation timestamp |
| streak | integer | Current streak count |
| progress | float | Progress percentage (0.0 - 100.0) |
| roadmap | object | Full AI-generated roadmap |
| today_tasks | object | Today's tasks from roadmap |

### Roadmap

| Field | Type | Description |
|-------|------|-------------|
| total_days | integer | Total days in roadmap |
| summary | string | Roadmap summary |
| days | array | Array of daily tasks |

### DayTask

| Field | Type | Description |
|-------|------|-------------|
| day | integer | Day number |
| date | string | Date in YYYY-MM-DD format |
| title | string | Day title/theme |
| tasks | array | Array of tasks |
| tips | string | Helpful tips for the day |

### Task

| Field | Type | Description |
|-------|------|-------------|
| task | string | Task description |
| duration_minutes | integer | Estimated duration |
| resources | array | Array of resource URLs |

---

## Authentication Requirements

Currently, the API does not implement token-based authentication. All endpoints are publicly accessible. Future versions will include:

- JWT token authentication
- Refresh token mechanism
- Protected routes requiring valid tokens

---

## Rate Limiting

Rate limiting is not currently implemented. Future versions will include:

- Request rate limits per user
- Burst allowance
- Sliding window algorithm

---

## API Versioning

The API uses URL path versioning. The current version is `v1` (implicit). Future versions will be accessible via `/v2/`, `/v3/`, etc.

---

## Interactive Documentation

FastAPI provides interactive API documentation at:

- **Swagger UI:** `http://localhost:8000/docs`
- **ReDoc:** `http://localhost:8000/redoc`

These interfaces allow you to test all endpoints directly from your browser.
