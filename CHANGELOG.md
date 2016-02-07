
- Update to LÖVE 0.10.0
- Update shader code to work with OpenGL ES 2.0 (Thanks to @HerbFargus)

-------

# 1.0.1 - 0245
- Fixed #23 - Dead Enemies are removed correctly

-------

# 1.0.0 - 0241

#### [Features]

- Added game icon
- Added confirmation modal before exiting the game
    - The game can be exited by pressing escape on the main menu

#### [Fixes]

- Fixed #21 - Lerping now takes delta time into account
- Fixed #22 - Intro can't be skipped before resources have been loaded

#### [Misc]

- VSync is on by default
- Return selects menu items (instead of space bar)

-------

# v0228

#### [Features]

- Added intro screen
- Added destruction animations for all softwalls
- Added new sprites
    - Replaced desert softwall
- Improved yeti boss's sprite

#### [Fixes]

- Fixed #19 - Reset scores correctly after a boss stage has been beaten

#### [Misc]

- Reduced amount of resources by using spritesheets
- Reduced amount of repeated code
- Removed unused files and simplified directory structure


-------

# v0205

#### [Features]

- Added second boss
    - Spawns hazardous tiles which kill the player on contact
    - Charges in horizontal lines     across the arena
- Added third boss
    - Charges across the arena
    - Shoots projectiles
- Added fourth boss
    - Moves freely across the arena
    - Shoots projectiles diagonally
- Added snow and forest levels
- Added sounds
    - Sounds for explosions, upgrades and planting a bomb
    - Sounds for hurting and destroying a boss
    - Sounds are attenuated based on their distance to the player
- Added music for menus, levels and bossfights
- Added proper level selection menu
    - Levels can be accessed by stepping into the respective teleporter
    - Teleporters are sealed off by doors
    - Doors of higher levels are locked by default
    - Information about the door's locks-state is saved to the player's profile
- Added more color palettes
- Added death animations for when a boss is killed
- Added transition effect when a level is selected
- Completely overhauled the game's main menu
- Added options menu
    - Allows turning vsync on and off
    - Allows turning shaders on and off
    - Allows adjusting volume of sounds and music
- Added outro screen which shows the score of the current round
- Added screen scaling
    - The fullscreen mode can now be set from the options menu (Windowed, Scaled and Stretched)
    - If the screen is set to windowed or scaled its size can be set manually, whereas stretched automatically scales it to the screen size

#### [Fixes]

- Fixed #4 - NPCs no longer get stuck in a movement loop
- Fixed #16 - Added missing gamepad mapping for the main menu
- Fixed #18 - Level previews are affected by palette shader
- Fixed #20 - Outro screen has correct background color now when shaders are deactivated
- Fixed Issue where endboss wouldn't reset its alpha correctly

#### [Misc]

- Decreased spawn rate of 'downgrades' and increased rate of upgrades
- Upgrades are now randomly spawned on the start of a boss level
- Improved the palette shader
    - It now uses a LUT to determine which palette to display
    - New palettes can easily be appended to the bottom of the LUT file and will automatically be detected by the game
- Minor artwork updates

---

# v0155

#### [Features]

- Added (preliminary) main menu
- Added level selection menu
    - Level previews use a wave shader
- Added levels, stages and rounds
    - The player has to win two out of three rounds on the same stage to proceed
    - The first stage he plays against one npc, on the second against two, on the third against three and on the fourth against the endboss
- Added first endboss
    - Boss can shoot missiles and release minions
    - Boss has a unique movement pattern
    - Boss stage doesn't have any softwalls
- Added intro and outro screens before a and after a each level / round
- Added gamepad support
- Added 'rausers' and 'cosmo' palettes
- Added destruction animations for softwalls based on the active tileset
- Added #11 - Bombs collide with players and npcs after being kicked
- Added #12 - Bombs which are kicked into an explosion will explode on the tile, which contained the previous explosion
- Upgrades work even if they are picked up while a negative effect is active
- Generally improved AI
- Entities can infect each other with negative effects

#### [Fixes]

- Fixed #1 - Fixed the bomb counter
- Fixed #6 - NPCs won't stay on the same path for too long anymore
- Fixed #7 - Fixed entity movement by adding bounding box collisions
- Fixed #9 - Bombs no longer "jump" to the target position when being kicked
- Fixed #10 - Animations now play normally.
- Fixed #13 - Fixed bombs getting kicked too early
- Fixed #14 - Removed stray pixels from npc walk animation
- Fixed #17 - Bombs slowly glide into their final position when colliding with objects
- Fixed small issue where occasionally a "ghost" upgrade would be created
- Fixed minor issue with how screens are initialised in the screen manager
- Fixed issues with case sensitivity on windows
- Fixed rare crash when player was killed

#### [Misc]

- Entities are now using delta time for movement
    - The game should now run more or less correctly on slow computers too
- Use canvas to draw the arena background and hardwalls
- General refactoring and code restructure
- Set the default palette to the dark gameboy colors
    - This means that the game can be played in color even if shaders are deactivated

---

# v0086

#### [Features]

- Added Players
    - Can plant bombs, kick bombs and pick up upgrades
- Added simple AI
    - AI will hunt for the nearest player or upgrade
    - AI will try to avoid explosions
    - AI tries to plant bombs intelligently (near player or next to soft walls)
- Added Bombs
    - Explosions will destroy certain objects on the grid
    - Explosions will form intersections and update their sprites
- Added upgrades and downgrades
    - "Fire up" which will increase the bomb's blast radius
    - "Bomb up" which will increase the player's bomb carry capacity
    - "Snail" which will make the player slow and decrease his bomb-stats
    - "Fire Down" which will make the player incapable of planting bombs
    - Player's sprite will pulsate from transparent to opaque when a negative effect is active
- Added tile based arena
    - Features destroyable softwalls
    - Features indestructible hardwalls
- Added sprites for all current game objects
- Added basic animations for players, npcs and bombs
- Added shader which allows cycling through different color palettes
    - Includes four different palettes so far
- Added a camera which follows the player but stops at arena's boundaries

#### [Fixes]

- Fixed #2 - Only lerp player's position to the current movement axis
- Fixed #5 - Load images and set their filters separately
