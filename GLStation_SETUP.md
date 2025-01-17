# GLStation SX1303 - Setup guide
[GLStation SX1303 - LoRaWAN Base Station](./README.md) | [GLStation hardware](./INSTALL_HARDWARE.md) | [GLStation firmware](./INSTALL_FIRMWARE.md) | [GLStation Setup](./GLStation_SETUP.md) | [GLStation Mesh](./GLStation_MESH.md)

</BR>

This document is a description how to set up the GLStation.

**Chapter covers the following topics:**
- Change password of the ``glsbase`` user
- Host name
- Network configurations
- Open-RC services on GLStation
- Time zone settings
- ntpd setup
- Crontab schedules
- Bluetooth GATT service
- SSH config
- cleaning logs
- gpsd setup
- ChirpStack concentratord
- ChirpStack mqtt forwarder
- Service Dependencies: gpsd <- gls-concentratord <- gls-mqtt-forwarder
- Gateway id
- tools

</BR>

GLStation runs on ``Alpine linux``, so now on is assumed that all commands will be done on a Linux terminal. GLStation has the ``sudo`` security system that enables users to run programs with the security privileges. Admin command should have ``sudo`` prefix to run command as the root user. For example stop gls-mqtt-forwarder service on the system.

</BR>

## ``TL;DR`` Minimum setup of the gateway 
This is minimum task list what has to do to get system up. system will usethe DHCP addresses.     

```
# -- Change password
$ sudo passwd glsbase

# -- Set host
$ sudo nano /etc/hosts
$ sudo nano /etc/hostname
$ sudo hostname -F /etc/hostname

# -- Set WLAN ssid and password
$ sudo sh -c 'wpa_passphrase "GLStationWiFi" "dontTellMama" > /etc/wpa_supplicant/wpa_supplicant.conf'

# -- Check
$ sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

# -- Restart WLAN
$ sudo rc-service wpa_supplicant restart

# -- Check
$ dmesg

# -- Set MQTT host for Gateway and Border Gateway modes
$ sudo nano /etc/conf.d/gls-mqtt-forwarder
$ sudo nano /etc/conf.d/gls-mqtt-forwarder-border-gw

# -- Restart gateway services
#   -g      Gateway mode
#   -b      Border Gateway mode
#   -r      Relay Gateway Mode

$ sudo ./set_gateway_mode.sh -g

# -- Check Gateway logs (quit: ctrl + c)
$ tail -f /var/log/*

# -- Test Reboot of the gateway
$ sudo reboot now
```
After that fast setup it also good to set at least the time zone and the ntp servers.

</BR>

##  Change password of the ``glsbase`` user

Connect GLStation using by SSH terminal. The [GLStation firmware](./INSTALL_FIRMWARE.md) installation guide contains instructions for connecting the GLStation.

``Windows terminal`` ``Linux terminal``

```
$ ssh -p2210 glsbase@[host IP address]
```



Change user glsbase password. Initial username and password:
<ul>
    <li><b>Username:</b> glsbase </li>
    <li><b>Password:</b> change-th1s-n0w!</li>
</ul> 

```
$ sudo passwd glsbase
```
glsbase is the only user that can connect GLStation. Root user can't connect the system.

</BR>


##  Host name

GLStation has a default host name ``station-000``. It may make sense to change the hostname if you plan to install more than one GLStation gateway on the LoRaWAN network. For example, rename station as following sequence: ``station-001, station-002, station-003...``

Replace "station-000" with "station-001" in ``nano`` editor.

```
$ sudo nano /etc/hosts
```
```
127.0.0.1       localhost station-001

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback ip6-station-001
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Set the host name.
```
$ sudo nano /etc/hostname
```
```
station-001
```

Set host name for the current session.
```
$ sudo hostname -F /etc/hostname
```

The hostname will take effect after the next boot.

</BR>

##  Network configurations

Network interfaces are configured in ``/etc/network/interfaces`` file. GLStation have both network interfaces ``eth0`` and ``wlan`` on by default. You can inspect the network interface using ``ip`` command.

```
$ ip a
```

Edit network configuration.

```
$ sudo nano /etc/network/interfaces
```
```
auto lo
auto eth0
auto wlan0

