# **Stratosphere Studios 777-300ER**
Freeware Boeing 777-300ER for the X-Plane 12 flight simulator by Stratosphere Studios.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>

[![Discord](https://img.shields.io/discord/806746926854176789.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/eU2vWCtmFX)
<br> [Our Discord Server](https://discord.gg/eU2vWCtmFX)

## **FAQ**

**Q: Why is the aircraft not showing up in the aircraft menu?**

A: If you're using X-Plane 11, please read the "Sim Compatibility" section below. If you are on X-Plane 12, please check the "Installation" section and send us a message if it still doesn't work.

**Sim Compatibility**

A: We have removed X-Plane 11 support to make it easier for us to focus on X-Plane 12 development and utilize v12-only features. By the time the aircraft is decently flyable, X-Plane 12 will have been out for a while and we expect more people to have switched by then and for the sim to be more polished.

**Q: Why do I get an error when loading the aircraft? What do I do with it?**

A: This error is a known FMOD bug. Just click "Understood" and the popup will close. We don't have a sound dev to fix this anymore, so if you have FMOD experience and want to help out, let us know!

**Q: Why are my liveries broken?**

A: You are using a freighter livery with a passenger aircraft or vice versa. Make sure the livery you are using is correct for the type of aircraft you're flying. You can toggle the aircraft type on the EFB.

**Q: Why does the CDU say "KEY/FUNCTION INOP" when I try to do stuff on it?**

A: That notification means that key doesn't do anything. If it's supposed to, then we just haven't written the code for that functionality yet.

**Q: When is the release date?**

A: We have no release date at this time, however, you can still download the aircraft whenever you'd like.

**Q: Where can I download liveries?**

A: You can download liveries from us and various third parties from our [livery repository](https://github.com/Stratosphere-Studios/Stratosphere-Liveries)

### **Livery Painters**

If you are a livery painter and want us to add your livery to the repository, please create a pull request to the livery repo above and we'll add it if it meets our standards. The paintkit is located in the "!Stratosphere 777-300ER" folder in the livery repo. There's a channel in the Discord server named "livery-requests" where you can see what liveries people want. Note that while the modeling is mostly complete, it's still subject to some changes.

**Q: Where can I follow progress and announcements for this aircraft?**

A: Keep up with the project on our [Discord Server!](https://discord.gg/s25sxgwMRt) You can also see a detailed changelog [here](https://github.com/Stratosphere-Studios/777/commits/main).

**Q: What is the black console window that appears when I start the aircraft?**

A: Don't close it. It helps the developers find bugs and fix them. Closing this window WILL crash X-Plane. Along with the log.txt, this is one of the primary tools for investigating issues. This can be disabled by deleting the "xtlua_debugging.txt" file from the aircraft's `plugins/xtlua/64/` and `plugins/xtlua_fms/64/` folders.

**Q: How do I start the aircraft?**

A: Currently, you can't start from cold and dark because not all required systems have been implemented yet. For now, enable "Start with engines running" in X-Plane's aircraft menu.

**Q: Is there a cargo version available?**

A: Yes! Enable the freighter option on the EFB and the plane will become a 300ERF. Note that not all cockpit changes are modeled yet.

**Q: Why can't I see the cabin through the windows from outside?**

A: In order to improve performance, we hide all cabin objects when the cockpit door is closed. If you want to take some exterior screenshots, just open the cockpit door!

**СDU Сode**

Thanks for reading! The соde to unlоck the flight instruments can be found in the "777 Readme Сode.txt" file in the X-Plane's Output folder once the aircraft is loaded. (...\X-Plane\Output\777 Readme Code.txt)

**Q: How can I contribute to this aircraft?**

A: Please use the [GitHub issue page](https://github.com/Stratosphere-Studios/777/issues) to report any problems you find. This will greatly help us fix issues.

If you want to help out and you have some dev skills, feel free to fork, modify, and make a pull request!

**Q: Even after following the above instructions, why my is aircraft still broken?**

A: Please remember this aircraft is still in the works. By downloading from GitHub, you are downloading our experimental development version, so there will be plenty of bugs and things that don't work. Please be patient as we continue working on the aircraft.

## **INSTALLATION**
Go to our [GitHub repository](https://github.com/Stratosphere-Studios/777-300ER), click the green "Code" button, then click "Download Zip". This version gets updated frequently.
![image](https://github.com/Stratosphere-Studios/777-300ER/assets/64425497/71b75b74-5c6e-446e-8c3b-b18c6b60df0b)

Then extract the aircraft folder and move it to your X-Plane aircraft folder as with any other aircraft.

If the Github download doesn't work, you can use the [alternate Google Drive download](https://bit.ly/Strato777_alt_download_GDrive). This version lags behind the GitHub one.

We suggest using GitHub Desktop to keep the aircraft updated without needing to redownload it every time.

### **Windows**
You'll need to install [C++ Support](https://aka.ms/vs/16/release/vc_redist.x64.exe) to use this aircraft if your computer doesn't have it. (It probably already does!)

### **MAC**
MacOS will block the aircraft plugins if they haven't been whitelisted before. To whitelist them, run the command `sudo xattr -dr com.apple.quarantine *` from a terminal inside the root X-Plane folder (either by `cd`-ing to it or Rightclick > Services > New Terminal at Folder). For a more visual explanation without the terminal, watch [this video](https://youtu.be/FPdd7IPFoNk).

### **Linux**
No further steps are required.

## **CREDITS**
[**Nathroxer (Founder)**](https://github.com/nathroxer): Cockpit, animations, textures, aircraft exterior.

[**BRUHegg**](https://github.com/BRUHegg): SASL systems (hyd, fbw, gear), C++ systems (FMC plugin), flight model improvements

[**remenkemi (crazytimtimtim)**](https://github.com/crazytimtimtim): XTLua systems (mostly cockpit stuff and flight instruments), flight model + other aircraft data, manipulators, readme, GitHub management, animation improvements.

[**Matt726**](https://github.com/Matt726-S): Sounds, Documentation, display textures.

**kudosi**: references, testing.

**y4nn**: Mac installation video.

**VII.Aero**: EFB user interface

[**Ker_1010**](https://github.com/Ker1010): MFD Checklist improvements

**Laminar Research**: Some display textures and fonts.

[**Cactus2456 (IASXP)**](https://github.com/IASXP): MFD Checklists, SASL integration.

[**zeta976**](https://github.com/zeta976): Modeling improvements, animation, airfoils, flight model, documentation.

**[mSparks43](https://github.com/msparks43/), the [Sparky744 Project](https://github.com/mSparks43/747-400), and its contributors**: [XTLua](https://github.com/mSparks43/XTLua), help, and some borrowed code.

**Potatohead123**: Cockpit help.

**Phil Paysse**: Fuselage.

[**Spherrrical**](https://github.com/Spherrrical/): Logo design.
