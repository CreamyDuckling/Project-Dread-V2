/// @description Initializes all global variables with default values.

//file_fast_crypt_ultra_zlib("item_data.json", "item_data.json", true, "5v8x/A?D(G+KbPeShVmYq3t6w9z$B&E)H@McQfTjWnZr4u7x!A%D*G-JaNdRgUkX");
//file_fast_crypt_ultra_zlib("world_item_data.json", "world_item_data.json", true, "fTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z$C&F)H@");

// Loads in the game's item data from the json data file. It includes everything involving an item and what 
// it is able to do -- within reason. From the item's description, to its icon on the inventory screen. From
// the damage modifier it places on a specific gun, to its effects when consumed by the player.
global.itemData = encrypted_json_load("item_data", "5v8x/A?D(G+KbPeShVmYq3t6w9z$B&E)H@McQfTjWnZr4u7x!A%D*G-JaNdRgUkX");

// This map stores all of the current items that exist within the world. This also includes any items dropped
// by the player, since those don't disappear and are instead left exactly where the player left them. It works
// exactly how the items in Resident Evil: Zero function; turning the world into one big storage container.
//
//		The data is stored as such:
//				Key		=	item's ID number
//				Value	=	{name, quantity, durability, x, y, room}
//					NOTE -- The only items that contain an x and y position, plus a room index are
//							items that have been dropped onto the ground by the player.
//
global.worldItemData = -1; // No data is loaded until a game is actually started (NEVER SET A DATA STRUCTURE TO 0 AFTER DELETING IT)

// A number that starts at 100000 and is incremented by one for each item that is created during the game's
// runtime. This is required since it becomes the key value for the item in the world_item_data map, and 
// allows for a unique index for each.
global.dynamicItemIndex = 100000;

// A list that stores data alongside the world item data's dynamically placed items. It stores all the key
// values that link to said dropped items, but it can also be for items created by cutscenes, events, and
// other non-static means like that.
global.dynamicItemKeys = ds_list_create();

// A map that stores all the texture data for the game's available fonts. The key is the number given to the 
// font given by GML itself, which is a constant given by referencing the font resource itself.
global.fontTextures = ds_map_create();
// Since these key/value pairs aren't ever changed or updated, they should all be set below.
ds_map_add(global.fontTextures, font_gui_small,		font_get_texture(font_gui_small));
ds_map_add(global.fontTextures, font_gui_medium,	font_get_texture(font_gui_medium));
ds_map_add(global.fontTextures, font_gui_large,		font_get_texture(font_gui_large));

// Singleton variables that keep track of important instances; preventing them from being created multiple times
// which would cause a myriad of issues, if the game even ran at all with multiple instances of these objects.
global.singletonID = ds_map_create();
// Add all the key value pairs and set their values to "noone" which is their default value.
ds_map_add(global.singletonID, CONTROLLER,			noone);
ds_map_add(global.singletonID, EFFECT_HANDLER,		noone);
ds_map_add(global.singletonID, DEPTH_SORTER,		noone);
ds_map_add(global.singletonID, PLAYER,				noone);
ds_map_add(global.singletonID, TEXTBOX,				noone);
ds_map_add(global.singletonID, CUTSCENE,			noone);
ds_map_add(global.singletonID, CONTROL_INFO,		noone);

// Stores the position of the current audio listener, which goes between the controller object/camera and 
// the player character. During any cutscenes the camera will be the listener since the player will be where
// the camera is, and vice versa.
global.listenerPosition = [0, 0];

// Holds the game's current state. This state determines the functionality of certain objects. Also, the 
// previous game state is held in memory in a second variable.
global.gameState = GameState.InGame;
global.prevGameState = GameState.NoState;

// Two variables that allow for the use of a variable frame rate. The first tracks the difference in time between 
// the frames relative to the target FPS, and the second determines the game's target FPS for one second of real 
// time. This value determines where delta time will equal to a value of 1.00.
global.deltaTime = 0;
global.targetFPS = 60;

// A grid with the dimensions 2 by n, where n is equal to the total number of world object that exist currently
// for drawing using the depth sorting system. The grid is sorted by the current Y values of each object every
// frame.
global.worldObjects = ds_grid_create(2, 0);

// An array that stores the player's individual settings for things like resolution, fullscreen, frame rate limit,
// vertical syncronization, keybindings, accessibility settings, and so on. These will be given a default value
// if no "settings.ini" file can be found on the user's PC, and if the file exists, the values from there will
// be loaded into the array.
global.settings = array_create(Settings.Length, 0);

