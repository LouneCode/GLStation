# GLStation SX1303 -  LoRaWAN Base Station
[GLStation SX1303 - LoRaWAN Base Station](./README.md) | [GLStation firmware](./INSTALL_FIRMWARE.md) | [GLStation Setup](./GLStation_SETUP.md)

</BR>

This document is a short description of the hardware and software solutions of the GLStation SX1303 LoraWAN Base Station.

**GLStation SX1303** is a low-cost, high performance LoRaWAN base station unit with a Fine timestamping property. This unit can be used with [GLSensor tracker][7]  to resolve Lora sensor geolocation information. GLStation is a fully compatible with [ChirpStack open-source LoRaWAN Network Server][6].

</BR>

<figure>
    <img src="pic/GLStation_pic.png" alt="GLStation"  width=300>
</figure>

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
- GPSd 
- Bluetooth GATT sever 

</BR>

![Consertrator container](pic/GLStation.svg)

GLStation receives and transmits data between LoRaWAN sensors and a LoRaWAN server. It is a similar component to a WLAN router that connects wireless WLAN devices to the LAN or internet.

</BR>

## Hardware installation
- LR1302 868M LoRaWAN hat
- HT1303-USB-863T870
- Luckfox Pico Ultra W
- PoE power adapter
- GLStation adapter


</BR>

### HT1303 module and LR1302 868M LoRaWAN hat

</BR>

Start installation with the ``HT1303 concentrator module`` and the ``LR1302 868M LoRaWAN hat``. HT1303 concentrator module is installed in a mini-PCI socket on the LR1302 868M LoRaWAN hat. Attach the LoRa and GPS antennas to the correct SMA connectors. 

</BR>

<figure>
    <img src="https://www.elecrow.com/media/wysiwyg/products/2023/CRT01265M/LoRaWAN-HAT-for-RPI_05.jpg" alt="LR1302 868M LoRaWAN hat"  width="600">
    <!--figcaption><a href="https://www.elecrow.com/lr1302-868m-915m-lorawan-hat-for-rpi-sx1302-long-range-module-support-rpi-1-2-3-4-5-series.html" target="_blank">LR1302 868M LoRaWAN hat</a></figcaption-->
</figure>

</BR>

**LR1302 868M LoRaWAN hat Pin Definitions**

<figure>
    <img src="https://www.elecrow.com/wiki/image/thumb/a/ad/LR1302_LoRaWAN_HAT-1.png/600px-LR1302_LoRaWAN_HAT-1.png" alt="LR1302 868M LoRaWAN hat"  width="600">
    <figcaption>Please, see more details in <a href="https://heltec.org/project/ht1303/" target="_blank">LR1302 868M LoRaWAN hat</a></figcaption>
</figure>

</BR>

<figure>
    <img src="https://resource.heltec.cn/download/HT-1303/HT-1303.png" alt="HT1303"  width="600">
    <figcaption><a href="https://heltec.org/project/ht1303/" target="_blank">Heltec HT1303</a></figcaption>
</figure>

</BR>

<figure>
    <img src="pic/HT1303_reference_design.png" alt="T1303 reference desing"  width="600">
    <figcaption><a href="https://resource.heltec.cn/download/HT-1303/HT-1303_Reference_Design.pdf" target="_blank">HT1303 reference desing</a></figcaption>
</figure>

Please, see more details in [Heltec HT1303 concentrator module][3] 

</BR>

Insert short IPEX Cable to U.FL interface of the Hat and other end to ``RFIO`` connector on the Heltec HT1303 concentrator module.

<figure>
    <img src="pic/IPEX_cable.png" alt="IPEX cable">
    <figcaption><a href="https://heltec.org/project/ht1303/" target="_blank">IPEX cable</a></figcaption>
</figure>