# static address example
#iface eth0 inet static
#address 192.168.50.59
#netmask 255.255.255.0
#gateway 192.168.50.1

# Static MAC address
iface eth0 inet dhcp
    pre-up ip link set eth0 address 36:26:cf:57:e1:03
iface wlan0 inet dhcp
iface wlan0 inet dhcp
```
> **Note:** </BR> The MAC address is a predefined setting and does not require any user action.
The eth0 interface has a generated locally administered unicast MAC addresss (Luckfox Pico has a dynamic MAC address on eth0 by default). MAC address is set on the first boot after flashing the firmware. A locally administered unicast MAC address is generated for eth0 interface by using code below:
>```
> printf '%02x' $((0x$(od /dev/urandom -N1 -t x1 -An | cut -c 2-) & 0xFE | 0x02)); od /dev/urandom -N5 -t x1 -An | sed 's/ /:/g'
>```
> This generated MAC address on eth0 interface should be unique MAC address on the local network.


More information about MAC address:
* [How to generate random MAC][3]
* [Generate a random MAC address from the Linux command line][4] 

</BR>

The name server configuration should be set in ``/etc/resolv.conf`` file if static Ethernet address will be set on to GLStation.

```
$ sudo nano /etc/resolv.conf
```
```
nameserver 192.168.1.1
```

> **Please,** </BR> see the more information on the [Alpine - Configure Networking][5] guide.

</BR>

WLAN password setting is in the ``/etc/wpa_supplicant/wpa_supplicant.conf`` file. Salted password setup can be done using the command below.

```
$ sudo sh -c 'wpa_passphrase "GLStationWiFi" "dontTellMama" > /etc/wpa_supplicant/wpa_supplicant.conf'
```

```
$ sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
```
```
network={
        ssid="GLStationWiFi"
        #psk="dontTellMama"
        psk=b751b793c61bcce458375d4ea699f2ebce875536a893d5ca7dc7039b2dacf275
        # https://wiki.alpinelinux.org/wiki/Wi-Fi#wpa_supplicant
        # Salted password can be generated as:
        # wpa_passphrase 'ExampleWifiSSID' 'ExampleWifiPassword' > /etc/wpa_supplicant/wpa_supplicant.conf
}
```
Remove the clear text password ``#psk="dontTellMama"`` line from /etc/wpa_supplicant/wpa_supplicant.conf if your router accepts salted password.

Restart wpa_supplicant service.
```
$ sudo rc-service wpa_supplicant restart

# Option, check dmesg messages
$ dmesg
```

> **Please,** </BR> see the more details about WLAN on the [Alpine - wpa_supplicant][6] guide.

</BR>

##  Open-RC services on GLStation

GLStation has following pre-defined main services running. All services should be in ``Started`` state when system runs normally.

```
$ rc-status
```
```
Runlevel: default
 sshd                                                                       [  started  ]
 swap                                                                       [  started  ]
 gpsd                                                                       [  started  ]
 udev-postmount                                                             [  started  ]
 bluetooth                                                                  [  started  ]
 local                                                                      [  started  ]
 gls-concentratord                                                          [  started  ]
 gls-bluetooth                                                              [  started  ]
 gls-bt-gatt                                                                [  started  ]
 crond                                                                      [  started  ]
 gls-mqtt-forwarder                                                         [  started  ]
Dynamic Runlevel: hotplugged
Dynamic Runlevel: needed/wanted
 modules                                                                    [  started  ]
 fsck                                                                       [  started  ]
 root                                                                       [  started  ]
 localmount                                                                 [  started  ]
 dbus                                                                       [  started  ]
 loopback                                                                   [  started  ]
 hostname                                                                   [  started  ]
Dynamic Runlevel: manual

```

Learn more about service management: 
* [Alpine - Working with OpenRC][7]
* [OpenRC][8]

</BR>

##  Time zone settings

Time zone example, change default timezone from "Europe/Helsinki" to "Europe/Stockholm"

```
# Set timezone manually

