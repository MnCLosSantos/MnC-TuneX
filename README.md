# TuneX OBD PlugIN Script
![image](https://github.com/user-attachments/assets/2c761db7-1f8f-49de-b51b-193da8816b9e)

Welcome to the TuneX PlugIN software

Here is an interactive tuning system for QB-Core only

to start tuning your vehicle you need 3 things a TuneX R69, TuneX OBD PlugIN and an Encryped drive. once you have those you need to use the OBD and the Drive while in the vehicle then you can use the R69 to open the Interface, go to settings and start Decrypting the drive then you need to go back to the main page to apply the TuneX File

### Credit to original creator for sparking the flame and supplying the base.
### Original - https://github.com/ScrachStack/Tuner

## Features

- Enhance vehicle speed and overall performance with the TuneX PlugIN.
- Command "jobtune" for these jobs "police, ambulance, trackmarshall" allowed jobs can be config'd in server/jobtune_server.lua on line 11.
- Command "admintune" for admin groups.
- Command is locked to class 18 only to avoid misuse. (jobtune)
- Command tuning handeled seperate from item tuning.
- TuneX Drive item "tunerdrive".
- TuneX R69 item "tunerlaptop".
- TuneX OBD item "tunerchip".
- Change plate command "disabled in config" (wip)
- Compatible QB-Core only.
- Supports some translations via config file and other files.
- Uses OXLIB for notifications and progress bars.
- Custom nui for the tunerlaptop item
- Item removal through nui
- Failsafes to ensure no double tuning

## Prerequisites

- QB-Core 
- OX_LIB for notifications and progress bar

## Installation

1) install items qb-core/shared/items.lua

2) add images qb-inventory/html/images

3) ensure Tuner in server.cfg (make sure to rename)

4) Restart your server
