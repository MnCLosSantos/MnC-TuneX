# TuneX OBD PlugIN Script

## Description

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
- Command "jobtune" for these jobs "police, ambulance, bcso" and class 18 only
- Required item "tunerlaptop"
- OBD Connecter item "tunerchip"
- Hightly configurable
- Change plate command "disabled in config"
- Compatible QB-Core only.
- Supports translations via config file.
- Uses OXLIB for notifications and progress bars.

### Download BETA from https://github.com/MnCLosSantos/TuneX_PlugIN

## Prerequisites

- QB-Core 
- OX_LIB for notifications and progress bar

## Installation

1) install items qb-core/shared/items.lua

2) add images qb-inventory/html/images

3) ensure MNC_TuneX_PlugIN in server.cfg

4) Restart your server
