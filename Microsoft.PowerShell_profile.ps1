# Enable the Progress Bar (Loading bar for long operations)
$ProgressPreference = 'Continue'

function prompt {
    $user = $env:USERNAME
    $path = $(Get-Location).Path

    # Shorten the home directory path to "~"
    if ($path.StartsWith($HOME)) {
        $path = $path.Replace($HOME, "~")
    }

    # Check for Administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # --- RENDER PROMPT ---
    
    # Logic: Admin -> [r] Red | Standard User -> [u] Green
    if ($isAdmin) {
        Write-Host "[r] $user " -NoNewline -ForegroundColor Red 
    } else {
        Write-Host "[u] $user " -NoNewline -ForegroundColor Green 
    }

    Write-Host "on " -NoNewline -ForegroundColor White
    
    Write-Host "[d] $path " -ForegroundColor Cyan 

    # Prompt symbol: Admin -> Red | Standard User -> Magenta
    if ($isAdmin) {
        Write-Host "# " -NoNewline -ForegroundColor Red
    } else {
        Write-Host "# " -NoNewline -ForegroundColor Magenta
    }

    # Return a single space to finish the function
    return " "
}

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\PGU7HC\AppData\Local\miniconda3\Scripts\conda.exe") {
    (& "C:\Users\PGU7HC\AppData\Local\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

