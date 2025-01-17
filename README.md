# GLStation SX1303 -  LoRaWAN Base Station
[GLStation SX1303 - LoRaWAN Base Station](./README.md) | [GLStation hardware](./INSTALL_HARDWARE.md) | [GLStation firmware](./INSTALL_FIRMWARE.md) | [GLStation Setup](./GLStation_SETUP.md) | [GLStation Mesh](./GLStation_MESH.md)

</BR>

This document is a short description of the hardware and software solutions of the GLStation SX1303 LoraWAN Base Station.

</BR>

<figure>
    <img src="pic/GLStation_pic.png" alt="GLStation"  width=400>
</figure>

</BR>

**GLStation SX1303** is a low-cost, low-power LoRaWAN base station unit with a Fine timestamping property. This unit can be used with [GLSensor tracker][8]  to resolve Lora sensor geolocation information. GLStation is a fully compatible with ChirpStack open-source LoRaWAN Network Server.

</BR>

Hardware 
- [Luckfox Pico Ultra W with POE][1] - ARM Cortex-A7 32-bit single-core low-cost micro Linux development board
- [LR1302 868M LoRaWAN hat][2] - An expansion board for SX1302 LoRa concentratord cards with integrated GPS module and RTC real-time clock.
- [HT1303-USB-863T870][3] - HT-1303 is a LoRa gateway module with industrial standard mini-PCI express form factor based on SX1303 + SX1250 chipset. USB interface.
- PoE 48V power adapter

Interfaces
- LoRaWAN
- Ethernet
- WLAN
- Bluetooth
- Serial console intarface

Software:
- Lightweight Alpine linux firmware for the GLStation SX1303
- [ChirpStack consentratord][4] - Customized for the GLStation SX1303 with Fine timestamp
- [ChirpStack MQTT Forwarder][5] - Customized for the GLStation SX1303
- [ChirpStack Gateway Mesh][7] - Integrated with the GLStation SX1303
- GPSd 
- Bluetooth GATT sever 

</BR>

GLStation receives and transmits data between LoRaWAN sensors and a LoRaWAN server. It is a similar component to a WLAN router that connects wireless WLAN devices to the LAN or internet.

<figure>
    <img src="pic/GLStation.svg" alt="GLStation"  width=1200>
</figure>

## GLStation - Ready to Mesh.

GLStation gateways enable large-scale network expansion with a multi-hop network architecture. 

- **Multi-hop Network Architecture:** Data can be transmitted through multiple nodes (devices) before reaching its final destination. Each node can relay data to the next node in the network.
- **Extended Communication Distance:** By using multiple nodes to relay data, the overall communication range of the network is increased. This is particularly useful in large-scale networks where direct communication between distant nodes might not be possible.
- **Improved Signal Penetration:** Multi-hop transmission helps in overcoming obstacles and improving signal strength. Since the data is relayed through multiple nodes, it can navigate around physical barriers more effectively.
- **Reduced Communication Pressure on Individual Nodes:** Instead of relying on a single node to handle all the communication, the load is distributed across multiple nodes. This reduces the strain on any one node and can lead to more efficient and reliable network performance.
- **Dynamic gateway role switching** GLStation can change the gateway role dynamically online between any following roles: 
    - ``Gateway`` | ``Gateway Border`` | ``Gateway Relay``

GLStation gateways create a robust and scalable network by leveraging multi-hop transmission. This approach enhances communication distance, signal penetration, and overall network efficiency.

<figure>
    <img src="pic\mesh_architecture.svg" alt="GLStation"  width=800>
</figure>

 Please refer to the [GLStation Mesh](./GLStation_MESH.md) documentation to learn more about the features provided.



</BR>

## Next step - Hardware installation 

[**GLStation hardware**](./INSTALL_HARDWARE.md) installation guide.

</BR>

</BR>

</BR>

<!--Reference material list-->
## Resources and reference material

* [Luckfox Pico Ultra W with PO][1] 
* [LR1302 868M LoRaWAN hat][2] 
* [Heltec HT1303 concentrator module][3] 
* [ChirpStack concentratord][4] 
* [ChirpStack MQTT Forwarder][5] 
* [ChirpStack open-source LoRaWAN Network Server][6] 
* [ChirpStack Gateway Mesh][7]
* [GLSensor tracker demo][8] 

[1]: <https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-RV1106/Luckfox-Pico-Ultra-W/Luckfox-Pico-quick-start> "Luckfox Pico Ultra W with POE" 
[2]: <https://www.elecrow.com/lr1302-868m-915m-lorawan-hat-for-rpi-sx1302-long-range-module-support-rpi-1-2-3-4-5-series.html> "LR1302 868M LoRaWAN hat" 
[3]: <https://resource.heltec.cn/download/HT-1303/HT-1303(Rev.1.2).pdf> "HT1303"
[4]: <https://github.com/chirpstack/chirpstack-concentratord> "ChirpStack consentratord"
[5]: <https://github.com/chirpstack/chirpstack-mqtt-forwarder> "ChirpStack MQTT Forwarder"
[6]: <https://www.chirpstack.io/docs/index.html> "ChirpStack open-source LoRaWAN Network Server"
[7]: <https://github.com/chirpstack/chirpstack-gateway-mesh> "ChirpStack Gateway Mesh"
[8]: <https://glsensor.glsolutions.fi/gls/e89a9f76-2455-44dd-b44b-c93fa8f0c54a?q=2025> "GLSensor tracker demo"

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





