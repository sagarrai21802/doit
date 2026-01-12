import os
import shutil
import json

# Source paths (from previous tool outputs)
sources = {
    "onboarding_focus": "/Users/apple/.gemini/antigravity/brain/b9c3c2bb-44d3-4093-9109-4e1278bfb8f5/onboarding_focus_1768206534380.png",
    "onboarding_roadmap": "/Users/apple/.gemini/antigravity/brain/b9c3c2bb-44d3-4093-9109-4e1278bfb8f5/onboarding_roadmap_1768206554818.png",
    "onboarding_community": "/Users/apple/.gemini/antigravity/brain/b9c3c2bb-44d3-4093-9109-4e1278bfb8f5/onboarding_community_1768206583612.png"
}

assets_dir = "/Users/apple/Documents/doit/doit/Assets.xcassets"

def create_imageset(name, source_path):
    imageset_path = os.path.join(assets_dir, f"{name}.imageset")
    os.makedirs(imageset_path, exist_ok=True)
    
    # Copy image
    dest_image = os.path.join(imageset_path, f"{name}.png")
    shutil.copy(source_path, dest_image)
    
    # Create Contents.json
    contents = {
        "images": [
            {
                "filename": f"{name}.png",
                "idiom": "universal",
                "scale": "1x"
            },
            {
                "idiom": "universal",
                "scale": "2x"
            },
            {
                "idiom": "universal",
                "scale": "3x"
            }
        ],
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    
    with open(os.path.join(imageset_path, "Contents.json"), "w") as f:
        json.dump(contents, f, indent=2)

for name, path in sources.items():
    if os.path.exists(path):
        create_imageset(name, path)
        print(f"Created assets for {name}")
    else:
        print(f"File not found: {path}")
