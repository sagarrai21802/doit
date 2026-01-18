from fastapi import APIRouter, HTTPException
from models.user import UserCreate, UserResponse, User
from services.db import get_db
from datetime import datetime

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/register", response_model=UserResponse)
async def register_user(user_data: UserCreate):
    """
    Register a new user with phone number.
    Returns existing user if already registered.
    """
    db = get_db()
    users_collection = db["users"]
    
    # Check if phone number already exists
    existing_user = users_collection.find_one({"phone_number": user_data.phone_number})
    if existing_user:
        return UserResponse(
            id=existing_user["id"],
            phone_number=existing_user["phone_number"],
            created_at=existing_user["created_at"]
        )
    
    # Create new user
    new_user = User(
        phone_number=user_data.phone_number,
        created_at=datetime.utcnow()
    )
    
    # Save to MongoDB
    users_collection.insert_one(new_user.model_dump())
    
    return UserResponse(
        id=new_user.id,
        phone_number=new_user.phone_number,
        created_at=new_user.created_at
    )

@router.get("/user/{phone_number}", response_model=UserResponse)
async def get_user(phone_number: str):
    """Get user by phone number"""
    db = get_db()
    users_collection = db["users"]
    
    user = users_collection.find_one({"phone_number": phone_number})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return UserResponse(
        id=user["id"],
        phone_number=user["phone_number"],
        created_at=user["created_at"]
    )
