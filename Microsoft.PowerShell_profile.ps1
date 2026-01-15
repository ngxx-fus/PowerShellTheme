# Enable the Progress Bar
$ProgressPreference = 'Continue'

# --- HELPER FUNCTION: Convert HEX to ANSI Color ---
# This function allows you to use Hex color codes (e.g., #FF00FF)
function Hex ($hex) {
    $hex = $hex.Trim('#')
    $r = [Convert]::ToByte($hex.Substring(0,2), 16)
    $g = [Convert]::ToByte($hex.Substring(2,2), 16)
    $b = [Convert]::ToByte($hex.Substring(4,2), 16)
    return "$([char]0x1b)[38;2;$r;$g;${b}m"
}

# Code to reset color to default
$Reset = "$([char]0x1b)[0m"

function prompt {
    $user = $env:USERNAME
    $path = $(Get-Location).Path

    # Shorten the home directory path to "~"
    if ($path.StartsWith($HOME)) {
        $path = $path.Replace($HOME, "~")
    }

    # Check for Administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # --- 1. RENDER USER ---
    # Color #45F1C2 (Turquoise from your old config)
    # If Admin, use Red (#FF5555)
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')[U] $user $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#45F1C2')[U] $user $Reset" -NoNewline
    }

    # Separator "@"
    # Write-Host " @ " -NoNewline -ForegroundColor White
    
    # --- 2. RENDER PATH ---
    # Color #0CA0D8 (Blue from your old config)
    Write-Host "$(Hex '#0CA0D8')[D]  $path $Reset" -NoNewline

    # --- 3. RENDER GIT ---
    $gitBranch = git branch --show-current 2>$null
    if ($gitBranch) {
        $gitStatus = git status --porcelain 2>$null
        if ($gitStatus) {
            # Dirty status: Orange (#FFA500)
            Write-Host " $(Hex '#FFA500')[G] $gitBranch* $Reset" -NoNewline
        } else {
            # Clean status: Light Blue (#57C7FF)
            Write-Host " $(Hex '#57C7FF')[G] $gitBranch $Reset" -NoNewline
        }
    }

    # Add a new line
    Write-Host "" 

    # --- 4. RENDER PROMPT SYMBOL (#) ---
    # If Admin: Red
    # If Standard User: Pink (#CD4277 - your signature color)
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')# $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#CD4277')# $Reset" -NoNewline
    }

    # Return a single space to finish the function
    return " "
}

# --- OPTIMIZED CONDA INIT (LAZY LOAD) ---
# Only loads Conda when you type 'conda', keeping startup fast (0ms)
$CondaExe = "C:\Users\PGU7HC\AppData\Local\miniconda3\Scripts\conda.exe"
if (Test-Path $CondaExe) {
    function conda {
        Write-Host "Initializing Conda... (Lazy Load)" -ForegroundColor DarkGray
        (& $CondaExe "shell.powershell" "hook") | Out-String | Invoke-Expression
        conda @args
    }
}