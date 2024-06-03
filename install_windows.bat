
@echo off

:: Clone the repository
git clone https://github.com/RyanBlaney/sheet_genie.git
cd sheet_genie

:: Install dependencies and compile the project
mix deps.get
mix escript.build

:: Move the executable to system path
move sheet_genie.exe C:\Windows\System32\sheet_genie.exe
