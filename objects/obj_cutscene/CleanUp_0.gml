/// @description Cleaning Up Allocated Memory and Other Data

// Don't clean up uninitialized data if the cutscene object was a duplicate of the existing singleton
if (global.singletonID[? CUTSCENE] != id) {return;}

// Remove this id value from the cutscene singleton; allowing another instance of obj_cutscene to take its place
remove_singleton_object();

// Fades away the control information as normal gameplay has been resumed.
with(global.singletonID[? CONTROL_INFO]) {control_info_fade_away();}

// Return all entities back to their previous states and delete the storage grid.
var _length, _states;
_length = ds_grid_height(prevEntityStates);
for (var i = 0; i < _length; i++){
	_states = prevEntityStates[# 1, i];
	with(prevEntityStates[# 0, i]){
		curState = _states[0];
		lastState = _states[1];
	}
}
ds_grid_destroy(prevEntityStates);

// Checks if the trigger's flag has been set and it isn't the index of -1 -- which means the cutscene trigger
// will never be deleted -- and deletes the trigger object if the event flag was set to the required state.
with(parentTrigger){
	if (get_event_flag(eventFlagKey)) {instance_destroy(self);}
}
parentTrigger = noone;

// Return to the state the game was in when the cutscene object was created. Also, move the camera back to
// the player object if it isn't already following the player at the end of the cutscene instructions.
set_game_state(prevGameState, true);
with(global.singletonID[? CONTROLLER]) {camera_set_cur_object(global.singletonID[? PLAYER], 0.5, false);}