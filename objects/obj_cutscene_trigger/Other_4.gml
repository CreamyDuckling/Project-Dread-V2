/// @description Check For Partner Event Flag or Required Event Flags

// The event that this trigger is responsible for has already be set, delete the object
if (get_event_flag(eventFlagKey) == eventFlagRequiredState){
	instance_destroy(self);
	return; // Exit out of the event early
}

// Loops through all the required flags and deletes this trigger is any of the flags return false
var _length = ds_list_size(requiredFlags);
for (var i = 0; i < _length; i++){
	if (!get_event_flag(requiredFlags[| i])){
		instance_destroy(self);
		return; // Exit out of the event early
	}
}

// Place the cutscene close function at the end of the scene data list
ds_list_add(sceneData, [cutscene_close, 0.1]);