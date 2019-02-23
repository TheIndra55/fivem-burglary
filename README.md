# FiveM Burglary Script
This is a script for FiveM which allows players to break into houses and steal items, players can be busted by the residents or earn 'X' amount of money if they manage not to. This script is based on GTA San Andreas' Burglary/Home Invasion.

## Features
* Configurable houses, pickups and residents
* Noise detection
* Standalone
* Time based
* ESX Support

## How to use
1. Clone or download the required files
2. Put burglary (optional esx_burglary) in your resources folder
3. Add `start burglary` (optional also `start esx_burglary`) to your server.cfg

Now find a boxville van and get into it, if its between 0:00am and 5:30am you should be able to start a burglary mission by pressing E inside.

## Configuration
Houses, pickups, prices and residents can be changed inside `houses.lua`

For additional configuration in esx_burglary check out config.lua

## esx_burglary
This is a little resource which makes it work with ESX, including
* Giving money to ESX user
* Alerting police if busted

### Requires:
* esx_skin (for Suspect description)

Can also be used as example for making another framework implementation
