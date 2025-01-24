$subnet = "192.168.1"  # Replace with your subnet
$port = 2210
$timeout = 100  # Timeout in milliseconds

Write-Output "Start scanning GLStations $subnet...255"

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

# Wait for input. 
Write-Host "Press any key to to exit."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null 