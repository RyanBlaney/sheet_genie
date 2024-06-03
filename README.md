# SheetGenie

SheetGenie is a command line script that automates the process of collecting data from an API and appending it to an Excel sheet. You can also create and organize sheet tabs, and navigate through entire projects full of workbooks. Formatting configurations and commands are also in progress.

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

   **Fedora:**:
   ```sh
    sudo dnf install -y erlang elixir
   ```

   **Arch Linux:**:
   ```sh
    sudo pacman -S erlang elixir
   ```

## Installation

The program can be built and installed using the respective setup file for your operating system. 

```sh
# For macOS
chmod +x install_mac.sh 
./install_mac.sh

# For Linux
chmod +x install_linux.sh
./install_linux.sh

# For Windows
install_windows.bat
```

If the setup doesn't run then try adding this before running the install script:
```sh
chmod +x install_mac.sh 
```
