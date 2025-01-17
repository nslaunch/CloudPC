#!/bin/bash

# Directory for temporary project
PROJECT_DIR="/tmp/wakatime-simulation"
mkdir -p "$PROJECT_DIR"

# Generate file names for simulation
FILES=(
    "file1.txt" "file2.py" "file3.js" "file4.java" "file5.html"
    "file6.css" "file7.php" "file8.rb" "file9.c" "file10.cpp"
    "file11.sh" "file12.md" "file13.json" "file14.xml" "file15.yaml"
)

# Function to simulate file editing
simulate_edit() {
    local file="$1"
    echo "$(date): Simulating edit in $file" >> "$file"
}

# Create the files if they don't already exist
for file in "${FILES[@]}"; do
    touch "$PROJECT_DIR/$file"
done

echo "Simulation started. Running indefinitely..."
echo "You can stop this script by pressing Ctrl+C."

# Infinite loop to simulate coding activity
while true; do
    for file in "${FILES[@]}"; do
        simulate_edit "$PROJECT_DIR/$file"
        sleep $((RANDOM % 5 + 1))  # Random sleep between 1 and 5 seconds
    done
done
