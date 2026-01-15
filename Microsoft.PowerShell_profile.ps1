# CUSTOM THEME START ###############################################################################################################
# SCRIPT NAME:   Minimalist Git-Aware PowerShell Theme
# AUTHOR:        A FixedTerm
# LAST UPDATED:  2025-01-16
#
# DESCRIPTION:
#   This script overrides the default PowerShell prompt to provide a cleaner, informative interface.
#   It displays:
#     1. User Mode: Green for Normal User, Red for Administrator.
#     2. Path: Current directory (shortens user home to '~').
#     3. Git Status: Shows current branch. Blue for clean, Orange for dirty (uncommitted changes).
#     4. Make long cmd more readable.
#
# WHY THIS SCRIPT:
#   - Lightweight: Pure PowerShell, no heavy modules (like Oh-My-Posh) required.
#   - Performance: Loads instantly without slowing down the terminal.
#   - Visual Safety: Clearly indicates if you are running as Administrator to prevent mistakes.
#
# IS IT SAFE:
#   Yes. It only redefines the 'prompt' function in the current memory session.
#   It does not modify system files, registry, or install external binaries.
#
# IS IT FREE:    Yes (Open Source).
# DEPENDENCIES:  Git for Windows (to display branch info). If Git is missing, errors are suppressed.
#
# INSTALLATION:  Copy and paste this block into your PowerShell Profile (`notepad $PROFILE`).
# UNINSTALL:     Remove this code block from your $PROFILE and restart PowerShell.
# ##################################################################################################################################

# Enable the Progress Bar
$ProgressPreference = 'Continue'

# --- HELPER FUNCTION: Convert HEX to ANSI Color ---
function Hex ($hex) {
    $hex = $hex.Trim('#')
    $r = [Convert]::ToByte($hex.Substring(0,2), 16)
    $g = [Convert]::ToByte($hex.Substring(2,2), 16)
    $b = [Convert]::ToByte($hex.Substring(4,2), 16)
    return "$([char]0x1b)[38;2;$r;$g;${b}m"
}

# Reset color code
$Reset = "$([char]0x1b)[0m"

function prompt {
    $user = $env:USERNAME
    $path = $(Get-Location).Path

    # Shorten home directory to "~"
    if ($path.StartsWith($HOME)) {
        $path = $path.Replace($HOME, "~")
    }

    # Check for Administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # --- 1. RENDER USER ---
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')[U] $user $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#45F1C2')[U] $user $Reset" -NoNewline
    }
    
    # --- 2. RENDER PATH ---
    Write-Host "$(Hex '#0CA0D8')[D]  $path $Reset" -NoNewline

    # --- 3. RENDER GIT ---
    $gitBranch = git branch --show-current 2>$null
    if ($gitBranch) {
        $gitStatus = git status --porcelain 2>$null
        if ($gitStatus) {
            # Dirty: Orange (#FFA500)
            Write-Host " $(Hex '#FFA500')[G] $gitBranch* $Reset" -NoNewline
        } else {
            # Clean: Light Blue (#57C7FF)
            Write-Host " $(Hex '#57C7FF')[G] $gitBranch $Reset" -NoNewline
        }
    }

    Write-Host "" 

    # --- 4. RENDER PROMPT SYMBOL ---
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')# $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#CD4277')# $Reset" -NoNewline
    }

    return " "
}


# --- OPTIMIZED CONDA INIT (LAZY LOAD) ---
# EDIT THIS PATH IF YOUR CONDA IS INSTALLED ELSEWHERE
$CondaExe = "$env:USERPROFILE\AppData\Local\miniconda3\Scripts\conda.exe"

if (Test-Path $CondaExe) {
    function conda {
        Write-Host "Initializing Conda... (Lazy Load)" -ForegroundColor DarkGray
        (& $CondaExe "shell.powershell" "hook") | Out-String | Invoke-Expression
        conda @args
    }
}

# CUSTOM THEME END #################################################################################################################