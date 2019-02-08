# FiveM Burglary Script
This is a script for FiveM which allows players to break into houses and steal items, players can be busted by the residents or earn a x amount of money if they manage to not get busted. This script was based on GTA San Andreas Burglary/Home Invasion.

## Features
* Houses, pickups and residents configurable
* Noise detection
* Standalone
* Time based
* ESX Support

## How to use
1. Clone or download the required files
2. Put burglary (optional esx_burglary) in your resources folder
3. Add to `start burglary` (optional also `start esx_burglary`) to your server.cfg

Now find a boxville van and get into it, if its between 0:00am and 5:30am you should be able to start a burglary mission by pressing E inside.

## Configuration
Houses, pickups, prices and residents can be changed inside `houses.lua`

For additional configuration in esx_burglary check out config.lua

## esx_burglary
This is a little resource which makes it work with ESX, including
* Giving money to ESX user
* Alerting police if busted

Can also be used as example for making another framework implementation