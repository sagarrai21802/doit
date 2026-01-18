from google import genai
from config import GEMINI_API_KEY
from datetime import datetime, timedelta
import json

# Initialize client with API key
client = genai.Client(api_key=GEMINI_API_KEY)

def generate_roadmap(goal_title: str, goal_description: str, target_date: datetime) -> dict:
    """
    Generate a structured JSON roadmap for a goal using Gemini.
    Returns a dictionary with daily tasks.
    """
    # Calculate days until target
    today = datetime.utcnow()
    days_count = (target_date - today).days
    days_count = max(1, min(days_count, 365))  # Between 1 and 365 days
    
    # Build the prompt asking for JSON response
    prompt = f"""You are an expert life coach and learning specialist. Create a detailed day-by-day roadmap for achieving this goal.

GOAL: {goal_title}
DESCRIPTION: {goal_description}
DURATION: {days_count} days
START DATE: {today.strftime('%Y-%m-%d')}

Based on research from people who have successfully achieved similar goals, create a practical roadmap.

IMPORTANT: Return ONLY valid JSON in this exact format, no other text:
{{
  "total_days": {days_count},
  "summary": "Brief summary of the roadmap approach",
  "days": [
    {{
      "day": 1,
      "date": "{today.strftime('%Y-%m-%d')}",
      "title": "Day title/theme",
      "tasks": [
        {{
          "task": "Specific task description",
          "duration_minutes": 30,
          "resources": ["url1", "url2"]
        }}
      ],
      "tips": "Helpful tip for this day"
    }}
  ]
}}

Create entries for ALL {days_count} days. Each day should have 2-4 tasks.
Make tasks specific, actionable, and progressive.
Include real, useful resources where applicable.
Return ONLY the JSON, no markdown, no explanation."""

    try:
        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=prompt
        )
        
        # Parse the JSON response
        response_text = response.text.strip()
        
        # Remove markdown code blocks if present
        if response_text.startswith("```json"):
            response_text = response_text[7:]
        if response_text.startswith("```"):
            response_text = response_text[3:]
        if response_text.endswith("```"):
            response_text = response_text[:-3]
        
        roadmap = json.loads(response_text.strip())
        return roadmap
        
    except json.JSONDecodeError as e:
        print(f"JSON Parse Error: {e}")
        print(f"Response was: {response_text[:500]}")
        # Return a fallback structure
        return create_fallback_roadmap(goal_title, days_count, today)
    except Exception as e:
        print(f"Gemini API Error: {e}")
        return create_fallback_roadmap(goal_title, days_count, today)


def create_fallback_roadmap(goal_title: str, days_count: int, start_date: datetime) -> dict:
    """Create a basic fallback roadmap if API fails."""
    days = []
    for i in range(min(days_count, 7)):  # Just first 7 days for fallback
        current_date = start_date + timedelta(days=i)
        days.append({
            "day": i + 1,
            "date": current_date.strftime('%Y-%m-%d'),
            "title": f"Day {i + 1} - Work on {goal_title}",
            "tasks": [
                {
                    "task": f"Continue working towards your goal: {goal_title}",
                    "duration_minutes": 60,
                    "resources": []
                }
            ],
            "tips": "Stay consistent and track your progress!"
        })
    
    return {
        "total_days": days_count,
        "summary": f"A {days_count}-day plan to achieve: {goal_title}",
        "days": days
    }


def get_today_tasks(roadmap: dict) -> dict:
    """Extract today's tasks from the roadmap."""
    today = datetime.utcnow().strftime('%Y-%m-%d')
    
    for day in roadmap.get("days", []):
        if day.get("date") == today:
            return day
    
    # If no exact match, return first incomplete day (day 1)
    if roadmap.get("days"):
        return roadmap["days"][0]
    
    return None
