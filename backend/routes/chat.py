from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from services.db import get_db
from services.ai import generate_chat_response, generate_roadmap
from datetime import datetime

router = APIRouter(prefix="/chat", tags=["Chat"])

class ChatMessage(BaseModel):
    goal_id: str
    message: str

class ChatResponse(BaseModel):
    user_message: str
    ai_response: str
    timestamp: datetime

@router.post("/send", response_model=ChatResponse)
async def send_message(chat_data: ChatMessage):
    """Send a message and get AI response for a goal"""
    db = get_db()
    goals_collection = db["goals"]
    
    # Get the goal
    goal = goals_collection.find_one({"id": chat_data.goal_id})
    if not goal:
        raise HTTPException(status_code=404, detail="Goal not found")
    
    # Get existing messages
    messages = goal.get("messages", [])
    
    # Generate AI response
    ai_response = generate_chat_response(
        goal_title=goal["title"],
        goal_description=goal["description"],
        user_message=chat_data.message,
        chat_history=messages
    )
    
    # Save messages to goal
    timestamp = datetime.utcnow()
    user_msg = {"content": chat_data.message, "is_user": True, "timestamp": timestamp.isoformat()}
    ai_msg = {"content": ai_response, "is_user": False, "timestamp": timestamp.isoformat()}
    
    goals_collection.update_one(
        {"id": chat_data.goal_id},
        {"$push": {"messages": {"$each": [user_msg, ai_msg]}}}
    )
    
    return ChatResponse(
        user_message=chat_data.message,
        ai_response=ai_response,
        timestamp=timestamp
    )

@router.get("/history/{goal_id}")
async def get_chat_history(goal_id: str):
    """Get chat history for a goal"""
    db = get_db()
    goals_collection = db["goals"]
    
    goal = goals_collection.find_one({"id": goal_id})
    if not goal:
        raise HTTPException(status_code=404, detail="Goal not found")
    
    return {"messages": goal.get("messages", [])}

class RoadmapRequest(BaseModel):
    goal_id: str

@router.post("/roadmap")
async def generate_goal_roadmap(request: RoadmapRequest):
    """Generate a roadmap for a goal"""
    db = get_db()
    goals_collection = db["goals"]
    
    goal = goals_collection.find_one({"id": request.goal_id})
    if not goal:
        raise HTTPException(status_code=404, detail="Goal not found")
    
    # Calculate days until target
    target_date = goal["target_date"]
    if isinstance(target_date, str):
        target_date = datetime.fromisoformat(target_date)
    days = (target_date - datetime.utcnow()).days
    days = max(1, days)  # At least 1 day
    
    roadmap = generate_roadmap(
        goal_title=goal["title"],
        goal_description=goal["description"],
        days=days
    )
    
    # Save roadmap to goal
    goals_collection.update_one(
        {"id": request.goal_id},
        {"$set": {"roadmap": roadmap}}
    )
    
    return {"roadmap": roadmap, "days": days}
