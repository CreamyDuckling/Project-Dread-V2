/// @description Cleaning Up Data Structures and Moving to New Menu/Returning to Gameplay

// First, check if another menu needs to be created during this one's deletion
if (nextMenu != noone) {instance_create_depth(0, 0, ENTITY_DEPTH, nextMenu);}

// Clears out and deletes all options and their struct data from memory
menu_option_clear();

// If this isn't the primary menu, don't execute any of the code below
if (!primaryMenu) {return;}

// Reset the alpha override for the control information object
with(global.singletonID[? CONTROL_INFO]){
	overrideAlpha = false;
	alpha = 0; // FOR TESTING
}

// Make sure to return the game to its previous state.
set_game_state(global.prevGameState, true);

// Finally, delete the map that stores all the entity states and restore said states back to each entity. It
// will only attempt to do so for entities that have a matching ID value; in case new entities were created
// curing this menu's existence.
var _entityStates = entityStates;
with(par_dynamic_entity){
	if (!is_undefined(_entityStates[? id])){
		curState = _entityStates[? id][0];
		lastState = _entityStates[? id][1];
		ds_map_delete(_entityStates, id);
	}
}
ds_map_destroy(entityStates);

// Finally, unblur the background image since a primary menu was closed
with(global.singletonID[? EFFECT_HANDLER]) {blurEnabled = false;}