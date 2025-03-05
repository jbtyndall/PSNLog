# Define the log directory
$logDirectory = "C:\Users\jbtyndall\Desktop\PSNLog"

# Import the module with the log directory parameter
Import-Module ".\PSNLog.psm1" -ArgumentList $logDirectory

# Log a message
$logger.Info("Hello world!")