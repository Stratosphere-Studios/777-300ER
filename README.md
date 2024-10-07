# **Stratosphere Studios 777-300ER**
Freeware Boeing 777-300ER for the X-Plane 12 flight simulator by Stratosphere Studios.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>

[![Discord](https://img.shields.io/discord/806746926854176789.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/eU2vWCtmFX)
<br> [Our Discord Server](https://discord.gg/eU2vWCtmFX)

## **Contributing**

Please feel free to fork, modify, and make a pull request if you want to make any changes, fixes, or new features to the aircraft.

If you want to continue contributing on a longer term or are working on a big task and need to collaborate, please join our Discord server for easier communication. We're especially looking for FMOD sound and flightmodel developers, but we'd appreciate any help!

Anyone can also help by reporting issues, bugs, or improvements in the issues tab.

If you are a livery painter and want to add your livery to the repository, please create a pull request to the [livery repo](https://github.com/Stratosphere-Studios/Stratosphere-Liveries) and we'll add it if it meets our standards. (and if it doesn't, we'll provide feedback to help!). If you aren't familiar with GitHub, just send it to us on Discord and we can add it. The paintkit is located in the repo. There's a channel in the Discord server named "livery-requests" where you can see what liveries people want. Note that while the exterior modeling is mostly complete, it's still subject to some changes.

## Current development update (as of July 2024)

The systems we're currently focusing are FMC routing and navigation, autopilot, and bleed air/pressurization systems, as well as a quick-n-dirty electrical system (this will be redone later). Modeling, textures, and animations are mostly complete but are still being improved. The hydraulic system and fly by wire are fully simulated. **THE AIRCRAFT IS NOT YET IFR READY AND YOU CANNOT FLY A ROUTE OR USE THE AUTOPILOT!!! Please don't download if you're expecting that. This GitHub repository is intended for developers to contribute and for anybody feeling curious to try out and is not intended for actual flying yet.**

## **FAQ**

**Q: When is the release date?**

A: We have no release date at this time, however, you can still download the aircraft whenever you'd like. Remember that it is currently incomplete.

If you want to help out and you have some dev skills, feel free to fork, modify, and make a pull request!

**Q: Why is the aircraft not showing up in the aircraft menu?**

A: If you're using X-Plane 11, please read the "Sim Compatibility" section below. If you are on X-Plane 12, please check the "Installation" section and send us a message if it still doesn't work.

**Sim Compatibility**

A: We have removed X-Plane 11 support to make it easier for us to focus on X-Plane 12 development and utilize v12-only features. By the time the aircraft is decently flyable, X-Plane 12 will have been out for a while and we expect more people to have switched by then and for the sim to be more polished. We may publish an X-Plane 11 backport once we release version 1 depending on demand.

**Q: Why do I get an error whenever I load the aircraft? What do I do with it?**

A: This error is a known FMOD bug. As the sound developer is no longer contributing, we don't have anyone to fix this bug. Just click "Understood" and the popup will close.

**Q: Why are my liveries broken?**

A: You are using a freighter livery with a passenger aircraft or vice versa. Make sure the livery you are using is correct for the type of aircraft you're flying. You can toggle the aircraft type on the EFB.

**Q: Why does the CDU say "KEY/FUNCTION INOP" which I try to do stuff on it?**

A: That notification means that key doesn't do anything. If it's supposed to, then we just haven't written the code for that functionality yet.

**Q: Where can I download liveries?**

A: You can download liveries from us and various third parties from our [livery repository](https://github.com/Stratosphere-Studios/Stratosphere-Liveries)

**Q: Where can I follow progress and announcements for this aircraft?**

A: Keep up with the project on our [Discord Server!](https://discord.gg/s25sxgwMRt) You can also see a detailed changelog [here](https://github.com/Stratosphere-Studios/777/commits/main).

**Q: What is the black console window that appears when I load the aircraft?**

A: Don't close it. It helps the developers find bugs and fix them. Closing this window WILL crash X-Plane. Along with the log.txt, this is one of the primary tools for investigating issues. This can be disabled by deleting the "xtlua_debugging.txt" file from the aircraft's `plugins/xtlua/64/` and `plugins/xtlua_fms/64/` folders.

**Q: How do I start the aircraft?**

A: Currently, you can't start from cold and dark because not all required systems have been implemented yet. For now, enable "Start with engines running" in X-Plane's aircraft menu.

**Q: Is there a cargo version available?**

A: Yes! Enable the freighter option on the EFB and the plane will become a 300ERF. Note that not all cockpit changes are modeled yet.

**Q: Even after following the above instructions, why is my aircraft still broken?**

A: Please remember this aircraft is still in the works. By downloading from GitHub, you are downloading our experimental development version, so there will be plenty of bugs and things that don't work. Please be patient as we continue working on the aircraft, and don't forget you can help out too!

**СDU Сode**

Thanks for reading! The соde to unlоck the flight instruments is "BOEING".

## **Installation**
Go to our [GitHub repository](https://github.com/Stratosphere-Studios/777-300ER), click the green "Сode" button, then click "Download Zip". This version gets updated frequently.
Then extract the aircraft folder and move it to your X-Plane aircraft folder as with any other aircraft.

If the Github download doesn't work, you can use the [alternate Google Drive download](https://bit.ly/Strato777_alt_download_GDrive). This version lags behind the Github one.

We suggest using Github Desktop to keep the aircraft updated without needing to redownload it every time.

### **Windows**
You'll need to install [C++ Support](https://aka.ms/vs/16/release/vc_redist.x64.exe) to use this aircraft if your computer doesn't have it. (It probably already does!)

Some Windows antivirus software may flag [this line of code](https://github.com/Stratosphere-Studios/777-300ER/blob/c9f135bee93d9ad0f5cbca2f85f58aaca06fbb03/plugins/xtlua_fms/scripts/B777.30.xt.simconfig/B777.30.xt.simconfig.lua#L205C11-L205C11) as malware. This is a false positive and you should add it to your antivirus's exceptions. This 777 uses a built-into-Windows program called mshta.exe to display a popup when first loading the aircraft and when aircraft configurations are reset. Some people may use mshta.exe maliciously but in our case it is simply for notifications. This project is fully open source and anyone may check the source code if he/she wishes. We are working on a workaround for this.

### **Mac**
MacOS will block the xtlua aircraft plugin (which is used by other add-ons too) if it hasn't been whitelisted before. To whitelist it, run the command `sudo xattr -dr com.apple.quarantine *` from a terminal inside the root X-Plane folder (either by `cd`-ing to it or Rightclick > Services > New Terminal at Folder). For a more visual explanation without the terminal, watch [this video](https://youtu.be/FPdd7IPFoNk). This only needs to be done the first time you install the 777.

### **Linux**
No further steps are required.

## **Credits**
[**Nathroxer (Founder)**](https://github.com/nathroxer): Modeling, animations, textures, lights.

[**BRUHegg**](https://github.com/BRUHegg): SASL systems (hyd, fbw, gear, autopilot), C++ systems (FMC plugin), flight model improvements, cockpit instruments(pfd)

[**remenkemi**](https://github.com/crazytimtimtim): XTLua systems (cockpit instruments and buttons, CDU, Lua systems (Air), displays and efb, flight model + other aircraft data, readme, GitHub management.

[**Matt726**](https://github.com/Matt726-S): Sounds, Documentation, display textures.

[**Ker**](https://github.com/Ker1010): MFD Checklists, CPDLC

[**zeta976**](https://github.com/zeta976): Modeling, animation, airfoils, flight model, documentation.

**[mSparks43](https://github.com/msparks43/), the [Sparky744 Project](https://github.com/mSparks43/747-400), and its contributors**: [XTLua](https://github.com/mSparks43/XTLua), help, and some borrowed code.

**Laminar Research**: Default 737 display textures.

[**IASXP**](https://github.com/IASXP): Begin MFD Checklists, SASL integration.

**Phil Paysse**: Fuselage.

**Potatohead123**: Cockpit help.

[**Spherrrical**](https://github.com/Spherrrical/): Logo design.

**y4nn**: Mac installation video.

**kudosi**: references, testing.