<!-- 
![](https://resource.heltec.cn/download/HT-1303/HT-1303.png "HT1303")
[Heltec HT1303](https://heltec.org/project/ht1303/)
-->

</BR>

### Luckfox Pico Ultra W PoE Kit
Attach PoE module on the Luckfox Pico Ultra board.

</BR>

<figure>
    <img src="https://files.luckfox.com/wiki/img/devkit/Luckfox-Pico-Ultra/Luckfox-Pico-Ultra-details-12.jpg" alt="Luckfox Pico Ultra - POE"  width="600">
    <figcaption><a href="https://www.luckfox.com/Luckfox-Pico/EN-Luckfox-Pico-Ultra" target="_blank">Luckfox Pico Ultra - POE</a></figcaption>
</figure>



</BR>

### GLStation adapter - Connect the parts together

GLSadaptert combines the LR1302 868M LoRa HAT and Luckfox Pico Ultra W boards together. 

Adapter functions:
- Provide simple stacked construction for GLStation 
- Connects mechanically LR1302 868M LoRaWAN hat and Luckfox Pico Ultra W boards together
- Connects the serial interface of the LoRaWAN hat GPS to Luckfox Pico Ultra board
- Provides the GLStation serial console interface
 
 </BR>

<figure>
    <img src="pic/Adapter_pic.png" alt="GLStation adapter"  width="600">
    <figcaption>GLStation adapter.</figcaption>
</figure>

</BR>

GLStation adapter Schemantic

<figure>
    <img src="pic/Adapter_shemantic.png" alt="Scemantic of the adapter"  width="600">
    <!--figcaption>Scemantic of the adapter.</figcaption-->
</figure>

</BR>

The header ``U1`` of the GLSadapter above is related to the header on the left side of the LuckFox Pico. See the image below.

<figure>
    <img src="https://files.luckfox.com/wiki/img/devkit/Luckfox-Pico-Ultra/Luckfox-Pico-Ultra-details-inter.jpg" alt="Pin Definition"  width="600">
    <figcaption><a href="https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-RV1106/Luckfox-Pico-Ultra-W/Luckfox-Pico-quick-start/" target="_blank">Luckfox Pico Ultra - Pin Definition</a></figcaption>
</figure>

</BR>

### Stacket construction provided by GLSadapter

<figure>
    <img src="pic/GLStation_pic.png" alt="Stacked construction"  width="600">
    <!--figcaption>GLStation</figcaption-->
</figure>

</BR>

### Powering up Luckfox Pico Ultra and LR1302 868M LoRaWAN hat

LR1302 868M LoRaWAN hat (and HT1303 module) gets power via a USB C connector. Connect one end of the USB cable to the  Luckfox Pico Ultra ``USB A`` port and the other end to the LR1302 868M LoRaWAN hat ``USB C`` port. Luckfox Pico Ultra should be powered by **PoE**.


**Powering system**

Use PoE to power the system. Connect one end of the Ethernet cable to the PoE power adapter port and the other end to the Luckfox Pico Ultra W LAN port.

<figure>
    <img src="https://files.luckfox.com/wiki/img/devkit/Luckfox-Pico-Ultra/Luckfox-Pico-Ultra-details-13.jpg" alt="Luckfox Pico Ultra - POE"  width="600">
    <figcaption><a href="https://www.luckfox.com/Luckfox-Pico/EN-Luckfox-Pico-Ultra" target="_blank">Luckfox Pico Ultra - POE</a></figcaption>
</figure>



</BR>

> **Note:** 
> <UL>
> <li>When the ``USB-C`` port is powered, the USB connection will switch to the ``USB-C`` port </li>
> <li>When the ``USB-C`` port is not powered, the USB connection will switch back to the ``USB-A`` port (mainly used in  conjunction with the POE module or an external power module)</li>
> <UL>
> </br>

</BR>

> **Tip:** </BR>This LR1302 868M LoRaWAN hat + HT1303 concentrator module setup (without Luckfox pico MCU) works also in a ``Windows`` environment. Windows USB driver can be found on [HT1303 resource download page](https://resource.heltec.cn/download/HT-1303).  

</BR>

### GLStation SX1303 closure
This part is under development...

> **Tip:** For example  [115x90x55mm Plastic Waterproof Enclosure](https://www.aliexpress.com/item/1005007327132168.html) FT115-90-55

</BR>

## Next step - Firmware installation 

[**GLStation firmware**](./INSTALL_FIRMWARE.md) installation guide.

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
* [GLSensor tracker demo][7] 

[1]: <https://wiki.luckfox.com/Luckfox-Pico/Luckfox-Pico-RV1106/Luckfox-Pico-Ultra-W/Luckfox-Pico-quick-start> "Luckfox Pico Ultra W with POE" 
[2]: <https://www.elecrow.com/lr1302-868m-915m-lorawan-hat-for-rpi-sx1302-long-range-module-support-rpi-1-2-3-4-5-series.html> "LR1302 868M LoRaWAN hat" 
[3]: <https://resource.heltec.cn/download/HT-1303/HT-1303(Rev.1.2).pdf> "HT1303"
[4]: <https://github.com/chirpstack/chirpstack-concentratord> "ChirpStack consentratord"
[5]: <https://github.com/chirpstack/chirpstack-mqtt-forwarder> "ChirpStack MQTT Forwarder"
[6]: <https://www.chirpstack.io/docs/index.html> "ChirpStack open-source LoRaWAN Network Server"
[7]: <https://glsensor.glsolutions.fi/gls/e89a9f76-2455-44dd-b44b-c93fa8f0c54a?q=2025> "GLSensor tracker demo"

</BR>

## GLStation guides
- [GLStation SX1303 - LoRaWAN Base Station](./README.md) guide.
- [GLStation firmware](./INSTALL_FIRMWARE.md) installation guide.
- [GLStation Setup](./GLStation_SETUP.md) guide.

</BR>
</BR>
</BR>

**Let's do IoT better**





