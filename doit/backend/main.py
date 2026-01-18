from fastapi import FastAPI
from contextlib import asynccontextmanager
from services.db import connect_db, close_db
from routes.auth import router as auth_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Connect to MongoDB
    connect_db()
    yield
    # Shutdown: Close connection
    close_db()

app = FastAPI(
    title="DoIt API",
    description="Backend for DoIt Goal Achievement Platform",
    version="1.0.0",
    lifespan=lifespan
)

# Include routers
app.include_router(auth_router)

@app.get("/")
async def root():
    return {"message": "Welcome to DoIt API"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "database": "connected"}
