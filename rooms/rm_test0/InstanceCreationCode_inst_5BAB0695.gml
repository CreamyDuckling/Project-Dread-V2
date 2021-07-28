// Set the position the play will be sent to, the room they will be warped to, and the indicator image
targetX = 136;
targetY = 54;
targetRoom = rm_test0;
indicatorIndex = INDEX_SOUTH;

// Set the sound effects to be played when the door is locked, opened, or closed
doorLockedSound = snd_door_locked0;
doorUnlockSound = snd_door_unlocked0;

// Finally, add the required keys for the door to be unlocked to the list of needed keys and the 
// event index for the locked door itself, which toggles true once it's been unlocked.
ds_list_add(requiredKeys, HANDGUN_AMMO);
ds_list_add(requiredKeys, HANDGUN_AMMO);
eventFlagIndex = add_event_flag("Test_3");