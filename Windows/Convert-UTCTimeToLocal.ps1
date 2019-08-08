function Convert-UTCtoLocal

{
param(
[parameter(Mandatory=$true)]
[String] $UTCTime
)

$strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName
$TZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone)
$LocalTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)
}

Convert-UTCtoLocal

# https://devblogs.microsoft.com/scripting/powertip-convert-from-utc-to-my-local-time-zone/