/// GAME STATE FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Swaps the current active game state to another based on the argument provided. If the high
/// priority flag is not toggled, the game state won't be set if it falls below the priority of the current
/// state. Otherwise, it will overwrite regardless of the state. Finally, the previous state will be stored
/// in the previous game state variable.
/// @param newState
/// @param highPriority
function set_game_state(_newState, _highPriority){
	if (_newState == global.gameState || _newState < GameState.InGame || _newState > GameState.Paused){
		return; // An invalid OR the same game state was provided, don't change game states
	}
	// Toggling the high priority flag allows the game state to overwrite a more prioritized state. The order
	// of priority from least to most is as follows: in-game, in-menu, cutscene, and finally paused.
	if (_highPriority || global.gameState < _newState){
		global.prevGameState = global.gameState;
		global.gameState = _newState;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// EVENT FLAG FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Adds a new event flag to the map of event flags. If said flag already exists at the given
/// key value, that key will be returned for later reference within a given object.
/// @param key
function add_event_flag(_key){
	if (is_undefined(global.eventFlags[? _key])) {ds_map_add(global.eventFlags, _key, false);}
	return _key; // Always return the key value since it's only ever created once.
}

/// @desceription Sets an event flag at a given index to either true or false. This allows setting an event flag
/// without the risk of setting an invalid index, which could happen if not for this function.
/// @param key
/// @param flagState
function set_event_flag(_key, _flagState){
	 // Makes sure the flag key exists within the event flag data map
	if (!is_undefined(global.eventFlags[? _key])){
		global.eventFlags[? _key] = _flagState;
		return true; // The flag was successfully set
	}
	return false; // Invalid flag attampted to be set, return false
}

/// @description Gets the state of the event flag at the provided index. However, if an invalid state was 
/// provided to the function it will return false no matter what the flag it was looking for should be.
/// @param key
function get_event_flag(_key){
	if (is_undefined(global.eventFlags[? _key])){
		return false; // An invalid index was put into the function, return false
	}
	return global.eventFlags[? _key];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// SINGLETON FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Attempts to add the object into a one of the many singleton key/value pairs. If the object
/// can't be a singleton to begin with or another singleton of this object already exists, the function will
/// return false. Otherwise, the singleton will gain the current object's id and it will become a singleton.
function add_singleton_object(){
	// First, check if this object can even be a singleton in the first place
	var _key = is_valid_singleton();
	if (_key == undefined) {return false;}
	// Check if the key already contains the object. If so, delete this duplicate. If not, simply add the
	// object's ID into the singleton key/value pair; making it the singleton's object.
	if (instance_exists(global.singletonID[? _key])){
		instance_destroy(self);
		return false;
	}
	ds_map_set(global.singletonID, _key, id);
	return true;
}

/// @description Removes the id value from a given singleton object. If the key cannot be found out of
/// all the valid singleton object indexes, then nothing will happen to any singleton value.
function remove_singleton_object(){
	var _key = is_valid_singleton();
	if (_key != undefined) {ds_map_set(global.singletonID, _key, noone);}
}

/// @description Checks the given object index with a switch statements filled with valid singleton object
/// indexes. If the object matches an index found in the statement, the key will be returned. Otherwise, the
/// function will return undefined and the object is not a singleton.
function is_valid_singleton(){
	switch(object_index){
		case obj_controller:		return CONTROLLER;
		case obj_effect_handler:	return EFFECT_HANDLER;
		case obj_depth_sorter:		return DEPTH_SORTER;
		case obj_textbox:			return TEXTBOX;
		case obj_cutscene:			return CUTSCENE;
		case obj_player:			return PLAYER;
		case obj_control_info:		return CONTROL_INFO;
		default:					return undefined;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// SOUND PLAYBACK FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////

/// @description Plays a sound effect at a variable volume level relative to the setting for the volume of sounds.
/// Optionally, the previous instance of the sound effect can be stopped before playing the current one to prevent
/// any odd overlapping of the same sound, which sounds horrible.
/// @param sound
/// @param volume
/// @param stopPrevious
function play_sound_effect(_sound, _volume, _stopPrevious){
	if (_sound == -1) {return _sound;} // No sound effect was provided; exit the script
	// Stop the previous instance of this sound effect that could still be playing
	if (_stopPrevious && audio_is_playing(_sound)){
		audio_stop_sound(_sound);
	}
	// Plays the sound and sets the volume of it based on the setting and the argument provided
	var _soundID = audio_play_sound(_sound, 0, false);
	audio_sound_gain(_soundID, _volume * get_audio_group_volume(Settings.Sounds), 0);
	// Return the sound's ID value, which is provided by game maker's built-in sound functions
	return _soundID;
}

/// @description An extension of the standard sound effect function that allows the sound to be slowly faded
/// away relative to the distance it is from the audio listener. (player or controller depending on if the
/// player object exists or not) Gives a 3D effect to the audio which is nice.
/// @param sound
/// @param volume
/// @param loopSound
/// @param x
/// @param y
/// @param falloffModel
/// @param falloffRef
/// @param falloffDist
/// @param falloffFactor
function play_sound_effect_ext(_sound, _volume, _loopSound, _x, _y, _falloffModel, _falloffRef, _falloffDist, _falloffFactor){
	if (_sound == -1) {return _sound;} // No sound effect was provided; exit the script
	// Plays the sound with the set parameters for its falloff, how the falloff is calculated, and position
	// for the sound to be emitted from. Also sets the sound's volume based on the game's audio settings.
	audio_falloff_set_model(_falloffModel); // Sets how the sound will falloff relative to its emitting position
	var _soundID = audio_play_sound_at(_sound, _x, _y, 0, _falloffRef, _falloffDist, _falloffFactor, _loopSound, 0);
	audio_sound_gain(_soundID, _volume * get_audio_group_volume(Settings.Sounds), 0);
	return _soundID;
}

/// @description Gets the volume for a group of sounds, which is the ratio of the master volume (Ranges from 
/// 0 to 1) and the ratio of that times the respective sound volume also divided by 100 to make it a range 
/// between 0 and 1, like the master volume above.
/// @param audioGroup
function get_audio_group_volume(_audioGroup){
	var _master = global.settings[Settings.Master] / 100;

	switch(_audioGroup){
		case Settings.Music:	return global.settings[Settings.Music] * _master / 100;
		case Settings.Sounds:	return global.settings[Settings.Sounds] * _master / 100;
		default:				return _master; // No valid group provided, just return the master volume
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// FUNCTIONS FOR WORLD ITEM DATA ///////////////////////////////////////////////////////////////////////////////////////////////

/// @description Initializes all of the items that should exist within the game world on a fresh file. This 
/// includes all of items on every difficulty, and won't be loaded from if an existing save file is loaded.
/// The save file itself will have all of the items in the world that still exist along with the items that
/// the player has dropped from their inventory.
function initialize_world_item_data(){
	// FAILSAFE -- If somehow this function is called before another world item data map isn't cleared from memory, clear out that map beforehand.
	if (ds_exists(global.worldItemData, ds_type_map)) {clear_world_item_data();}
	global.worldItemData = encrypted_json_load("world_item_data", "fTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z$C&F)H@");
}

/// @description Removes all the data from the global world item data ds_map, which means going into each index of the main map
/// and deleting the maps inside before deleting the outer map. Otherwise, a big ass memory leak will eventually happen.
function clear_world_item_data(){
	var _key = ds_map_find_first(global.worldItemData);
	while(!is_undefined(_key)){ // Looping through all the parts on the map that contain the inner item map data
		ds_map_destroy(global.worldItemData[? _key]);
		_key = ds_map_find_next(global.worldItemData, _key);
	}
	ds_map_destroy(global.worldItemData);
	global.worldItemData = -1; // Remove the invalid pointer value
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/// DIFFICULTY INITIALIZATION FUNCTIONS /////////////////////////////////////////////////////////////////////////////////////////

/// @description Initializes the game's difficulty level based on the provided combat difficulty, since the puzzle difficulty doesn't
/// have as much of an impact on the game as the combat difficulty does. 
/// @param combatDifficulty
/// @param puzzleDifficulty
function initialize_difficulty(_combatDifficulty, _puzzleDifficulty){
	// Find the difficulty level and sets up everything related to said difficulty accordingly. (Ex. Player health regeneration,
	// starting items, damage modifiers, etc.) If no difficulty is found, this function will adjust nothing.
	switch(_combatDifficulty){
		case Difficulty.Forgiving:		// Forgiving Difficulty AKA "Easy" Mode
			with(global.gameplay){
				// Store the gameplay difficulty and puzzle difficulty into their respective variables.
				gameplayDifficulty =	_combatDifficulty;
				puzzleDifficulty =		_puzzleDifficulty;
				// Enable player health regeneration; prevent sanity loss; give the player the infinite ammo starting pistol; 
				// apply a 1.5x damage modifier to the player, and a 2.0x modifier to the effectiveness of healing items.
				playerHealthRegen =		true;
				playerStartingPistol =	true;
				playerDamageMod =		1.5;
				healingEffectMod =		2.0;
				// Apply a modifier that causes enemies to only deal out 50% of their potential attack damage.
				enemyDamageMod =		0.5;
			}
			// Set the inventory's starting size as well as its maximum possible size
			global.invSize = 12;
			global.maxInvSize = 20;
			break;
		case Difficulty.Standard:		// Standard Difficulty AKA "Normal" Mode
			with(global.gameplay){
				// Store the gameplay difficulty and puzzle difficulty into their respective variables.
				gameplayDifficulty =	_combatDifficulty;
				puzzleDifficulty =		_puzzleDifficulty;
				// The only variable that needs to be adjusted for standard difficulty is enabling the depletion of the player's
				// sanity value. Nothing else needs to be changed.
				playerLosesSanity =		true;
			}
			// Set the inventory's starting size as well as its maximum possible size
			global.invSize = 8;
			global.maxInvSize = 20;
			break;
		case Difficulty.Punishing:		// Punishing Difficulty AKA "Hard" Mode
			with(global.gameplay){
				// Store the gameplay difficulty and puzzle difficulty into their respective variables.
				gameplayDifficulty =	_combatDifficulty;
				puzzleDifficulty =		_puzzleDifficulty;
				// Adjust the player's damage modifier to 0.75x their normal damage.
				playerDamageMod =		0.75;
				// Adjust the enemy damage modifier so all enemies deal slightly more damage.
				enemyDamageMod =		1.5;
				// Enable the gameplay's limited saves flag, which will enable cassette tapes to be scattered around the world.
				// These tapes are required for saving, so it is heavily limited in this mode.
				limitedSaves =			true;
			}
			// Set the inventory's starting size as well as its maximum possible size
			global.invSize = 8;
			global.maxInvSize = 16;
			break;
		case Difficulty.Nightmare:		// Nightmare Difficulty AKA "Very Hard" Mode, which is an unlockable difficulty
			with(global.gameplay){
				// Store the gameplay difficulty and puzzle difficulty into their respective variables.
				gameplayDifficulty =	_combatDifficulty;
				puzzleDifficulty =		_puzzleDifficulty;
				// Adjust the player's damage modifier to 0.75x their normal damage.
				playerDamageMod =		0.75;
				// Adjust the enemy damage modifier so all enemies deal double their nromal damage.
				enemyDamageMod =		2;
				// Enable limited saves using cassette tapes like in "Punishing" difficulty, but with the added toggle of the
				// player's weapons degrading over time; lower their daamge as the durability inches closer to zero.
				weaponDurability =		true;
				limitedSaves =			true;
			}
			// Set the inventory's starting size as well as its maximum possible size
			global.invSize = 6;
			global.maxInvSize = 12;
			break;
		case Difficulty.OneLifeMode:		// One Life Mode, which is an unlockable difficulty
			with(global.gameplay){
				// Store the gameplay difficulty and puzzle difficulty into their respective variables.
				gameplayDifficulty =	_combatDifficulty;
				puzzleDifficulty =		_puzzleDifficulty;
				// Adjust the player's damage modifier to 0.5x their normal damage.
				playerDamageMod =		0.5;
				// Adjust the enemy damage modifier so all enemies deal double their nromal damage.
				enemyDamageMod =		2;
				// Enable the flag that prevents saving the game in its entirety for this difficulty and another flag that causes
				// a return to title screen when you die, which is the oneLifeMode flag. Also, weapon durability is enabled much 
				// like the previous difficulty.
				weaponDurability =		true;
				preventSaving =			true;
				oneLifeMode =			true;
			}
			// Set the inventory's starting size as well as its maximum possible size
			global.invSize = 6;
			global.maxInvSize = 10;
			break;
	}
	// Finally, after getting the maximum possible size for the inventory relative to the selected difficulty,
	// initialize the array that contains the item information relative to the set maximum size.
	for (var i = 0; i < global.maxInvSize; i++){
		global.invItem[i][0] = NO_ITEM;	// The item's key within the item data map
		global.invItem[i][1] = 0;		// Total number of items currently in the slot
		global.invItem[i][2] = 0;		// The item's durability (Nightmare and One Life Mode only)
		global.invItem[i][3] = false;	// A flag storing if the item is equipped to the player or not
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////