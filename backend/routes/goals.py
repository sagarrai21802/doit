from fastapi import APIRouter, HTTPException
from models.goal import GoalCreate, GoalResponse, Goal
from services.db import get_db
from services.ai import generate_roadmap, get_today_tasks
from typing import List
from datetime import datetime

router = APIRouter(prefix="/goals", tags=["Goals"])

@router.post("/", response_model=GoalResponse)
async def create_goal(goal_data: GoalCreate):
    """
    Create a new goal for a user.
    
    Flow:
    1. Save goal to MongoDB
    2. Call Gemini to generate roadmap
    3. Update goal with roadmap
    4. Return goal + today's tasks
    """
    db = get_db()
    goals_collection = db["goals"]
    
    # Step 1: Create new goal
    new_goal = Goal(
        user_id=goal_data.user_id,
        title=goal_data.title,
        description=goal_data.description,
        target_date=goal_data.target_date,
        created_at=datetime.utcnow()
    )
    
    # Step 2: Generate roadmap using Gemini
    roadmap = generate_roadmap(
        goal_title=goal_data.title,
        goal_description=goal_data.description,
        target_date=goal_data.target_date
    )
    
    # Step 3: Add roadmap to goal
    new_goal.roadmap = roadmap
    
    # Step 4: Save to MongoDB
    goals_collection.insert_one(new_goal.model_dump())
    
    # Step 5: Get today's tasks for response
    today_tasks = get_today_tasks(roadmap)
    
    return GoalResponse(
        id=new_goal.id,
        user_id=new_goal.user_id,
        title=new_goal.title,
        description=new_goal.description,
        target_date=new_goal.target_date,
        created_at=new_goal.created_at,
        streak=new_goal.streak,
        progress=new_goal.progress,
        roadmap=roadmap,
        today_tasks=today_tasks
    )

@router.get("/user/{user_id}", response_model=List[GoalResponse])
async def get_user_goals(user_id: str):
    """Get all goals for a user"""
    db = get_db()
    goals_collection = db["goals"]
    
    goals = list(goals_collection.find({"user_id": user_id}))
    
    result = []
    for goal in goals:
        roadmap = goal.get("roadmap", {})
        today_tasks = get_today_tasks(roadmap) if roadmap else None
        
        result.append(GoalResponse(
            id=goal["id"],
            user_id=goal["user_id"],
            title=goal["title"],
            description=goal["description"],
            target_date=goal["target_date"],
            created_at=goal["created_at"],
            streak=goal.get("streak", 0),
            progress=goal.get("progress", 0.0),
            roadmap=roadmap,
            today_tasks=today_tasks
        ))
    
    return result

@router.get("/{goal_id}", response_model=GoalResponse)
async def get_goal(goal_id: str):
    """Get a specific goal by ID with today's tasks"""
    db = get_db()
    goals_collection = db["goals"]
    
    goal = goals_collection.find_one({"id": goal_id})
    if not goal:
        raise HTTPException(status_code=404, detail="Goal not found")
    
    roadmap = goal.get("roadmap", {})
    today_tasks = get_today_tasks(roadmap) if roadmap else None
    
    return GoalResponse(
        id=goal["id"],
        user_id=goal["user_id"],
        title=goal["title"],
        description=goal["description"],
        target_date=goal["target_date"],
        created_at=goal["created_at"],
        streak=goal.get("streak", 0),
        progress=goal.get("progress", 0.0),
        roadmap=roadmap,
        today_tasks=today_tasks
    )

@router.delete("/{goal_id}")
async def delete_goal(goal_id: str):
    """Delete a goal"""
    db = get_db()
    goals_collection = db["goals"]
    
    result = goals_collection.delete_one({"id": goal_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Goal not found")
    
    return {"message": "Goal deleted successfully"}
