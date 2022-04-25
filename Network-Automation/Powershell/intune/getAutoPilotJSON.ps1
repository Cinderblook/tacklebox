# Install required modules to configure Intune
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module AzureAD -Force
Install-Module WindowsAutopilotIntune -Force
Install-Module Microsoft.Graph.Intune -Force

# Connect to Intune Administrative - with Domain Admin account
Connect-MSGraph

# Next, retrieve pfoile from autopiloet for existing
Get-AutopilotProfile | ConvertTo-AutopilotConfigurationJSON

# JSON File will look similar to this
# {
#    "CloudAssignedTenantId": "1537de22-988c-4e93-b8a5-83890f34a69b",
#    "CloudAssignedForcedEnrollment": 1,
#    "Version": 2049,
#    "Comment_File": "Profile Autopilot Profile",
#    "CloudAssignedAadServerData": "{\"ZeroTouchConfig\":{\"CloudAssignedTenantUpn\":\"\",\"ForcedEnrollment\":1,\"CloudAssignedTenantDomain\":\"M365x373186.onmicrosoft.com\"}}",
#    "CloudAssignedTenantDomain": "M365x373186.onmicrosoft.com",
#    "CloudAssignedDomainJoinMethod": 0,
#    "CloudAssignedOobeConfig": 28,
#    "ZtdCorrelationId": "7F9E6025-1E13-45F3-BF82-A3E8C5B59EAC"
#}

# Get-AutopilotProfile | ConvertTo-AutopilotConfigurationJSON | Out-File c:\Autopilot\AutopilotConfigurationFile.json -Encoding ASCII