/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Store what the current game state was at the cutscene's creation, which will overwrite any game state
// changes during the cutscene if they somehow occur.
prevGameState = global.gameState;

// Store the current states and previous states for each dynamic entity that existed during the start of 
// the cutscene. These state values will be restored once the cutscene concludes. Also, all dynamic entities
// will have their state set to "NO_STATE" during a cutscene.
prevEntityStates = -1;
var _index, _grid;
_index = 0;
_grid = ds_grid_create(2, instance_number(par_dynamic_entity));
with(par_dynamic_entity){
	_grid[# 0, _index] = id;
	_grid[# 1, _index] = [curState, lastState];
	set_cur_state(NO_STATE);
	_index++;
}
// Place the pointer to the grid in the variable that will also handle its deletion process.
prevEntityStates = _grid;

// A list containing all of the data that the cutscene must execute before ending. The variable just below
// that is the current action within the list of instructions that the cutscene is currently executing. This
// index can be freely moved around to whatever index the cutscene desires; allowing for things like branching
// paths and repeat textboxes, and so on.
sceneData = ds_list_create();
sceneIndex = 0;

// Holds the ID for the cutscene trigger that created this object. Once the cutscene has been successfully
// executed, the trigger will delete itself relative to this object's clean up event IF the flag for the
// trigger has actually been set to the correct state. Otherwise, the trigger will remain active.
parentTrigger = noone;

// A timer used during the cutscene_wait action, or for whenever else a simple timer is needed.
timer = 0;

#endregion

#region SETTING GAME STATE, LOCKING PLAYER MOVEMENT, AND SETTING CONTROL INFORMATION

set_game_state(GameState.Cutscene, true); // Always prioritize the cutscene's state
with(global.singletonID[? PLAYER]) {entity_set_sprite(standSprite, 4);}

with(global.singletonID[? CONTROL_INFO]){
	if (ds_list_size(controlData) > 0) {control_info_clear_all();}
	control_info_add_control_data(ICON_SELECT, RIGHT_ANCHOR, "Next", false);
	control_info_add_control_data(ICON_RETURN, RIGHT_ANCHOR, "Log", true);
	control_info_fade_in(true, [64, 64, 64]);
}

#endregion