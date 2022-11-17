# Summary

This script repeatedly pings a machine and logs when it starts and stops responding. It outputs the result of every single ping to the screen, but only logs to the log file when the current response differs from the previous response.  

Useful when running Win10 upgrades overnight, so you can get a rough idea of their progress, and when they rebooted.  

# Usage
1. Download `Ping-OverTime.psm1` to the appropriate subdirectory of your PowerShell [modules directory](https://github.com/engrit-illinois/how-to-install-a-custom-powershell-module).
2. Run it: `Ping-OverTime -ComputerName "computername"`

# Parameters

### -ComputerName
Mandatory string.  
The computername of the target computer.

### -LogDir
Optional string.  
The directory where the log should be written.  
Default is `c:\engrit\logs`.  
The log name will be `Ping-OverTime_<computername>_<start timestamp>.log`.  

### -LogAll
Optional switch.  
If specified, the results of all tests will be logged to the log file.  
If not specified, only the results of tests which differ from the previous result will be logged to the log file.  

### -TestDelay
Optional integer.  
The number of seconds to wait between tests.  
Default is `2`.  
Useful to prevent excess network traffic over long tests.  

### -PingsPerTest
Optional integer.  
The number pings to perform for each test.  
Default is `1`.  

### -MaxTests
Optional integer.  
Stop after this many tests.  
Default is `-1`, which means never stop.  
The script can simply be killed with `Ctrl+C`.  

# Example output
An example of the output when testing a machine that's being restarted.

### Console

```
mseng3@ENGRIT-MMS-RDP C:\>Import-Module .\Ping-OverTime.psm1
mseng3@ENGRIT-MMS-RDP C:\>Ping-OverTime -ComputerName "engrit-mms-tvm2"
[2020-06-02 11:11:34:3942] Pinging "engrit-mms-tvm2" over time...
[2020-06-02 11:11:34:3993] Logging to "c:\engrit\logs\Ping-OverTime_engrit-mms-tvm2_2020-06-02_11-11-34-3922.log".
[2020-06-02 11:11:34:4042] -LogAll False, -TestDelay 2, -PingsPerTest 1, -MaxTests -1
[2020-06-02 11:11:34:4095]
[2020-06-02 11:11:34:4325] Test #0: up
[2020-06-02 11:11:36:4511] Test #1: up
[2020-06-02 11:11:38:4711] Test #2: up
[2020-06-02 11:11:40:4877] Test #3: up
[2020-06-02 11:11:42:5052] Test #4: up
[2020-06-02 11:11:44:5226] Test #5: up
[2020-06-02 11:11:46:5391] Test #6: up
[2020-06-02 11:11:52:0818] Test #7: down
[2020-06-02 11:11:58:0801] Test #8: down
[2020-06-02 11:12:04:0793] Test #9: down
[2020-06-02 11:12:10:0802] Test #10: down
[2020-06-02 11:12:15:0799] Test #11: down
[2020-06-02 11:12:20:0810] Test #12: down
[2020-06-02 11:12:22:0991] Test #13: up
[2020-06-02 11:12:24:1184] Test #14: up
[2020-06-02 11:12:26:1344] Test #15: up
[2020-06-02 11:12:28:1541] Test #16: up
mseng3@ENGRIT-MMS-RDP C:\>
```

### Log file

```
[2020-06-02 11:11:34:3942] Pinging "engrit-mms-tvm2" over time...
[2020-06-02 11:11:34:3993] Logging to "c:\engrit\logs\Ping-OverTime_engrit-mms-tvm2_2020-06-02_11-11-34-3922.log".
[2020-06-02 11:11:34:4042] -LogAll: "False", -TestDelay: "2", -PingsPerTest: "1", -MaxTests: "-1"
[2020-06-02 11:11:34:4095]  
[2020-06-02 11:11:34:4325] Test #0: up
[2020-06-02 11:11:52:0818] Test #7: down
[2020-06-02 11:12:22:0991] Test #13: up
```

# Notes
- By mseng3. See my other projects here: https://github.com/mmseng/code-compendium.
