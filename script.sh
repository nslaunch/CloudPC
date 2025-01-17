#!/bin/bash

# Directory for temporary project inside Codespaces
PROJECT_DIR="$HOME/wakatime-simulation"
mkdir -p "$PROJECT_DIR"

# Files to create and simulate activity
FILES=("file1.py" "file2.js" "file3.html" "file4.css" "file5.md")

# Create files if they don’t already exist
for file in "${FILES[@]}"; do
    touch "$PROJECT_DIR/$file"
done

echo "Files created in $PROJECT_DIR. Open them manually in VS Code once."

echo "Make sure to open one of the files in the VS Code editor for WakaTime to detect activity."
echo "Starting activity simulation. Press Ctrl+C to stop."

# Infinite loop to simulate typing activity
while true; do
    for file in "${FILES[@]}"; do
        # Append text to the file (simulates editing)
        echo "$(date): Editing $file" >> "$PROJECT_DIR/$file"

        # Bring the file into focus in VS Code
        code "$PROJECT_DIR/$file"

        # Pause for a random duration (1-5 seconds)
        sleep $((RANDOM % 5 + 1))
    done
done
