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

# Reset color code
$Reset = "$([char]0x1b)[0m"

<#
/*
 * Convert HEX color to ANSI color sequence.
 * @param hex The hex color string.
 * @return The formatted ANSI escape sequence.
 */
#>
function Hex ($hex) {
    $hex = $hex.Trim('#')
    $r = [Convert]::ToByte($hex.Substring(0,2), 16)
    $g = [Convert]::ToByte($hex.Substring(2,2), 16)
    $b = [Convert]::ToByte($hex.Substring(4,2), 16)
    
    # Return ANSI escape sequence
    return "$([char]0x1b)[38;2;$r;$g;${b}m"
}

<#
/*
 * Custom prompt rendering function.
 * @return Empty space to end the prompt cleanly.
 */
#>
function prompt {
    $user = $env:USERNAME
    $path = $(Get-Location).Path

    # Shorten home directory to "~" for brevity
    if ($path.StartsWith($HOME)) {
        $path = $path.Replace($HOME, "~")
    }

    # Check for Administrator privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    # --- 1. RENDER USER ---
    # Apply red color if user is admin, else green
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')[U] $user $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#45F1C2')[U] $user $Reset" -NoNewline
    }
    
    # --- 2. RENDER PATH ---
    Write-Host "$(Hex '#0CA0D8')[D]  $path $Reset" -NoNewline

#    # --- 3. RENDER GIT ---
#    $gitBranch = git branch --show-current 2>$null
#    
#    # Display git info if currently in a repository
#    if ($gitBranch) {
#        $gitStatus = git status --porcelain 2>$null
#        
#        # Colorize branch name based on uncommitted changes
#        if ($gitStatus) {
#            # Dirty: Orange (#FFA500)
#            Write-Host " $(Hex '#FFA500')[G] $gitBranch* $Reset" -NoNewline
#        } else {
#            # Clean: Light Blue (#57C7FF)
#            Write-Host " $(Hex '#57C7FF')[G] $gitBranch $Reset" -NoNewline
#        }
#    }

    Write-Host "" 

    # --- 4. RENDER PROMPT SYMBOL ---
    # Render final prompt symbol based on admin status
    if ($isAdmin) {
        Write-Host "$(Hex '#FF5555')# $Reset" -NoNewline
    } else {
        Write-Host "$(Hex '#CD4277')# $Reset" -NoNewline
    }

    # Return standard spacing for prompt
    return " "
}

# GCC ###############################################################################################################################

$newPath = "C:\Users\phu.nguyen-thanh\gcc-10.3.0-tdm64-1-core\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Append GCC to User PATH if missing
if ($oldPath -notmatch [regex]::Escape($newPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$newPath", "User")
}

# NEOVIM ############################################################################################################################

$newPath = "C:\Users\phu.nguyen-thanh\nvim-win64\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Append NEOVIM to User PATH if missing
if ($oldPath -notmatch [regex]::Escape($newPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$newPath", "User")
}

# SCRCPY ############################################################################################################################

$newPath = "C:\Users\phu.nguyen-thanh\Documents\scrcpy-win64-v3.3.4"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Append SCRCPY to User PATH if missing
if ($oldPath -notmatch [regex]::Escape($newPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$newPath", "User")
}

# PYTHON ############################################################################################################################

$pythonScriptsPath = "C:\Users\phu.nguyen-thanh\AppData\Roaming\Python\Python313\Scripts"
if ($env:Path -notlike "*$pythonScriptsPath*") {
    $env:Path += ";$pythonScriptsPath"
}

# CODER #############################################################################################################################
$newPath = "C:\Users\phu.nguyen-thanh\Documents\UserApp\coder_2.34.3_windows_amd64"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
# Append CODER to User PATH if missing
if ($oldPath -notmatch [regex]::Escape($newPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$newPath", "User")
}

# CUSTOM THEME END #################################################################################################################


# USER ALIAS #######################################################################################################################

# /*
#  * Search text in strings and files.
#  */
function grep {
    $input | Select-String $args
}

# /*
#  * List all files, including hidden, sorted by time descending.
#  */
function ll {
    Get-ChildItem -Force $args | Sort-Object LastWriteTime -Descending
}

# /*
#  * Copy items recursively with force and verbose outputs (cp -vrf).
#  */
function cprf {
    Copy-Item -Recurse -Force -Verbose $args
}

# /*
#  * Remove items recursively with force and verbose outputs (rm -vrf).
#  */
function rmrf {
    Remove-Item -Recurse -Force -Verbose $args
}
####################################################################################################################################