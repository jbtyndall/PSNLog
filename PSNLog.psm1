param (
    [string]$LogDirectory = (Get-Location).Path
)

# Ensure the log directory ends with a backslash
if (-not $LogDirectory.EndsWith("\")) {
    $LogDirectory += "\"
}

# Get the current directory
$currentDirectory = Get-Location

# Find NLog.dll in the current directory
$nLogPath = Join-Path -Path $currentDirectory -ChildPath "NLog.dll"

# Check if NLog.dll exists in the current directory
if (Test-Path -Path $nLogPath) {
    # Import the NLog assembly
    Add-Type -Path $nLogPath
} else {
    throw "NLog.dll not found in the current directory: $currentDirectory"
}

# Load NLog configuration from NLog.config
$nLogConfigPath = Join-Path -Path $currentDirectory -ChildPath "NLog.config"

if (Test-Path -Path $nLogConfigPath) {
    $config = [NLog.Config.XmlLoggingConfiguration]::new($nLogConfigPath)
} else {
    throw "NLog.config not found in the current directory: $currentDirectory"
}

# Update the log file target with the specified log directory
$fileTarget = $config.FindTargetByName("file")
$fileTarget.FileName = [NLog.Layouts.SimpleLayout]::new("${LogDirectory}`${shortdate}.log")

# Apply the updated configuration
[NLog.LogManager]::Configuration = $config

# Initialize the logger
$logger = [NLog.LogManager]::GetCurrentClassLogger()

# Export the logger for direct use
Export-ModuleMember -Variable logger