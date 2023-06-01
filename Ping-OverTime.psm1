# Documentation home: https://github.com/engrit-illinois/Ping-OverTime
# By mseng3

function Ping-OverTime {

	param(
		[Parameter(Mandatory=$true)]
		[string]$ComputerName,
		
		[ValidateScript({($_ -eq "4") -or ($_ -eq "6") -or ($_ -eq "Default")})]
		[string]$IpVersion = "Default",
		
		[string]$LogDir = "c:\engrit\logs",
		
		[switch]$LogAll,
		
		[int]$TestDelay = 2,
		
		[int]$PingsPerTest = 1,
		
		[int]$MaxTests = -1
	)
	
	$ts = Get-Date -Format "yyyy-MM-dd_HH-mm-ss-ffff"
	$LOG = "$LogDir\Ping-OverTime_$ComputerName`_$ts.log"

	function log {
		param(
			[Parameter(Mandatory=$true,Position=0)]
			[string]$Msg,
			
			[switch]$NoFile
		)
		
		$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss:ffff"
		$line = "[$ts] $Msg"
		
		Write-Host $line
		
		if($LogAll -or (!$NoFile)) {
			if(!(Test-Path -PathType leaf -Path $LOG)) {
				$shutup = New-Item -ItemType File -Force -Path $LOG
			}
			$line | Out-File $LOG -Append
		}
	}

	function translate($state) {
		$translation = "down"
		if($state) {
			$translation = "up"
		}
		$translation
	}
	
	function Validate-Params {
		$ver = $Host.Version
		
		if($IpVersion -eq "Default") {
			return $true
		}
		else {
			log "-IpVersion parameter was specified, which requires PowerShell 7.2 or newer."
			log "    Powershell version is `"$($ver.Major).$($ver.Minor)`"."
			if(
				($ver.Major -ge 7) -and
				($ver.Minor -ge 2)
			) {
				return $true
			}
			else {
				return $false
			}
		}
	}

	function Do-Stuff {
		log "Pinging `"$ComputerName`" over time..."
		log "Logging to `"$LOG`"."
		log "-IpVersion: `"$IpVersion`", -LogAll: `"$LogAll`", -TestDelay: `"$TestDelay`", -PingsPerTest: `"$PingsPerTest`", -MaxTests: `"$MaxTests`""
		if(Validate-Params) {
			log " "
			for($i = 0; $i -ne $MaxTests; $i += 1) {
				$params = @{
					ComputerName = $ComputerName
					Count = $PingsPerTest
					Quiet = $true
				}
				if($IpVersion -eq "4") { $params.IPv4 = $true }
				if($IpVersion -eq "6") { $params.IPv6 = $true }
				$result = translate (Test-Connection @params)
				$msg = "Test #$i`: $result"
				if($result -ne $previous) {
					log $msg
				}
				else {
					log $msg -NoFile
				}
				$previous = $result
				Start-Sleep -Seconds $TestDelay
			}
			log " "
		}
	}

	Do-Stuff

	log "EOF"
}
