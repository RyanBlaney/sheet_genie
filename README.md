# SheetGenie

SheetGenie is a command line script that automates the process of collecting data from an API and appending it to an Excel sheet. You can also create and organize sheet tabs, and navigate through entire projects full of workbooks. Formatting configurations and commands are also in progress.

## Usage

For Windows you have to run ```sheet_genie``` with either:
```sh
./sheet_genie
```
**or**
```sh
mix escript sheet_genie
```

**Create Project**:
```sh
sheet_genie new [NAME]
```
**Create a new Excel workbook**:
```sh
sheet_genie workbook new [NAME]
# or alternatively
sheet_genie wb new [NAME]
```

**List all workbooks**:
```sh
sheet_genie workbook list
# or alternatively
sheet_genie wb list
```
**Set active workbook**:
```sh
sheet_genie workbook open [NAME]
# or alternatively
sheet_genie wb select [NAME]
```
**Create a new worksheet tab**:
```sh
sheet_genie worksheet new [NAME]
# or alternatively
sheet_genie ws new [NAME]
```

**List all worksheets**:
```sh
sheet_genie workbook list
# or alternatively
sheet_genie wb list
```
**Set active worksheet tab**:
```sh
sheet_genie worksheet open [NAME]
# or alternatively
sheet_genie ws select [NAME]
```
### Adding data from an API 
**Create Schema**:  
This is your template for extracting items from the API. The NAME is the key you're trying to extract from the API and the TYPE is the datatype (i.e. string, number, text, etc.). You can add as many of these as you want.
```sh
sheet_genie schema new [NAME]:[TYPE] [NAME]:[TYPE]...
```
**Example:**
```sh
sheet_genie schema new title:string description:string id:number
```

**Add data to worksheet**:  
This will add append the API data based on the schema that is passed in. It will append it to the current worksheet selected inside of the current Excel workbook (.xlsx) selected.
```sh
sheet_genie append api [API_URL] [SCHEMA]
```

**Example**:  
```sh
sheet_genie append api http://localhost:4000/bug_reports my_schema
```

## Prerequisites

In order to run Elixir applications, you must first have Elixir and the Erlang VM installed on your machine. To do this, you must first have a package manager such as Homebrew (Mac), Chocolatey (Windows), or any Linux distro's package manager.

### macOS

1. **Install Homebrew**:
   - Open your Terminal and run the following command to install Homebrew:
     ```sh
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
     ```
     
2. **Install Erlang and Elixir**:
   - Once Homebrew is installed, run the following commands to install Erlang and Elixir:
     ```sh
     brew install erlang
     brew install elixir
     ```

### Windows

1. **Install Chocolatey**:
   - Open PowerShell as an Administrator and run the following command to install Chocolatey:
     ```powershell
     Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
     
     ```
2. **Install Erlang and Elixir**:
   - Once Chocolatey is installed, run the following commands to install Erlang and Elixir:
     ```powershell
     choco install erlang
     choco install elixir
     ```

### Linux

1. **Install Erlang and Elixir**:
   - Depending on your Linux distribution, follow the respective instructions below:

   **Ubuntu/Debian**:
   ```sh
    sudo apt update
    sudo apt install -y esl-erlang elixir
   ```

   **Fedora:**
   ```sh
    sudo dnf install -y erlang elixir
   ```

   **Arch Linux:**
   ```sh
    sudo pacman -S erlang elixir
   ```

## Installation

The program can be built and installed using the respective setup file for your operating system. 

```sh
# For macOS
./install_mac.sh

# For Linux
./install_linux.sh

# For Windows
install_windows.bat
```

If the setup doesn't run then try adding this before running the install script:
```sh
chmod +x install_mac.sh 
```


# License

**MIT License**

Copyright (c) 2024 RyanBlaney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
