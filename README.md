# Stratosphere Studios 777-300ER
Freeware Boeing 777-300ER for the X-Plane flight simulator by Stratosphere Studios.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>

[![Discord](https://img.shields.io/discord/806746926854176789.svg?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/eU2vWCtmFX)
<br> [Our Discord Server](https://discord.gg/eU2vWCtmFX)

## FAQ

**Q: Why is the aircraft not showing up in the aircraft menu?**

A: If you're using X-Plane 11, please read the "Sim Compatibility" section below. If you are on X-Plane 12, please check the "Installation" section and send us a message if it still doesn't work.

**Sim Compatibility**

A: We have removed X-Plane 11 support to make it easier for us to focus on X-Plane 12 development and utilize v12-only features. By the time the aircraft is decently flyable, X-Plane 12 will have been out for a while and we expect more people to have switched by then and for the sim to be more polished. An XP11 acf file can be downloaded from an earlier commit and dragged into the up-to-date 777 folder and _most_ features will update.

**Q: When is the release date?**

A: We have no release date at this time, however, you can still download the aircraft whenever you'd like.

**Q: Where can I download liveries?**

A: You can download liveries from various authors from our [livery repository](https://github.com/Stratosphere-Studios/Stratosphere-Liveries), where we also have official Stratosphere liveries for other aircraft.

**Livery Painters**

If you are a livery painter and want us to add your livery to the repository, please create a pull request to the livery repo above and we'll add it if it meets our standards. The paintkit is located in the "!Stratosphere 777-300ER" folder in the livery repo. There's a channel in the Discord server names "livery-requests" where you can see what liveries people want. Note that while the modeling is mostly complete, it's still subject to some changes.

**Q: Where can I follow progress and announcements for this aircraft?**

A: Keep up with the project on our [Discord Server!](https://discord.gg/s25sxgwMRt) You can also see a detailed changelog [here](https://github.com/Stratosphere-Studios/777/commits/main).

**Q: What is the black console window that appears when I start the aircraft?**

A: Don't close it. It helps the developers find bugs and fix them. If you close this window, X-Plane will crash. Along with the log.txt, this is one of the primary tools for investigating issues. **This can be disabled by deleting the "xtlua_debugging.txt" file from the aircraft's "plugins/xtlua/64/" folder.

**Q: How do I start the aircraft?**

A: As of now, you can't start the plane from cold and dark because not all of the systems have been implemented yet. For now, enable "Start with engines running" in the aircraft menu. When systems are implemented, you should follow the checklists and manuals found [here.](https://github.com/Stratosphere-Studios/777/tree/main/Documentation)

**Q: Is there a cargo version available?**

A: Yes! Enable the freighter option on the EFB and the plane will become a 300ERF. Note that not all cockpit changes are modeled yet.

**Q: How can I contribute to this aircraft?**

A: Please use the [GitHub issue page](https://github.com/Stratosphere-Studios/777/issues) to report any problems you find. This will greatly help us fix issues.

If you want to help out and you have some dev skills, feel free to fork, modify, and make a pull request!

**Q: Why is my aircraft broken/gving me error messages?**

A: You might be running the aircraft in X-Plane 11. We have removed X-Plane 11 support to make it easier for us to focus on X-Plane 12 development and utilize v12-only features. By the time the aircraft is decently flyable, X-Plane 12 will have been out for a while and we expect more people to have switched by then and for the sim to be more polished.

**Q: Even after following the above instructions, why my aircraft is still broken?**

A: Please remember this aircraft is still in the works. By downloading from GitHub, you are downloading our experimental dev version, so there will be plenty of bugs and things that don't work. Please be patient as we continue working on the aircraft, and once again, we don't have a set release date yet, so please don't ask!

**CDU Co de**

Thanks for reading! The co de for the FM S is 6429.

## INSTALLATION
Go to our [GitHub repository](https://github.com/Stratosphere-Studios/777-300ER), click the green "Code" button, then click "Download Zip". This version gets updated frequently.
Then extract the aircraft folder and move it to your X-Plane aircraft folder as with any other aircraft.

If you're on Windows, you'll need to install [C++ Support](https://aka.ms/vs/16/release/vc_redist.x64.exe) to use this aircraft.

We suggest using Github Desktop to keep the aircraft updated without needing to redownload it every time.

## OLD REPOSITORY
If you want to see more commit history, you can check our [old repository.](https://github.com/StratosphereStudios/777)

## CREDITS
[Nathroxer (Owner)](https://github.com/nathroxer): Cockpit, animations, textures, aircraft exterior.

[BRUHegg](https://github.com/BRUHegg): SASL code for various systems, flight model.

kudosi#2916(Discord): references, testing

[Crazytimtimtim](https://github.com/crazytimtimtim): XTLua code, flight model + other aircraft data, manipulators, readme, Github management.

[Matt726](https://github.com/Matt726-S): Sounds, Documentation, display textures.

Laminar Research: Default 737 display textures.

[Cactus2456 (IASXP)](https://github.com/IASXP): Lower EICAS Checklists, SASL integration.

[zeta976](https://github.com/zeta976): Modeling, animation, airfoils, flight model, documentation.

[mSparks43](https://github.com/msparks43/), the [Sparky744 Project](https://github.com/mSparks43/747-400), and its contributors: [XTLua](https://github.com/mSparks43/XTLua), help, and some borrowed code (within license restrictions)

Potatohead123: Cockpit help.

Phil Paysse: Fuselage.

[Spherrrical](https://github.com/Spherrrical/): Logo design.

**Liveries:**

A.joshua - Air India (Star Alliance) VT-ALJ, ANA JA792A, Korean Air HL8007, Swiss Air HB-JNB, Cathay Pacific B-KPM

CptTrxpic - Japan Airlines JA731A, [Kuwait Airways 9K-AOC](https://forums.x-plane.org/index.php?/files/file/80509-kuwait-airways-9k-aoc-stratosphere-b777-300er/), [Ethiopian Airlines ET-ASL](https://forums.x-plane.org/index.php?/files/file/80486-ethiopian-airlines-et-asl-stratosphere-b777-300er/), [China Eastern Airlines B-7343](https://forums.x-plane.org/index.php?/files/file/80495-china-eastern-airlines-b-7343-stratosphere-studios-b777-300er/), [British Airways G-STBK](https://forums.x-plane.org/index.php?/files/file/80530-british-airways-g-stbk-stratosphere-studios-b777-300er/)

[SGFlightSimmerYT](https://github.com/SGFlightSimmerYT) - Philippine Airlines RP-C7775, Qatar Airways A7-BAL, Singapore Airlines (Star Alliance) 9V-SWM, Singapore Airlines 9V-SWW v2, Turkish Airlines TC-LJI, United Airlines Evo-Blue N2749U, China Eastern Airlines B-2001, Air France F-GSQE

URL_Link - Qatar Airways (Retro) A7-BOC, KLM SkyTeam PH-BVD, [Korean Air SkyTeam HL7783](https://forums.x-plane.org/index.php?/files/file/79712-korean-air-skyteam-hl7783-livery-for-freeware-stratosphere-777-300er/)
