#!/bin/bash

# Directory for temporary project
PROJECT_DIR="/tmp/wakatime-simulation"
mkdir -p "$PROJECT_DIR"

# Generate file names for simulation
FILES=("file1.txt" "file2.py" "file3.js" "file4.java" "file5.html")

# Ensure VS Code CLI is available
if ! command -v code &> /dev/null; then
    echo "VS Code CLI 'code' is not installed or not in PATH."
    exit 1
fi

# Function to simulate file editing
simulate_edit() {
    local file="$1"
    echo "$(date): Simulating edit in $file" >> "$file"
    echo "Edited $file at $(date)"
}

# Open files in VS Code
for file in "${FILES[@]}"; do
    touch "$PROJECT_DIR/$file"
    code --add "$PROJECT_DIR/$file"  # Add the file to the current VS Code workspace
done

# Infinite loop to simulate coding activity
while true; do
    for file in "${FILES[@]}"; do
        simulate_edit "$PROJECT_DIR/$file"
        sleep $((RANDOM % 5 + 1))  # Random sleep between 1 and 5 seconds
    done
done
