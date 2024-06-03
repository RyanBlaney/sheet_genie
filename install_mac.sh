#!/bin/bash

# Clone the repository
git clone https://github.com/RyanBlaney/sheet_genie.git
cd sheet_genie

# Install dependencies and compile the project
mix deps.get
mix escript.build

# Move the executable to system path
sudo mv ./sheet_genie /usr/local/bin/sheet_genie
