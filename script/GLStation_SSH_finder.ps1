
Write-Output "Find GLStations in the local network. "
Write-Output "Start mDNS lookup for range: station-000...010"
Write-Output ""

$name_prefix = "station-"
# Iterate through each name and perform a DNS resolution
for ($i = 0; $i -le 10; $i++) {    
   
    $station_number = $i.ToString('000')
    $name = "$name_prefix$station_number.local"

    try {
        $result = Resolve-DnsName -Name $name -ErrorAction Stop
        Write-Output "Name: $name - IP address: $($result.IPAddress)"
    } catch {
        Write-Output "Name: $name - Not found"
    }
}

$subnet = "192.168.1"  # Replace with your subnet
$port = 2210
$timeout = 100  # Timeout in milliseconds

Write-Output ""
Write-Output "Start scanning IP range: $subnet...255"
Write-Output ""

for ($i = 1; $i -le 255; $i++) {
    $ip = "$subnet.$i"
    $socket = New-Object System.Net.Sockets.TcpClient
    $connect = $socket.BeginConnect($ip, $port, $null, $null)
    $result = $connect.AsyncWaitHandle.WaitOne($timeout, $false)
    if ($result -and $socket.Connected) {
        Write-Output "$ip found."
    }
    $socket.Close()
}

Write-Host ("")
Write-Host ("It's the final countdown. Press any key to exit.")
Write-Host ("")

$secondsRunning = 0;
$wait = 30
while( (-not $Host.UI.RawUI.KeyAvailable) -and ($secondsRunning -lt $wait+1) ){
    Write-Host -NoNewline ("The final count down: " + ($wait-$secondsRunning) + "  " + "`r")
    Start-Sleep -Seconds 1
    $secondsRunning++
}
Write-Host ("")
Write-Host -NoNewline ("We're leaving together, but still, it's farewell.")
sleep 2
Write-Host (" Exit.")
sleep 3
