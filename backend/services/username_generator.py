import random

# Adjectives and nouns for username generation
ADJECTIVES = [
    "Swift", "Brave", "Calm", "Eager", "Fierce", "Gentle", "Happy", "Keen",
    "Lucky", "Mighty", "Noble", "Proud", "Quick", "Sharp", "Wise", "Bold",
    "Bright", "Clever", "Daring", "Fearless", "Golden", "Silent", "Cosmic"
]

NOUNS = [
    "Tiger", "Eagle", "Wolf", "Phoenix", "Dragon", "Lion", "Falcon", "Bear",
    "Hawk", "Panther", "Cobra", "Fox", "Owl", "Raven", "Shark", "Storm",
    "Thunder", "Blaze", "Shadow", "Spirit", "Warrior", "Voyager", "Pioneer"
]

def generate_username() -> str:
    """Generate a random anonymous username like 'SwiftTiger42'"""
    adjective = random.choice(ADJECTIVES)
    noun = random.choice(NOUNS)
    number = random.randint(10, 99)
    return f"{adjective}{noun}{number}"
