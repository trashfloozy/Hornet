if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "Restarting in PowerShell 7..."
    $pwsh = "pwsh.exe"   # path to PowerShell 7
    & $pwsh -File $PSCommandPath @args
    exit
}

Clear-Host
Install-Module Microsoft.PowerShell.ConsoleGuiTools
$choices = @("Hornet", "Hollow Knight", "Exit")

$userInput = $choices | Out-ConsoleGridView -Title "Select your game and press enter!" -OutputMode Single

switch ($userInput) {
    "Silksong" {
        Invoke-WebRequest -useb https://raw.githubusercontent.com/trashfloozy/Hornet/refs/heads/main/Scripts/Silksong.ps1 | Invoke-Expression
        Pause
    }
    "Hollow Knight" {
        Invoke-WebRequest -useb https://raw.githubusercontent.com/trashfloozy/Hornet/refs/heads/main/Scripts/Hollow%20Knight.ps1 | Invoke-Expression
        Pause
    }
    "Exit" {
        Write-Host -Object "Exiting..."
        Pause
        exit
    }
    default {
        Write-Host -Object "Unknown answer." -ForegroundColor Red
        Pause
    }
    Pause
}