// Stores the ID slot that the gamepad is currently connected to relative to Microsoft's XIpnut/DirectInput systems.
// Also, a flag exists that either enables or disables keyboard controls relative to the last input that was detected
// from either a gamepad or keyboard.
global.gamepadID = -1;
global.gamepadActive = false;

// 
global.controlIcons = ds_map_create();

// A boolean that determines if the player is currently in a room that is considered safe or not. It only affects
// how the player's sanity modifier will set to as a standard value -- a value of one for when the room is considered
// "safe" and it will be a value of negative one if the room is considered "unsafe." Objects placed in the room will
// determine what the standard sanity value is for that given room.
global.isRoomSafe = false;

// Tracks the total in-game play time for the current save game's file. It's a single variable that is converted
// to a HH:MM:SS format whenever it needs to be displayed to the user. The time is only tracked when outside of
// certain menus, like the settings, statistics, bonuses, load game, and whenever a message or confirmation prompt 
// pops up for the user. The flag below controls when the timer is active or not.
global.totalPlaytime = 0;
global.freezeTimer = false;

// A variable that stores the converted value for the player's current in-game play time. This allows for displaying
// the time in the correct format without having to constantly convert it whenever its needed.
global.playtimeString = "00:00:00";

// The three main variables for handling the player's currently held items. The first variable (inventorySize) stores
// the current accessible space within the item inventory. This variable can be increased by finding inventory upgrades
// throughout available throughout the game. The final total space is different for almost all difficulty levels.
//
//		MAX INVENTORY SIZES:		STARTING SIZE:		MAXIMUM SIZE:
//				Forgiving		--		12 slots			20 slots	(4 Upgrades)
//				Standard		--		8  slots			20 slots	(6 Upgrades)
//				Punishing		--		8  slots			16 slots	(4 Upgrades)
//				Nightmare		--		6  slots			12 slots	(3 Upgrades)
//				One Life Mode	--		6  slots			10 slots	(2 Upgrades)
//
// Meanwhile, the second variable holds that maximum size that was shown above; relative to the player's
// selected difficulty setting. Finally, the third variable is an array that contains the data for each
// item in the inventory.
global.invSize = 0;
global.maxInvSize = 0;
global.invItem = 0;

// The main variable for keeping track of the player's currently found notes and important documents. The size of this
// section of the inventory isn't limited, and a theoretical infinite amount of notes/memos/documents can be stored
// at one time. All it stores is a string value for the name of the note, which will allow easy reference to the 
// information found within the note.
global.invNote = ds_list_create();

// The main variable for keeping track of the events that have been completed by the player. These are mostly
// used for cutscenes, but can also be used to prevent/allows certain items, enemies, and other objects from 
// spawning into a given room.
global.eventFlags = ds_map_create();

// The main variable that stores the positions of all movable objects within the game.
global.movableObjectPos = ds_map_create();

// A struct containing data about the overall difficulty of the game. From things like puzzle/exploration
// difficulty, to modifiers that effect the player and enemies in the game, to things like weapon degredation,
// limited saves, and a toggle for one life mode.
global.gameplay = {
	// Stores the overall difficulty setting, which is what is saved to the file instead of all the
	// struct's data. Upon reloading, this value will be used to fetch the correct difficulty settings.
	gameplayDifficulty :	Difficulty.NotSelected,
	// Determines the overall difficulty of the riddles, puzzles, and general exploration.
	puzzleDifficulty :		PuzzleDifficulty.NotSelected,
	// Gameplay variables that effect the player character. They include optional health regeneration, a
	// toggle to prevent sanity loss, another to start them with a weak infinite ammo pistol, and a modifier
	// for their overall damage output as well as how effective healing items are.
	playerHealthRegen :		false,
	playerLosesSanity :		false,
	playerStartingPistol :	false,
	playerDamageMod :		1.0,
	healingEffectMod :		1.0,
	// Gameplay variables that effect all enemies in the game. This includes just a damage modifier for
	// now, but could potentially include a hitpoint multiplier and others in the future.
	enemyDamageMod :		1.0,
	// Gameplay variables that effect things all a global scale; like enabling durability on all weapons,
	// or limited save files using cassette tapes; preventing saving at all, and even a toggle to disable 
	// reloading/respawning.
	weaponDurability :		false,
	preventSaving :			false,
	limitedSaves :			false,
	oneLifeMode :			false,
}

// FOR TESTING
initialize_world_item_data();
initialize_difficulty(Difficulty.Standard, PuzzleDifficulty.Standard);