# Documentation home: https://github.com/engrit-illinois/Ping-OverTime
# By mseng3

function Ping-OverTime {

	param(
		[Parameter(Mandatory=$true)]
		[string]$ComputerName,
		
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

	function Do-Stuff {
		log "Pinging `"$ComputerName`" over time..."
		log "Logging to `"$LOG`"."
		log "-LogAll $LogAll, -TestDelay $TestDelay, -PingsPerTest $PingsPerTest, -MaxTests $MaxTests"
		log " "
		
		for($i = 0; $i -ne $MaxTests; $i += 1) {
			$result = translate (Test-Connection -ComputerName $ComputerName -Count $PingsPerTest -Quiet)
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
	}

	Do-Stuff

	log " "
	log "EOF"
}
