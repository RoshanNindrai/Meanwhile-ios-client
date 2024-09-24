import os
import re
import json

# Paths and configurations
PROJECT_PATH = "./"  # Set to your project root path
XCSTRINGS_PATH = "./Meanwhile-iOS/Localizable.xcstrings"  # Path for the .xcstrings file
SOURCE_LANGUAGE = "en"  # Source language code

# Regular expression to find Text("...")
text_pattern = re.compile(r'Text\("(.+?)"\)')

# Load existing xcstrings data if the file exists
if os.path.exists(XCSTRINGS_PATH):
    with open(XCSTRINGS_PATH, "r", encoding="utf-8") as xcstrings_file:
        try:
            xcstrings_data = json.load(xcstrings_file)
        except json.JSONDecodeError:
            # If the file is corrupted or empty, initialize a new structure
            xcstrings_data = {
                "sourceLanguage": SOURCE_LANGUAGE,
                "strings": {},
                "version": "1.0"
            }
else:
    # Initialize the xcstrings structure if file doesn't exist
    xcstrings_data = {
        "sourceLanguage": SOURCE_LANGUAGE,
        "strings": {},
        "version": "1.0"
    }

def localize_file(file_path):
    with open(file_path, "r") as file:
        lines = file.readlines()
    
    new_lines = []
    for line in lines:
        match = text_pattern.search(line)
        if match:
            localized_string = match.group(1)
            key = localized_string.replace(" ", "_").replace(".", "_")
            
            # Add or update the localized string in the xcstrings structure
            xcstrings_data["strings"][key] = {
                "extractionState": "manual",
                "localizations": {
                    SOURCE_LANGUAGE: {
                        "stringUnit": {
                            "state": "translated",
                            "value": localized_string
                        }
                    }
                }
            }
            
            # Replace the original Text() line with the localized version
            localized_line = line.replace(f'Text("{localized_string}")', f'Text(LocalizedStringKey("{key}"))')
            new_lines.append(localized_line)
        else:
            new_lines.append(line)
    
    # Save the modified Swift file
    with open(file_path, "w") as file:
        file.writelines(new_lines)

# Walk through the project directory and find Swift files
for root_dir, dirs, files in os.walk(PROJECT_PATH):
    for file in files:
        if file.endswith(".swift"):
            file_path = os.path.join(root_dir, file)
            localize_file(file_path)

# Save the updated xcstrings structure to the .xcstrings file in JSON format
with open(XCSTRINGS_PATH, "w", encoding="utf-8") as xcstrings_file:
    json.dump(xcstrings_data, xcstrings_file, ensure_ascii=False, indent=2)

print(f"Localization completed. Strings saved to {XCSTRINGS_PATH}")
