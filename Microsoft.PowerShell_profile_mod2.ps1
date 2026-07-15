# CUSTOM THEME START ###############################################################################################################
# SCRIPT NAME:   Minimalist Git-Aware PowerShell Theme
# AUTHOR:        A FixedTerm
# LAST UPDATED:  2025-06-26
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

	# # --- 3. RENDER GIT ---
 #    # $gitOut = git status -b --porcelain 2>$null       # tracked & un-tracked files
	# $gitOut = git status -b --porcelain -uno 2>$null  # tracked files only
	
 #    # Check if we are inside a Git repository and got output
 #    if ($gitOut) {
 #        $lines = @($gitOut)
 #        $firstLine = $lines[0]
 #        $gitBranch = ""
		
 #        # Extract branch name from standard format
 #        if ($firstLine -match '^## (?:No commits yet on )?([^. ]+)') {
 #            $gitBranch = $Matches[1]
 #        # Extract detached HEAD state
 #        } elseif ($firstLine -match '^## HEAD \(no branch\)') {
 #            $gitBranch = "DETACHED"
 #        }
		
 #        # Proceed if a branch or state was successfully parsed
 #        if ($gitBranch) {
 #            # Check for dirty state by evaluating line count
 #            if ($lines.Count -gt 1) {
 #                Write-Host " $(Hex '#FFA500')[G] $gitBranch* $Reset" -NoNewline
 #            # Fallback for clean state
 #            } else {
 #                Write-Host " $(Hex '#57C7FF')[G] $gitBranch $Reset" -NoNewline
 #            }
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

# SEGGER ############################################################################################################################
$newPath = "C:\Program Files\SEGGER\JLink_V950"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")
# Append CODER to User PATH if missing
if ($oldPath -notmatch [regex]::Escape($newPath)) {
    [Environment]::SetEnvironmentVariable("Path", "$oldPath;$newPath", "User")
}

# CUSTOM THEME END #################################################################################################################


# USER ALIAS #######################################################################################################################

# @brief Manage Renesas device partitions.
function RenesasDevicePartition {
    param(
        [Parameter(Mandatory=$true, HelpMessage="Choose: ReadInfo / InitDevice / SetBounaries")]
        [ValidateSet("ReadInfo", "InitDevice", "SetBounaries")]
        [String]$Action,
        
        <# Default: 510 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | Code Secure (KB)")]
        [int]$CodeSecure = 510,

        <# Default: 2 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | Code non-secure callable (KB)")]
        [int]$CodeNSC = 2,

        <# Default: 6 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | Data Secure (KB)")]
        [int]$DataSecure = 6,
        
        <# Default: 319 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | SRAM Secure (KB)")]
        [int]$SRAMSecure = 319,
        
        <# Default: 1 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | SRAM non-secure callable (KB)")]
        [int]$SRAMNSC = 1,
        
        <# Default: 0 #>
        [Parameter(Mandatory=$false, HelpMessage="Memory partition sizes | SiP Flash Secure (KB)")]
        [int]$SiPFlashSecure = 0
    )
	
	$IntCodeSecure=$CodeSecure			#default: 510
	$IntCodeNSC=$CodeNSC				#default: 2
	$IntDataSecure=$DataSecure			#default: 6
	$IntSRAMSecure=$SRAMSecure			#default: 319
	$IntSRAMNSC=$SRAMNSC				#default: 1
	$IntSiPFlashSecure=$SiPFlashSecure	#default: 0

    $STR_OPTION_0 = "ReadInfo"
    $STR_OPTION_1 = "InitDevice"
    $STR_OPTION_2 = "SetBounaries"
	$OPTION_COUNT = 3
	$SELECTED_OPTION=$OPTION_COUNT
	$EXEC_PATH    = "$env:USERPROFILE\.eclipse\com.renesas.platform_1435879475\DebugComp\RA\DevicePartitionManager\RenesasDevicePartitionManagerCmd.exe"
    
	Write-Host "EXEC_PATH = $EXEC_PATH" -ForegroundColor Yellow
	
	if (-not (Test-Path -Path $EXEC_PATH)) {
		Write-Host "ERROR: Not found RenesasDevicePartitionManagerCmd.exe, please change the EXEC_PATH path in *.PS1 file!" -ForegroundColor Red
		exit 1
	}
	
    <# Handle ReadInfo action #>
    if ($Action -eq $STR_OPTION_0) {
		$SELECTED_OPTION = 0
        Write-Host "Executing ReadInfo..." -ForegroundColor Cyan
		& $EXEC_PATH -action STATUS -emuType jlink -bootInterface SWD -emuConn serial -supplyVoltage 0 -connBaudRate 9600 -dlmTargetState SSD
	}
    
    <# Handle InitDevice action #>
    if ($Action -eq $STR_OPTION_1) {
		$SELECTED_OPTION = 1
        Write-Host "Executing InitDevice..." -ForegroundColor Cyan
		& $EXEC_PATH -action INITIALIZE -emuType jlink -bootInterface SWD -emuConn serial -supplyVoltage 0 -connBaudRate 9600 -dlmTargetState SSD
    }
    
    <# Handle SetBounaries action #>
    if ($Action -eq $STR_OPTION_2) {
		$SELECTED_OPTION = 2
		Write-Host "Executing SetBounaries ..." 			-ForegroundColor Cyan
		Write-Host "Preset value:"                          -ForegroundColor Yellow
		Write-Host "      -CodeSecure     : $CodeSecure" 	-ForegroundColor Yellow
		Write-Host "      -CodeNSC        : $CodeNSC" 		-ForegroundColor Yellow
		Write-Host "      -DataSecure     : $DataSecure" 	-ForegroundColor Yellow
		Write-Host "      -SRAMSecure     : $SRAMSecure" 	-ForegroundColor Yellow
		Write-Host "      -SRAMNSC        : $SRAMNSC" 		-ForegroundColor Yellow
		Write-Host "      -SiPFlashSecure : $SiPFlashSecure" -ForegroundColor Yellow
		
		& $EXEC_PATH -action BOUNDARY -emuType jlink -bootInterface SWD -emuConn serial -supplyVoltage 0 -connBaudRate 9600 -dlmTargetState SSD -idauCFS $CodeSecure -idauCFNSC $CodeNSC -idauDFS $DataSecure -idauSRAMS $SRAMSecure -idauSRAMNSC $SRAMNSC -idauSFS $SiPFlashSecure
    }
}

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
    Copy-Item -Recurse -Force  $args
}

# /*
#  * Remove items recursively with force and verbose outputs (rm -vrf).
#  */
function rmrf {
    Remove-Item -Recurse -Force  $args
}
####################################################################################################################################
