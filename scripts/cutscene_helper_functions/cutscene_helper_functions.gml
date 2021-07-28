/// @description Ends the current action and moves onto the next immediate instruction. If the index for the
/// next instruction is greater than the number of available instructions, the cutscene has completed its
/// execution and should be ended.
function cutscene_end_action(){
	sceneIndex++;
	if (sceneIndex >= ds_list_size(sceneData)) {instance_destroy(self);}
}

/// @description Moves the instructions for the cutscene ahead to a certain index or behind to a certain
/// index. This is useful whenever a certain chunk of instructions needs to be repeated until the player
/// inputs the correct command, or for skipping a large portion of the cutscene if a certain flag isn't
/// set in the event flags, and so on.
/// @param index
function cutscene_jump_to_action(_index){
	if (_index < 0 || _index >= ds_list_size(sceneData)){
		instance_destroy(self);
		return; // An invalid index was provided, so the cutscene will just end prematurely
	}
	sceneIndex = _index;
}

/// @description A simple checking action that allows a cutscene to have multiple branches within the list of
/// instructions. It has a flag index to check and a required state for that flag to be in order for the check
/// to be considered a success. Then, it will jump to the index for the successful branch or jump to the index
/// for the failure branch as needed.
/// @param flagIndex
/// @param requiredState
/// @param successIndex
/// @param failureIndex
function cutscene_branch_action(_flagIndex, _requiredState, _successIndex, _failureIndex){
	if (get_event_flag(_flagIndex) == _requiredState) {cutscene_jump_to_action(_successIndex);}
	else {cutscene_jump_to_action(_failureIndex);}
}

/// @description Sets a given flag to the provided state, which can be either true or false and then moves
/// onto the next instruction within the cutscene to execute.
/// @param flagKey
/// @param flagState
function cutscene_set_flag(_flagKey, _flagState){
	set_event_flag(_flagKey, _flagState);
	cutscene_end_action();
}

/// @description Ends the cutscene at the current instruction index. This allows for branching paths to 
/// actually have different outcomes instead of both having to go to the end of the instruction list.
function cutscene_end_early(){
	instance_destroy(self);
}