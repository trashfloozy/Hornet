$silksongSavePath = "$env:USERPROFILE\AppData\LocalLow\Team Cherry\Hollow Knight Silksong\"
$silksongBackupPath = "$env:USERPROFILE\Desktop\Steam Backup Save\"

$emergencySave = "$env:USERPROFILE\Desktop\Steam Backup Save\EMERGENCY\"

$silksongBackupedPath = "$env:USERPROFILE\Desktop\Steam Backup Save\Hollow Knight Silksong\"
$silksongRestorePath = "$env:USERPROFILE\AppData\LocalLow\Team Cherry\"

function CopyBackup {
  [CmdletBinding()]
  param ()
  process {
    if (!(Test-Path -Path $silksongBackupPath)) {
      New-Item -ItemType Directory -Path $silksongBackupPath > $null
    }
    
    Copy-Item -Path "$silksongSavePath" -Destination $silksongBackupPath -Recurse -Force
    Write-Host -Object '> Saved' -ForegroundColor 'Green'
  }
}

function emergencyBackup {
  [CmdletBinding()]
  param()
  process {
    if (!(Test-Path -Path $silksongSavePath)) {
      Write-Host -Object 'GAME DIRECTORY NOT DETECTED. ABORTED.' -ForegroundColor 'Red'
      Pause
      exit
    }


    if (!(Test-Path -Path $emergencySave)) {
      Write-Host -Object 'No emergency backup found. Create one now?' -ForegroundColor 'Red'
      $readUser = [System.Console]::ReadKey($true)
      $translateUser = $readUser.KeyChar
      $emergencyInput = $translateUser.ToString().ToLower()
      
      switch ($emergencyInput.ToLower()) {
        {($_ -eq "y") -or ($_ -eq "yes")} {
          Copy-Item -Path "$silksongSavePath" -Destination $emergencySave -Recurse -Force
          Write-Host -Object '> Saved Emergency Backup' -ForegroundColor 'Green'
          exit
        }
        {($_ -eq "n") -or ($_ -eq "no")} {
          exit
        }
        default {
          Write-Host -Object 'Unknown input.' -ForegroundColor 'Red'
          Pause
          exit
        }
      }
    }
    else {
      Write-Host -Object 'Update emergency backup? This CANNOT be undone! [Y/N]' -ForegroundColor 'Red'
      $readUser = [System.Console]::ReadKey($true)
      $translateUser = $readUser.KeyChar
      $emergencyInput = $translateUser.ToString().ToLower()

      switch ($emergencyInput.ToLower()) {
        {($_ -eq "y") -or ($_ -eq "yes")} {
          Copy-Item -Path "$silksongSavePath" -Destination $emergencySave -Recurse -Force
          Write-Host -Object '> Saved Emergency Backup' -ForegroundColor 'Green'
          exit
        }
        {($_ -eq "n") -or ($_ -eq "no")} {
          exit
        }
        default {
          Write-Host -Object 'Unknown input.' -ForegroundColor 'Red'
          Pause
          exit
        }
      }
    }
  }
}

function RestoreBackup {
  [CmdletBinding()]
  param ()
  process {
    if (!(Test-Path -Path $silksongBackupedPath)) {
      Write-Host -Object 'No backup directory found. Create a backup before proceeding!' -ForegroundColor 'Red'
      Pause
      exit
    }

    if (Test-Path -Path $silksongSavePath) {
      Remove-Item -Path $silksongSavePath -Recurse -Force
    }
      
    Copy-Item -Path "$silksongBackupedPath" -Destination $silksongRestorePath -Recurse -Force
    Write-Host -Object '> Restored' -ForegroundColor 'Green'
  }
}

function backupSecurity {
  if (!(Test-Path -Path $silksongSavePath)) {
    Write-Host -Object 'GAME DIRECTORY NOT DETECTED. SOMETHING IS WRONG. VERIFY GAME IS INSTALLED AND HAS AT LEAST ONE SAVE FILE.' -ForegroundColor 'Red'
    Pause
    exit
  }
}

function restoreSecurity {
  if (!(Test-Path -Path $silksongSavePath)) {
    Write-Host -Object 'GAME DIRECTORY NOT DETECTED. PROCEED WITH RESTORATION ANYWAY? [Y/N]' -ForegroundColor 'Red'
    $readUser = [System.Console]::ReadKey($true)
    $translateUser = $readUser.KeyChar
    $userInput = $translateUser.ToString().ToLower()

    switch ($userInput.ToLower()) {
      {($_ -eq "y") -or ($_ -eq "yes")} {
        Write-Host -Object 'Continuing...' -ForegroundColor 'Yellow'
        break
      }
      {($_ -eq "n") -or ($_ -eq "no")} {
        Write-Host -Object 'ABORTED!' -ForegroundColor 'Red'
        Pause
        exit
      }
      default {
        Write-Host -Object 'Unknown input.' -ForegroundColor 'Red'
        exit
      }
    }
  }
}

function emergencySecurity {
  if (!(Test-Path -Path $emergencySave)) {
    Write-Host -Object 'NO EMERGENCY SAVE DETECTED. CHECKING GAME DIRECTORY...' -ForegroundColor 'Red'
    
    if (!(Test-Path -Path $silksongSavePath)) {
      Write-Host -Object 'GAME SAVE NOT FOUND. BACKUP IS UNAVAILABLE.' -ForegroundColor 'Red'
      Pause
    } else {
      Copy-Item -Path "$silksongSavePath" -Destination "$emergencySave\Hollow Knight Silksong" -Recurse -Force
      Write-Host -Object '> Saved Emergency Backup' -ForegroundColor 'Green'
    }
  }
}


$Host.UI.RawUI.Flushinputbuffer()

Clear-Host
emergencySecurity

Write-Host -Object 'Do you want to backup or restore your saves? [B/R/E]' -ForegroundColor 'Yellow'
$readUser = [System.Console]::ReadKey($true)
$translateUser = $readUser.KeyChar
$backupInput = $translateUser.ToString().ToLower()

switch ($backupInput.ToLower()) {
  {($_ -eq "b") -or ($_ -eq "backup")} {
    backupSecurity
    CopyBackup
    exite
  }
  {($_ -eq "r") -or ($_ -eq "restore")} {
    restoreSecurity
    RestoreBackup
    exit
  }
  {($_ -eq "e") -or ($_ -eq "emergency")} {
    #emergencySecurity
    emergencyBackup
    exit
  }
  default {
    Write-Host -Object 'Unknown input.' -ForegroundColor 'Red'
    Pause
    exit
  }
}