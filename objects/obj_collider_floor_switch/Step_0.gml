/// @description Checking for Collision With Movable Objects

// Don't allow collision checks to even occur if the switch isn't active OR a valid index hasn't been 
// set in the object's creation code yet.
if (!isActive || eventFlagKey == -1) {return;}

// Stores the instance ID of a movable object that has collided with the floor switch, and also gets 
// the event flag's state for later checks.
var _object, _flagState;
_object = instance_place(x, y, par_movable_object);
_flagState = get_event_flag(eventFlagKey);

// Sets the event flag based on how the collision occurred; whether it is colliding with an object that
// meets the weight requirements or if no movable object has collided with the switch, which deactivates
// the switch and reset the event flag's state.
if (!_flagState && _object != noone && _object.weight >= requiredWeight){
	show_debug_message("FLAG SET");
	set_event_flag(eventFlagKey, true);
	// TODO -- Play switch activation sound here
} else if (_flagState && _object == noone){
	set_event_flag(eventFlagKey, false);
	// TODO -- Play switch deactivation sound here
}