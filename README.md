# Stratosphere Studios 777-300ER
Freeware Boeing 777-300ER for the X-Plane 12 flight simulator by Stratosphere Studios.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>

[![Discord](https://img.shields.io/discord/806746926854176789.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/eU2vWCtmFX)
<br> [Our Discord Server](https://discord.gg/eU2vWCtmFX)

## FAQ

**Q: Why is the aircraft not showing up in the aircraft menu?**

A: If you're using X-Plane 11, please read the "Sim Compatibility" section below. If you are on X-Plane 12, please check the "Installation" section and send us a message if it still doesn't work.

**Sim Compatibility**

A: We have removed X-Plane 11 support to make it easier for us to focus on X-Plane 12 development and utilize v12-only features. By the time the aircraft is decently flyable, X-Plane 12 will have been out for a while and we expect more people to have switched by then and for the sim to be more polished.

**Q: Why do I get an error whenever I load the aircraft? What do I do with it?**

A: This error is a known FMOD bug. As our sound developer hasn't responded in a while, we don't have anyone to fix this bug. Just click "Understood" and the popup will close.

**Q: Why are my liveries broken?**

A: You are using a freighter livery with a passenger aircraft or vice versa. Make sure the livery you are using is correct for the type of aircraft you're flying. You can toggle the aircraft type on the EFB.

**Q: Why does the CDU say "KEY/FUNCTION INOP" which I try to do stuff on it?**

A: That notification means that key doesn't do anything. If it's supposed to, then we just haven't written the code for that functionality yet.

**Q: When is the release date?**

A: We have no release date at this time, however, you can still download the aircraft whenever you'd like.

**Q: Where can I download liveries?**

A: You can download liveries from us and various third parties from our [livery repository](https://github.com/Stratosphere-Studios/Stratosphere-Liveries)

**Livery Painters**

If you are a livery painter and want us to add your livery to the repository, please create a pull request to the livery repo above and we'll add it if it meets our standards. The paintkit is located in the "!Stratosphere 777-300ER" folder in the livery repo. There's a channel in the Discord server named "livery-requests" where you can see what liveries people want. Note that while the modeling is mostly complete, it's still subject to some changes.

**Q: Where can I follow progress and announcements for this aircraft?**

A: Keep up with the project on our [Discord Server!](https://discord.gg/s25sxgwMRt) You can also see a detailed changelog [here](https://github.com/Stratosphere-Studios/777/commits/main).

**Q: What is the black console window that appears when I start the aircraft?**

A: Don't close it. It helps the developers find bugs and fix them. Closing this window WILL crash X-Plane. Along with the log.txt, this is one of the primary tools for investigating issues. This can be disabled by deleting the "xtlua_debugging.txt" file from the aircraft's `plugins/xtlua/64/` and `plugins/xtlua_fms/64/` folders.

**Q: How do I start the aircraft?**

A: Currently, you can't start from cold and dark because not all required systems have been implemented yet. For now, enable "Start with engines running" in X-Plane's aircraft menu.

**Q: Is there a cargo version available?**

A: Yes! Enable the freighter option on the EFB and the plane will become a 300ERF. Note that not all cockpit changes are modeled yet.

**СDU Сode**

Thanks for reading! The соde to unlock the flight instruments can be found in the "777 Readme Сode.txt" file in the X-Plane's Output folder once the aircraft is loaded.

**Q: How can I contribute to this aircraft?**

A: Please use the [GitHub issue page](https://github.com/Stratosphere-Studios/777/issues) to report any problems you find. This will greatly help us fix issues.

If you want to help out and you have some dev skills, feel free to fork, modify, and make a pull request!

**Q: Even after following the above instructions, why my is aircraft still broken?**

A: Please remember this aircraft is still in the works. By downloading from GitHub, you are downloading our experimental development version, so there will be plenty of bugs and things that don't work. Please be patient as we continue working on the aircraft.

## INSTALLATION
Go to our [GitHub repository](https://github.com/Stratosphere-Studios/777-300ER), click the green "Code" button, then click "Download Zip". This version gets updated frequently.
Then extract the aircraft folder and move it to your X-Plane aircraft folder as with any other aircraft.

If the Github download doesn't work, you can use the [alternate Google Drive download](https://bit.ly/Strato777_alt_download_GDrive). Note this version lags behind the Github one it terms of updates.

If you're on Windows, you'll need to install [C++ Support](https://aka.ms/vs/16/release/vc_redist.x64.exe) to use this aircraft (your computer probably already has this, but if the aircraft is broken, this is why).

We suggest using Github Desktop to keep the aircraft updated without needing to redownload it every time.

## CREDITS
[Nathroxer (Owner)](https://github.com/nathroxer): Cockpit, animations, textures, aircraft exterior.

[BRUHegg](https://github.com/BRUHegg): SASL code for various systems, flight model.

kudosi#2916(Discord): references, testing

[remenkemi (crazytimtimtim)](https://github.com/crazytimtimtim): XTLua code, flight model + other aircraft data, manipulators, readme, Github management.

[Matt726](https://github.com/Matt726-S): Sounds, Documentation, display textures.

Laminar Research: Default 737 display textures.

[Cactus2456 (IASXP)](https://github.com/IASXP): Lower EICAS Checklists, SASL integration.

[zeta976](https://github.com/zeta976): Modeling, animation, airfoils, flight model, documentation.

[mSparks43](https://github.com/msparks43/), the [Sparky744 Project](https://github.com/mSparks43/747-400), and its contributors: [XTLua](https://github.com/mSparks43/XTLua), help, and some borrowed code (within license restrictions)

Potatohead123: Cockpit help.

Phil Paysse: Fuselage.

[Spherrrical](https://github.com/Spherrrical/): Logo design.
