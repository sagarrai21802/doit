from pydantic import BaseModel, Field
from typing import Optional, List, Any
from datetime import datetime
import uuid

class GoalCreate(BaseModel):
    """Request model for creating a goal"""
    user_id: str
    title: str
    description: str
    target_date: datetime

class GoalResponse(BaseModel):
    """Response model for goal - what frontend receives"""
    id: str
    user_id: str
    title: str
    description: str
    target_date: datetime
    created_at: datetime
    streak: int = 0
    progress: float = 0.0
    roadmap: Optional[dict] = None  # The full roadmap JSON
    today_tasks: Optional[dict] = None  # Just today's tasks for quick access

class Goal(BaseModel):
    """Database model for goal"""
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    user_id: str
    title: str
    description: str
    target_date: datetime
    created_at: datetime = Field(default_factory=datetime.utcnow)
    streak: int = 0
    progress: float = 0.0
    roadmap: Optional[dict] = None  # Stores the full Gemini roadmap JSON
