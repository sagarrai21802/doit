# DoIt Database Schema

## Overview

The DoIt application uses MongoDB as its primary database. MongoDB is a NoSQL document database that provides flexibility for storing complex, nested data structures like goal roadmaps and chat histories.

**Database Name:** `doit_db`

---

## Table of Contents

- [Users Collection](#users-collection)
- [Goals Collection](#goals-collection)
- [Groups Collection](#groups-collection)
- [Indexes](#indexes)
- [Relationships](#relationships)

---

## Users Collection

Stores user account information and authentication data.

### Collection Name: `users`

### Document Structure

```json
{
  "_id": ObjectId("..."),
  "id": "uuid",
  "phone_number": "string",
  "created_at": "ISO8601 datetime"
}
```

### Field Specifications

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `_id` | ObjectId | Yes | Auto-generated | MongoDB document identifier |
| `id` | string (UUID) | Yes | Auto-generated | Unique user identifier (UUID v4) |
| `phone_number` | string | Yes | - | User's phone number (10-15 characters) |
| `created_at` | datetime | Yes | Current UTC timestamp | Account creation timestamp |

### Constraints

- `phone_number`: Must be between 10 and 15 characters
- `id`: Must be a valid UUID v4 string
- `created_at`: ISO8601 format datetime

### Example Document

```json
{
  "_id": ObjectId("65c2a1b2e4b0f3a1c8d9e0f1"),
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "phone_number": "1234567890",
  "created_at": "2026-02-07T12:00:00.000000Z"
}
```

### Indexes

| Index | Fields | Type | Description |
|-------|--------|------|-------------|
| `phone_number_index` | `phone_number` | Unique | Ensures unique phone numbers |
| `id_index` | `id` | Unique | Ensures unique user IDs |

---

## Goals Collection

Stores goal information, AI-generated roadmaps, and chat history.

### Collection Name: `goals`

### Document Structure

```json
{
  "_id": ObjectId("..."),
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
  "messages": [
    {
      "content": "string",
      "is_user": true,
      "timestamp": "ISO8601 datetime string"
    }
  ],
  "daily_verifications": [
    {
      "date": "YYYY-MM-DD",
      "test_id": "uuid",
      "questions_count": 3,
      "score": 1.0,
      "passed": true,
      "completed_at": "ISO8601 datetime"
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

### Field Specifications

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `_id` | ObjectId | Yes | Auto-generated | MongoDB document identifier |
| `id` | string (UUID) | Yes | Auto-generated | Unique goal identifier (UUID v4) |
| `user_id` | string (UUID) | Yes | - | Reference to user who owns the goal |
| `title` | string | Yes | - | Goal title |
| `description` | string | Yes | - | Detailed goal description |
| `target_date` | datetime | Yes | - | Target completion date |
| `created_at` | datetime | Yes | Current UTC timestamp | Goal creation timestamp |
| `streak` | integer | No | 0 | Current streak count (consecutive days of activity) |
| `progress` | float | No | 0.0 | Progress percentage (0.0 - 100.0) |
| `roadmap` | object | No | null | AI-generated roadmap structure |
| `messages` | array | No | [] | Chat history with AI |
| `daily_verifications` | array | No | [] | Daily verification test results |
| `verification_stats` | object | No | null | Aggregated verification statistics |

### Roadmap Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `total_days` | integer | Total number of days in the roadmap |
| `summary` | string | Brief summary of the roadmap approach |
| `days` | array | Array of daily task objects |

### Day Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `day` | integer | Day number (1-indexed) |
| `date` | string | Date in YYYY-MM-DD format |
| `title` | string | Day title or theme |
| `tasks` | array | Array of task objects |
| `tips` | string | Helpful tips for the day |

### Task Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `task` | string | Specific task description |
| `duration_minutes` | integer | Estimated duration in minutes |
| `resources` | array | Array of resource URLs (strings) |

### Message Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `content` | string | Message content |
| `is_user` | boolean | `true` if from user, `false` if from AI |
| `timestamp` | string | ISO8601 datetime string |

### Daily Verification Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `date` | string | Date in YYYY-MM-DD format |
| `test_id` | string (UUID) | Unique identifier for the verification test |
| `questions_count` | integer | Number of questions in the test |
| `score` | float | Score achieved (0.0 - 1.0) |
| `passed` | boolean | Whether the test was passed (score >= 0.7) |
| `completed_at` | datetime | ISO8601 datetime when test was completed |

### Verification Stats Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `total_tests` | integer | Total number of verification tests taken |
| `passed` | integer | Number of tests passed |
| `failed` | integer | Number of tests failed |
| `average_score` | float | Average score across all tests (0.0 - 1.0) |
| `perfect_scores` | integer | Number of tests with 100% score |

### Constraints

- `user_id`: Must reference a valid user ID
- `target_date`: Must be a valid ISO8601 datetime
- `streak`: Must be a non-negative integer
- `progress`: Must be between 0.0 and 100.0

### Example Document

```json
{
  "_id": ObjectId("65c2a1b2e4b0f3a1c8d9e0f2"),
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Learn Python in 30 days",
  "description": "Master Python programming from basics to advanced concepts including OOP, data structures, and web development.",
  "target_date": "2026-03-09T00:00:00.000000Z",
  "created_at": "2026-02-07T12:00:00.000000Z",
  "streak": 5,
  "progress": 16.67,
  "roadmap": {
    "total_days": 30,
    "summary": "A comprehensive 30-day journey from Python basics to building real-world applications.",
    "days": [
      {
        "day": 1,
        "date": "2026-02-07",
        "title": "Getting Started with Python",
        "tasks": [
          {
            "task": "Install Python and set up development environment",
            "duration_minutes": 30,
            "resources": ["https://python.org/downloads/"]
          },
          {
            "task": "Write your first Python program",
            "duration_minutes": 45,
            "resources": ["https://docs.python.org/3/tutorial/"]
          }
        ],
        "tips": "Use VS Code with Python extension for the best development experience."
      }
    ]
  },
  "messages": [
    {
      "content": "How can I stay motivated while learning?",
      "is_user": true,
      "timestamp": "2026-02-07T12:30:00.000000Z"
    },
    {
      "content": "Staying motivated is key! Try setting small daily goals, tracking your progress, and celebrating small wins. Remember why you started this journey.",
      "is_user": false,
      "timestamp": "2026-02-07T12:30:05.000000Z"
    }
  ]
}
```

### Indexes

| Index | Fields | Type | Description |
|-------|--------|------|-------------|
| `id_index` | `id` | Unique | Ensures unique goal IDs |
| `user_id_index` | `user_id` | Non-unique | Optimizes queries by user |
| `user_id_created_index` | `user_id`, `created_at` | Compound | Optimizes user goal list queries |

---

## Groups Collection

Stores anonymous community groups for users with similar goals.

### Collection Name: `groups`

### Document Structure

```json
{
  "_id": ObjectId("..."),
  "id": "uuid",
  "category": "string",
  "subcategory": "string",
  "name": "string",
  "members": ["user_id_1", "user_id_2"],
  "max_members": 50,
  "messages": [
    {
      "user_id": "uuid",
      "username": "string",
      "content": "string",
      "timestamp": "ISO8601 datetime string"
    }
  ],
  "created_at": "ISO8601 datetime"
}
```

### Field Specifications

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `_id` | ObjectId | Yes | Auto-generated | MongoDB document identifier |
| `id` | string (UUID) | Yes | Auto-generated | Unique group identifier (UUID v4) |
| `category` | string | Yes | - | Goal category (e.g., "programming", "fitness") |
| `subcategory` | string | No | null | Specific subcategory (e.g., "python", "weight-loss") |
| `name` | string | Yes | - | Display name for the group |
| `members` | array | Yes | [] | Array of user IDs (strings) |
| `max_members` | integer | No | 50 | Maximum number of members allowed |
| `messages` | array | No | [] | Group chat messages |
| `created_at` | datetime | Yes | Current UTC timestamp | Group creation timestamp |

### Group Message Object Structure

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | string (UUID) | Sender's user ID |
| `username` | string | Sender's anonymous username |
| `content` | string | Message content |
| `timestamp` | string | ISO8601 datetime string |

### Constraints

- `members`: Array of valid user ID strings
- `max_members`: Must be a positive integer (typically 10-100)
- `category`: Must be a valid category string

### Example Document

```json
{
  "_id": ObjectId("65c2a1b2e4b0f3a1c8d9e0f3"),
  "id": "670e8400-e29b-41d4-a716-446655440002",
  "category": "programming",
  "subcategory": "python",
  "name": "Python Learners",
  "members": [
    "550e8400-e29b-41d4-a716-446655440000",
    "550e8400-e29b-41d4-a716-446655440001"
  ],
  "max_members": 50,
  "messages": [
    {
      "user_id": "550e8400-e29b-41d4-a716-446655440000",
      "username": "CosmicLearner42",
      "content": "Just completed day 5 of my Python roadmap!",
      "timestamp": "2026-02-07T14:00:00.000000Z"
    }
  ],
  "created_at": "2026-02-07T10:00:00.000000Z"
}
```

### Indexes

| Index | Fields | Type | Description |
|-------|--------|------|-------------|
| `id_index` | `id` | Unique | Ensures unique group IDs |
| `category_index` | `category` | Non-unique | Optimizes category-based queries |
| `category_subcategory_index` | `category`, `subcategory` | Compound | Optimizes matching queries |

---

## Indexes

### Summary of All Indexes

| Collection | Index Name | Fields | Type | Purpose |
|------------|------------|--------|------|---------|
| `users` | `phone_number_index` | `phone_number` | Unique | Phone number uniqueness |
| `users` | `id_index` | `id` | Unique | User ID uniqueness |
| `goals` | `id_index` | `id` | Unique | Goal ID uniqueness |
| `goals` | `user_id_index` | `user_id` | Non-unique | User goal queries |
| `goals` | `user_id_created_index` | `user_id`, `created_at` | Compound | Sorted user goals |
| `groups` | `id_index` | `id` | Unique | Group ID uniqueness |
| `groups` | `category_index` | `category` | Non-unique | Category queries |
| `groups` | `category_subcategory_index` | `category`, `subcategory` | Compound | Matching queries |

### Creating Indexes

To create indexes in MongoDB, use the following commands:

```javascript
// Users collection
db.users.createIndex({ phone_number: 1 }, { unique: true })
db.users.createIndex({ id: 1 }, { unique: true })

// Goals collection
db.goals.createIndex({ id: 1 }, { unique: true })
db.goals.createIndex({ user_id: 1 })
db.goals.createIndex({ user_id: 1, created_at: -1 })

// Groups collection
db.groups.createIndex({ id: 1 }, { unique: true })
db.groups.createIndex({ category: 1 })
db.groups.createIndex({ category: 1, subcategory: 1 })
```

---

## Relationships

### User → Goals (One-to-Many)

A user can have multiple goals. Each goal document contains a `user_id` field that references the user.

```
User (1) ──────< (N) Goals
```

**Query Example:**

```javascript
// Get all goals for a user
db.goals.find({ user_id: "550e8400-e29b-41d4-a716-446655440000" })
```

### User → Groups (Many-to-Many)

A user can be a member of multiple groups, and a group can have multiple users. This is implemented using an array of user IDs in the group document.

```
User (N) ──────< (M) Groups
```

**Query Example:**

```javascript
// Get all groups a user is a member of
db.groups.find({ members: "550e8400-e29b-41d4-a716-446655440000" })
```

### Goal → Messages (One-to-Many)

Each goal has its own chat history stored in the `messages` array within the goal document.

```
Goal (1) ──────< (N) Messages
```

### Group → Messages (One-to-Many)

Each group has its own chat history stored in the `messages` array within the group document.

```
Group (1) ──────< (N) Messages
```

---

## Data Validation

### User Validation Rules

- `phone_number`: Must be 10-15 characters, numeric only
- `id`: Must be a valid UUID v4 string
- `created_at`: Must be a valid ISO8601 datetime

### Goal Validation Rules

- `user_id`: Must reference an existing user
- `title`: Must not be empty
- `description`: Must not be empty
- `target_date`: Must be a future date
- `streak`: Must be >= 0
- `progress`: Must be between 0.0 and 100.0

### Group Validation Rules

- `members`: Array must contain valid user IDs
- `max_members`: Must be between 1 and 100
- `category`: Must be a valid category string

---

## Database Connection

### Connection String

The application connects to MongoDB using the connection string stored in the `.env` file:

```
MONGODB_URI=mongodb+srv://<username>:<password>@cluster.mongodb.net/doit_db?retryWrites=true&w=majority
```

### Connection Configuration

- **Server API:** ServerApi Version 1
- **Retry Writes:** Enabled
- **Write Concern:** Majority

### Connection Lifecycle

```python
# Startup
connect_db()  # Establishes connection and returns database instance

# During operation
get_db()  # Returns the cached database instance

# Shutdown
close_db()  # Closes the connection
```

---

## Backup and Recovery

### Backup Strategy

1. **Automated Backups:** MongoDB Atlas provides automated daily backups
2. **Point-in-Time Recovery:** Enables recovery to any point within the retention window
3. **Snapshot Backup:** Manual snapshots can be created before major changes

### Backup Commands

```bash
# Create a backup using mongodump
mongodump --uri="mongodb+srv://<username>:<password>@cluster.mongodb.net/doit_db" --out=/backup/path

# Restore from backup
mongorestore --uri="mongodb+srv://<username>:<password>@cluster.mongodb.net/doit_db" /backup/path
```

---

## Migration Strategy

### Schema Evolution

Since MongoDB is schemaless, schema changes can be handled without migrations:

1. **Adding Fields:** New fields can be added to documents without affecting existing ones
2. **Removing Fields:** Old fields can be ignored in application code
3. **Changing Field Types:** Application code should handle multiple types during transition

### Data Migration Example

```javascript
// Add a new field to all existing goals
db.goals.updateMany(
  {},
  { $set: { status: "active" } }
)

// Rename a field
db.goals.updateMany(
  {},
  { $rename: { "old_field": "new_field" } }
)
```

---

## Performance Considerations

### Query Optimization

1. **Use Indexes:** Ensure all frequently queried fields are indexed
2. **Limit Results:** Use `limit()` for large result sets
3. **Projection:** Only return required fields using `projection()`
4. **Pagination:** Implement pagination for list queries

### Example Optimized Query

```javascript
// Get user's goals with pagination
db.goals.find(
  { user_id: "550e8400-e29b-41d4-a716-446655440000" },
  { projection: { id: 1, title: 1, progress: 1 } }
).sort({ created_at: -1 }).limit(20)
```

---

## Security Considerations

1. **Data Encryption:** MongoDB Atlas provides encryption at rest and in transit
2. **Access Control:** Use role-based access control (RBAC)
3. **Network Isolation:** Configure IP whitelist for database access
4. **Input Validation:** Validate all inputs before database operations
5. **Query Injection:** Use parameterized queries to prevent injection attacks
