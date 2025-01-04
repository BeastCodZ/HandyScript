# Handyscript

This PowerShell script provides a simple way to quickly set up your machine by installing essential tools and applications. With just a few selections, you can automate the installation process and get your system ready in no time.

## How to use?

1. Open PowerShell with administrator privileges.
2. Run the script using the following command:
    ```powershell
    irm bit.ly/handyscript | iex
    ```

## Usage

The script will display a menu with a list of tasks. Toggle the switches by typing the number corresponding to each task and pressing Enter. Type `START` to execute the selected tasks together. Type `EXIT` to quit the script.

### Tasks

The script includes the following tasks:
1. **Install Brave**: Installs the Brave browser using winget.
2. **Install SpotX**: Installs SpotX using a script from the official repository.
3. **Install VSC & GitHub**: Installs Visual Studio Code and GitHub Desktop using winget.
4. **Activate Microsoft Windows 10/11**: Activates Windows using an online KMS activation script.
5. **Activate MS OFFICE**: Activates Microsoft Office using an online KMS activation script.

## Notes

Ensure you run the script as an administrator to allow it to perform installations and activations. The script will prompt you to press Enter to exit if it is not run with administrator privileges.
