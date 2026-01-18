from pymongo import MongoClient
from pymongo.server_api import ServerApi
from config import MONGODB_URI, DATABASE_NAME

client = None
db = None

def connect_db():
    """Connect to MongoDB Atlas and return the database instance."""
    global client, db
    try:
        client = MongoClient(MONGODB_URI, server_api=ServerApi('1'))
        # Test connection
        client.admin.command('ping')
        db = client[DATABASE_NAME]
        print("✅ Successfully connected to MongoDB!")
        return db
    except Exception as e:
        print(f"❌ Failed to connect to MongoDB: {e}")
        raise e

def get_db():
    """Get the database instance."""
    global db
    if db is None:
        connect_db()
    return db

def close_db():
    """Close the database connection."""
    global client
    if client:
        client.close()
        print("MongoDB connection closed.")
