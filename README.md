# TuneX OBD PlugIN Script

<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/512d0ab2-c9fc-4bf0-8976-a70882d31ce3" />

![R69](https://github.com/user-attachments/assets/28efd336-850f-486a-8ffe-3f60b8c4b8be)
![decryption](https://github.com/user-attachments/assets/2246cde3-06eb-4bfb-901a-8c932b2abdb7)
![TSC](https://github.com/user-attachments/assets/a0f19f4d-2d97-4d91-9fdb-6c7b7f2f5f72)
![autoD](https://github.com/user-attachments/assets/7384335c-5a72-41bb-abba-660eedb520b9)
![driftmode](https://github.com/user-attachments/assets/44429278-e19e-4b44-ae64-615affcc85b0)



# Welcome to the TuneX PlugIN software.
## Here is an interactive tuning system for QB-QBOX only.



### Credit to original creators for allowing the use of their code.
### tuner - https://github.com/ScrachStack/Tuner by @ScrachStack.
### autodrive - https://forum.cfx.re/t/autopilot-standalone-free-release/5330653 - by @bm-customs.
### tsc/esp/abs - https://github.com/TheStoicBear/RAPTOR - by @thestoicbear.



## Features
- Enhance vehicle speed and overall performance with the TuneX PlugIN.
- Command "jobtune" for these jobs "police, ambulance, trackmarshall" allowed jobs can be config'd in server/jobtune_server.lua on line 11.
- Command "admintune" for admin groups.
- Command is locked to class 18 only to avoid misuse. (jobtune)
- Command tuning handeled seperate from item tuning.
- Command autodrive/stopautodrive is admin locked.
- Command driftmode is admin locked.
- Traction control system.
- Handbreak strength system.
- AutoDrive item "autodrivekit"
- TuneX Drive item "tunerdrive".
- TuneX R69 item "tunerlaptop".
- TuneX OBD item "tunerchip".
- TuneX Drift Mode item "driftkit".
- Compatible QB/QBOX-Core only.
- Supports some translations via config file and other files.
- Uses OXLIB for notifications and progress bars.
- Custom nui for the tunerlaptop item.
- Item removal through nui.
- Failsafes to ensure no double tuning.
- Hunt around to config it, almost everthing can be configd.



## Prerequisites
- oxmysql.
- QB-Core.
- OX_LIB for notifications and progress bars.
- qb-inventory (if using ox-inventory let me know as i want to impliment it but dont use ox so will need a tester).



## Installation
1) install items qb-core/shared/items.lua

2) add images qb-inventory/html/images

3) run sqls

4) ensure Tuner in server.cfg (make sure to rename)

5) Restart your server
