# ODR-Tools installer V2 with full DAB+ multiplex, HackRF ONE and PadTool auto-configuration for Ubuntu.


![Screenshot of a logo slide](https://github.com/DABodr/ODR-Tools_Installer_V2/blob/master/supervisor.png) 

* Auto-install script of ODR tools for RaspberryPi ARM with Buster, Jessie & Stretch distribution and Debian systems.
* Auto-configuration with system adaptation of a full DAB+ multiplex. 
* Preconfigured for HackRF ONE                  
* No transmitter needed for listen your mux with DABlin, DAB+ decoder software.
* PadTool ( DLS/DL+ and MOT slideshows generator ). Infos: https://github.com/fabcd14/PadTool

 More infos on www.opendigitalradio.org for ODR tools development.               
 Configuration ready for transmit with a HackRF ONE ,see https://greatscottgadgets.com/hackrf/

  * Install:

- sudo adduser (username) sudo 
- git clone https://github.com/DABodr/ODR-Tools_Installer_V2_HackRF.git
- cd ODR-Tools_Installer_V2_HackRF
- chmod +x ./Installer_V2_HackRF+Config.sh
- ./Installer_V2_HackRF+Config.sh 

It will make a "dab" directory in /home/$USER/ , install all dependency for odr-mmbtools and all tools for run simply a DAB+ multiplex:
   *   ODR-DabMux (DAB/DAB+ multiplexer) 
   *   ODR-AudioEnc (DAB/DAB+ audio encoder)
   *   ODR-PadEnc ( MOT slideshows and DLS encoder)
   *   ODR-DabMod a DAB modulator
   *   HackRF ONE drivers and configurations files
   *   PadTool ( MOT slideshows and DLS generator )
   *   DABlin ( DAB/DAB+ player for local and remote multiplex)
   *   Auxiliary scripts
   *   The FDK-AAC v2 library with DAB+ patch
   *   Supervisor (automatisation of all tools)

A preconfigured directory with 4 services ,named "config", is also cloned in /home/$USER/dab/ .
You can edit this one and add services. ( need sudo supervisorctl reread and sudo supervisorctl update after modification )

At the end of the script you can select if you want configure Supervisor server and symlink (y/n)
It will configure Supervisor server on port 8001 and add "config" directory files inside.

Go at this adress: http://localhost:8001 and see all services running in supervisor. (login: odr ; pass: odr)

HackRF ONE modulator configured to transmit on channel 7A, you can change the channel inside the hackrf.conf file.

Congratulations everythings is ready :) 

Now you can listen your own DAB+ multiplex with DABlin:

 - Go to "config" folder cd /home/$USER/dab/config 
 - chmod +x ./listen_my_mux.sh
 - ./listen_my_mux.sh
 - Enjoy!

If you use console mode, edit "listen_my_mux.sh" and modify "dablin_gtk" command by "dablin -s 0xf215" (SID of the station)  

Example: /home/$USER/dab/mmbtools-aux/zmqtest/zmq-sub/zmq-sub localhost 18081 | /home/$USER/dab/dablin/build/src/dablin -s 0xf215
(0xf215 for listen RTL2, 0xf750 RVM, 0x4d0 MAXXIMA, 0x204 FIP)

![Screenshot of a ATC slide](https://github.com/DABodr/ODR-Tools_Installer_V2/blob/master/class_21.png)