sudo apk add tzdata
sudo cp /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
sudo sh -c 'echo "Europe/Stockholm" > /etc/timezone'
sudo apk del tzdata
sudo rm -rf /var/cache/apk/*
```
Check timezone and date.
```
$ date
```
</BR>

##  ntpd time server setup

The system gets the correct time from network. Change ntp server list in ``/etc/ntp.conf`` file depending on the gateway location. 

```
sudo nano /etc/ntp.conf
```
```
server time1.mikes.fi 
server time2.mikes.fi
server 0.fi.pool.ntp.org
server 1.fi.pool.ntp.org
server 2.fi.pool.ntp.org
server 3.fi.pool.ntp.org 
server europe.pool.ntp.org
```

</BR>

##  Crontab schedules

List the crontab schedules.

```
sudo crontab -l
```
```
# do daily/weekly/monthly maintenance
# min   hour    day     month   weekday command
*/15    *       *       *       *       run-parts /etc/periodic/15min
0       *       *       *       *       run-parts /etc/periodic/hourly
0       2       *       *       *       run-parts /etc/periodic/daily
0       3       *       *       6       run-parts /etc/periodic/weekly
0       5       1       *       *       run-parts /etc/periodic/monthly
0       */6     *       *       *       ntpd -q  2>&1
20      4       *       *       0       reboot now  2>&1
```

</BR>

Edit crontab schedules.
```
sudo EDITOR=nano crontab -e
```


</BR>

## Bluetooth GATT service

GLStation GATT server has following the customized service and characteristics attributes.

- Service ``19a6eeef-ca99-47b8-91c3-0ae55fa7793b``
- Characteristic ``7fd68423-c170-4342-97ef-3714a8136f03``

Characteristic key ``7fd68423-c170-4342-97ef-3714a8136f03`` has a four byte network address information.

GATT server status can be checked by using command.

```
$ bluetoothctl show
``` 

Service start / stop commands.

```
sudo rc-service gls-bt-gatt stop
sudo rc-service gls-bt-gatt start
```

</BR>

## SSH config

SSH server setting is in  ``/etc/ssh/sshd_config`` file.

```
$ sudo nano /etc/ssh/sshd_config
```

Service start / stop commands.

```
sudo rc-service sshd stop
sudo rc-service sshd start
```

Learn more from [Alpine - SSH server][9]


</BR>

## Cleaning logs

GLStation truncates the following logs every hour. Maximum log size is set to 10 MB.
- /var/log/gls-mqtt-forwarder.log
- /var/log/gls-concentratord.log
- /var/log/gls-bt-gatt.log
- /var/log/gls-gateway-mesh.log

The Crontab log cleaning scrip is in ``/etc/periodic/hourly`` folder.

</BR>

## GPSd setup

GPSd is running as a service process. Configuration file is ``/etc/conf.d/gpsd``

```
$sudo nano /etc/conf.d/gpsd
```
Service start / stop commands.

```
sudo rc-service gpsd stop
sudo rc-service gpsd start
```

</BR>

## gls-concentratord

Configuration file  is ``/etc/opt/gls/sx1303.toml``

```
$ sudo nano /etc/opt/gls/sx1303.toml
```

Binary file location: ``/usr/local/bin/chirpstack-concentratord-sx1302``

Service start / stop commands.

```
sudo rc-service gls-concentratord stop
sudo rc-service gls-concentratord start
```

</BR>

## gls-mqtt-forwarder

MQTT server (e.g. scheme://host:port where scheme is tcp, ssl or ws) address is defined in the files above.
-  ``/etc/conf.d/gls-mqtt-forwarder``
- ``/etc/conf.d/gls-mqtt-forwarder-border-gw``

</BR>

```
$ sudo nano /etc/conf.d/gls-mqtt-forwarder
$ sudo nano /etc/conf.d/gls-mqtt-forwarder-border-gw
```
For example:
```
MQTT_SCHEME_HOST_PORT="tcp://192.168.1.200:1883"
```
Restart gls-mqtt-forwarder.
```
$ sudo rc-service gls-mqtt-forwarder restart
```

Other mqtt-forwarder settings can be updated to the into
``/etc/opt/gls/chirpstack-mqtt-forwarder.toml`` configuration file

```
$ sudo nano /etc/opt/gls/chirpstack-mqtt-forwarder.toml
```

Binary file location: ``/usr/local/bin/chirpstack-mqtt-forwarder``

Service start / stop commands.

```
sudo rc-service gls-mqtt-forwarder stop
sudo rc-service gls-mqtt-forwarder start
```

</BR>

## Service Dependencies: gpsd <- gls-concentratord <- gls-mqtt-forwarder

Gpsd, gls-concentratord, gls-mqtt-forwarder services are dependent on each other. For example, if the gpsd service is stopped, all dependent services will also stop. This means that stopping the gpsd service will also stop the gls-concentratord and gls-mqtt-forwarder service.

And vice versa if the mqtt-forwarder service starts, the gpsd and concentrator services should start. 

</BR>

##  Gateway id

Run the following command to get HT1303 card ``gateway id`` 

```
$ sudo /usr/local/bin/gateway-id
```

</BR>

## Tools and helppers

Monitor gls-concentartord, gls-mqtt-forwarder, gls-bt-gatt logs.
```
$ tail -f /var/log/*
```

Htop - an interactive process viewer

```
$ htop
```

Iftop - display bandwidth usage on an interface

```
$ iftop
```

Service statuses, start and stop.

```
$ rc-status
$ sudo rc-service [service name] start | stop
```

Get gateway id

```
$ sudo /usr/local/bin/gateway-id
```

The btmon command provides access to the Bluetooth subsystem monitor infrastructure for reading HCI traces.
```
$ sudo btmon -i hci0
```

</BR>

## Next step - GLStation goes Mesh
[**GLStation Mesh**](./GLStation_MESH.md)

</BR>

</BR>

</BR>

<!--Reference material list-->
## Resources and reference material

* [GitHub - LuckfoxTECH/luckfox-pico][1] 
* [Luckfox Wiki][2] 
* [How to generatr random MAC][3]
* [Generate a random MAC address from the Linux command line][4] 
* [Alpine - Configure Networking][5]
* [Alpine - wpa_supplicant][6]
* [Alppine - Working with OpenRC][7]
* [OpenRC][8]
* [Alpine - SSH server][9]

[1]: <https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-RV1106/Luckfox-Pico-Ultra-W/Luckfox-Pico-quick-start> "GitHub - LuckfoxTECH/luckfox-pico" 
[2]: <https://wiki.luckfox.com/intro> "Luckfox Wiki" 

[3]: <https://en.wikipedia.org/wiki/MAC_address> "How to generatr random MAC"
[4]: <https://serverfault.com/questions/299556/how-to-generate-a-random-mac-address-from-the-linux-command-line> "Generate a random MAC address from the Linux command line"
[5]: <https://wiki.alpinelinux.org/wiki/Configure_Networking> "Alpine - Configure Networking"
[6]: <https://wiki.alpinelinux.org/wiki/Wi-Fi#wpa_supplicant> "Alpine - wpa_supplicant"
[7]: <https://docs.alpinelinux.org/user-handbook/0.1a/Working/openrc.html> "Alpine - Working with OpenRC"
[8]: <https://wiki.gentoo.org/wiki/OpenRC#Automatic_respawning_crashed_services> "OpenRC"
[9]: <https://wiki.alpinelinux.org/wiki/Setting_up_a_SSH_server?ref=angelsanchez.me> "Alpine - SSH server"

</BR>

## GLStation guides
- [GLStation SX1303 - LoRaWAN Base Station](./README.md) guide.
- [GLStation firmware](./INSTALL_FIRMWARE.md) installation guide.
- [GLStation Setup](./GLStation_SETUP.md) guide.
- [GLStation Mesh](./GLStation_MESH.md)

</BR>
</BR>
</BR>

**Let's do IoT better**
