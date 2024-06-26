#!/bin/bash

# Function to check the command existence
command_exists () {
    command -v "$1" >/dev/null 2>&1 ;
}

# Check if Git is installed
if ! command_exists git ; then
    echo "Git is not installed. Please install Git and try again."
    exit 1
fi

# Check if Mix is installed
if ! command_exists mix ; then
    echo "Elixir and Mix are not installed. Please install them and try again."
    exit 1
fi

# Clone the repository
git clone https://github.com/RyanBlaney/sheet_genie.git
cd sheet_genie || { echo "Failed to enter the directory"; exit 1; }

# Install dependencies and compile the project
mix deps.get || { echo "Failed to get dependencies"; exit 1; }
mix escript.build || { echo "Failed to build the project"; exit 1; }

# Move the executable to system path
if sudo mv ./sheet_genie /usr/local/bin/sheet_genie ; then
    echo "Executable moved to /usr/local/bin/sheet_genie"
else
    echo "Failed to move the executable"
    exit 1
fi

