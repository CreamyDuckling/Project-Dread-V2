/// @description Stores the Required Weight for the Switch to Trigger

#region EDITING INHERITED VARIABLES

image_index = 0;
image_speed = 0;
visible = false;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Two important variables for how the switch will function in the game's code. Basically, each floor switch
// is assigned 
eventFlagKey = -1;
requiredWeight = 0;

// A flag that allows a given floor switch to be deactivated or activated; useful for things like disabling
// power of a given area, which prevents switches from working, for example.
isActive = true;

#endregion