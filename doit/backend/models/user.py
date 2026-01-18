from pydantic import BaseModel, Field
from datetime import datetime
import uuid

class UserCreate(BaseModel):
    """Request model for user registration"""
    phone_number: str = Field(..., min_length=10, max_length=15)

class UserResponse(BaseModel):
    """Response model for user"""
    id: str
    phone_number: str
    created_at: datetime

class User(BaseModel):
    """Database model for user"""
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    phone_number: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
