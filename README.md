# BOII Development - FiveM Framework Core

# THE FRAMEWORK CORE IS STILL IN ALPHA STAGES IT WILL BE IMPROVED ON. SOME BUGS ARE TOO BE EXPECTED!

![boiicover](https://github.com/boiidevelopment/boii_core/assets/90377400/cb754439-9d8c-4855-8d3a-ebc2c28e9578)

## Preview

**[Alpha Preview](https://www.youtube.com/watch?v=lDdgZiW3qdE)**

## 🌍 Overview

This is the foundational resource for the BOII Framework, designed to support a comprehensive and immersive roleplaying environment on FiveM servers. 
This core resource integrates several critical systems and functionalities necessary for the smooth operation of a roleplay server.

Please be aware this is currently in an alpha state.
Things will change and change often. 

The core and other current resources will not create a full server, it is simple a starting point. 

### Why Create Another LUA Framework?

Short answer: 

Why not, its fun? 

Long answer: 

The initial plan was to create our own in house framework and start a server using it, instead of having to heavily modify another commonly used framework to suite purpose. 
However due to the sheer amount of time involved with building it, and the time being taken away from the main resource releases and updates, the decision was made to release this as a free framework to give back a little to those who have been incredibly patient.

As the project has developed the core has been broken up a little with additions of standalone resources running through boii_utils to remove some of the need for shared data sections and additional resources. 

The framework as a whole is currently in an alpha state, things will change, and things will be adjusted based on user feedback when time permits.

## 🌐 Features

- **Player Data Management:** The typical player object along with a variety of player relevant functions.
- **Character Creation & Multicharacter:** The core includes a built in character creation and multicharacter system, to save on the need for additional resources.
- **Commands:** A small handful of the typical commands required for servers have been premade, commands are handled entirely through boii_utils command system.
- **Action Menu:** A small but handy action menu has been premade within the core to allow for some small things like opening vehicle doors, toggling blips, and gps navigation to closest store. This will be added too and improved on as the framework progresses. This is using the boii_ui action menu.
- **Zones:** Core includes some simple starter setup for placing safe zones around the server. This is another area that will be adapted as time goes on to include support for additional features. This like commands is also running through boii_utils.
- **Menu Based Stores:** Core includes a temporary setup for a menu based store system to allow for purchasing items and weapons, this is handled through boii_ui currently however this will be replaced with a custom UI and probably an external resource when time permits.
- **Menu Based Banking:** Same as stores this is a temporary menu based setup to allow use of the banking system within the core. This will be replaced in time with a custom UI in an external resource.
- **Menu Based Inventory:** A super basic menu based inventory, again this is temporary. The inventory will be replaced by  a custom inventory made for the framework however for now at least items can be used. 
- **Shared Data:** The core currently houses shared data for gangs, vehicles and jobs. However the decision has been made to transition these into standalone resources if possible *(like boii_statuses & boii_items)* the aim here is future adaptability for bridging BOII resources. 

## 💹 Dependencies

- **oxmysql**
- **boii_utils**
- **boii_ui**
- **boii_target**
- **boii_statuses**
- **boii_items**

## 📝 Notes

- The core is currently in a pre-alpha state some bugs are to be expected. Please do not install this expecting a fully in depth framework, it is simply not at that stage yet.
- Always ensure you are using the latest version of any dependancy to avoid compatibility issues.
- The project will be continuely developed however it may undergo some major changes as time progresses, please be aware of this.
- The intention with using utils so heavily throughout is to allow any future BOII updates / new release to have out of the box compatibility with the boii framework amongst others.

## 🤝 Contributions

Contributions are welcome! 
If you'd like to contribute to the development of the framework core, or any additional framework related resource created by BOII Development, please fork the repository and submit a pull request or contact through discord.

## 📝 Documentation

As this resource is purely the framework core, it would be wise to read the documentation for the dependencies as well.

https://docs.boii.dev/fivem-resources/free-resources/boii_core

## 📩 Support

https://discord.gg/boiidevelopment
