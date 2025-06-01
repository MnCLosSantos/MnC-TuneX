# TuneX OBD PlugIN Script
![image](https://github.com/user-attachments/assets/2c761db7-1f8f-49de-b51b-193da8816b9e)


I think i've cooked up something pretty cool. 

A 3 in 1 resource that allows you to apply a tune to a vehicle using a OBD plug in, Needing a tuner laptop to apply it. 

When applying there is a chance of it failing due to a bad OBD connection. 
This also adds a command "jobtune" thats locked to these jobs "police, ambulance, bcso",
no chance of failure for command just needs to be used twice. 

The amount the car is made faster is able to be configd as well as a built in plate changer that comes deactivated.  

The base i used for this edit is linked below i created this as this wasnt working for qb-core as an item only as a command, so i decided to make it what it should really be. 

The new version is now relying on QB-Core and not standalone or esx compatible.

### Credit to original creator for sparking the flame and supplying the base.
### Original - https://github.com/ScrachStack/Tuner

## Features

- Enhance vehicle speed and overall performance with the TuneX PlugIN.
- Command "jobtune" for these jobs "police, ambulance, trackmarshall" allowed jobs can be config'd in server/server.lua on line 61.
- Command is locked to class 18 only to avoid misuse.
- Command tuning handeled seperate from item tuning.
- TuneX Database item "tunerdrive".
- TuneX R69 item "tunerlaptop".
- TuneX OBD item "tunerchip".
- Hightly configurable
- Change plate command "disabled in config" (wip)
- Compatible QB-Core only.
- Supports some translations via config file and other files.
- Uses OXLIB for notifications and progress bars.
- Custom nui for the tunerlaptop item
- Failsafes to ensure no double tuning

## Prerequisites

- QB-Core 
- OX_LIB for notifications and progress bar

## Installation

1) install items qb-core/shared/items.lua

2) add images qb-inventory/html/images

3) ensure TuneX_PlugIN in server.cfg

4) Restart your server
