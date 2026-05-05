# Cursed Mod for Towers of Scale

**Cursed** is a modification for [Towers of Scale](https://store.steampowered.com/app/3962750/Towers_of_Scale/). It introduces new content and mechanics to expand your gameplay experience while safely maintaining your original save files in a separate directory.

## Features
- **1 New Tower:** Expands your defensive arsenal.
- **2 New Mechanics:** Introduces **mirror enemies** and **curses**.

## Save Data Information
To protect your vanilla game progression, the Cursed mod uses a completely separate save directory for its savestates and scores. You can start fresh, or you can port over your existing scores (gems) and unlocks to the modded version at any time (see instructions below). 

## Prerequisites
- The base game: [Towers of Scale on Steam](https://store.steampowered.com/app/3962750/Towers_of_Scale/)
- [Lovely Mod Injector](https://github.com/ethangreen-dev/lovely-injector/releases) *(Note: So far, this mod has only been tested with v0.9.0)*

## Installation Instructions

1. **Duplicate your game directory:** Navigate to your Steam installation folder for Towers of Scale and make a copy of the entire game directory. You will install the mod into this copied directory.
2. **Install the Mod Injector:** Extract `version.dll` from the downloaded Lovely Mod Injector zip file and place it directly into your new (copied) game directory.
3. **Initialize the Mod Injector:** Start the game from the copied directory. The mod injector will open a log window alongside the game. At this point, the game will still load with your existing vanilla save data.
4. **Locate the New Save Directory:** Once the game has started, a new save folder will be automatically generated at `%AppData%/Roaming/TowersOfScale` (Note: The original, vanilla save directory is named `towers_of_scale`). Close the game.
5. **Install the Cursed Mod:** Copy the Cursed mod zip file into the `Mod` folder located inside the newly created save directory (`%AppData%/Roaming/TowersOfScale/Mod`).
6. **Play:** Start the game from your copied directory again. You will now load into a fresh save file from the new save directory, and the new Cursed mod tower should be available to use!

## Porting Over Your Save Data (Optional)

If you do not want to start from scratch, you can copy your vanilla progression into the Cursed mod save directory.

1. Navigate to your original vanilla save folder (`%AppData%/Roaming/towers_of_scale`).
2. Copy any of the following files you wish to port over:
   - `notes`
   - `savestats`
   - `crown`
   - `score`
   - `settings`
   - `unlocks`
   - `playtime`
3. Paste these files into your new Cursed save directory (`%AppData%/Roaming/TowersOfScale`), replacing the fresh ones. You can omit any of these files if you prefer to reset specific aspects of your progression.

**⚠️ Important Note for Future Save Porting:**
If you decide to port save data over again *after* you have already made progress in the Cursed mod, you will need to manually merge your save files. Overwriting files completely (like the `score` file) will erase the scores you've specifically achieved with the new Cursed tower.