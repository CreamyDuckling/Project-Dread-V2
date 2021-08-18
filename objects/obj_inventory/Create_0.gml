/// @description Variable Initialization

#region EDITING INHERITED VARIABLES

// Call the parent menu's create event to initialize all the default variables
event_inherited();
// Initialize the general menu variables, but the menu's width, height, and scroll offsets will actually be
// determined by the curretn section of the menu that is opened currently.
menu_general_initialize(true, 1, 1, 1, 0, 0, 30, 0.4);
// Initialize the menu's title, options, and option information variables, but don't actually place any data
// inside of the initialized data structures; as that is handled by the function to open a specific section
// of the player's inventory. (Can be either map, items, or notes)
menu_title_initialize("", 5, 0, fa_left, fa_top, font_gui_medium);
menu_options_initialize(0, 0, fa_left, fa_top, 0, 0, font_gui_medium);
menu_option_info_initialize(5, 140, fa_left, fa_top, 240, true, font_gui_small); // Option info only used by item section

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// 
lastSectionOption = array_create(MAP_SECTION + 1, 0);
curSection = 0;

// 
drawFunction = NO_SCRIPT;

// 
backgroundColor = make_color_rgb(32, 32, 32);

// 
//optionRectHighlightOutlineColor = make_color_rgb(127, 114, 63);
//optionRectSelectedOutlineColor = make_color_rgb(91, 127, 0);
//optionRectAuxSelectedOutlineColor = make_color_rgb(127, 0, 0);

// ITEM SECTION VARIABLES ///////////////////////////////////////////////////////////////////////////////////

// 
sprite = spr_claire_unarmed_walk;
spriteLoopRange = [12, 16];
spriteImageIndex = spriteLoopRange[0];
spriteImageSpeed = 1;

// 
var _hitpoints = 0;
with(global.singletonID[? PLAYER]) {_hitpoints = hitpoints / maxHitpoints;}
playerHitpointPercentage = _hitpoints;
playerHitpointString = number_format(floor(_hitpoints * 100), "000");

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endregion

#region EDITING VISIBLE CONTROL INFORMATION

// 
with(global.singletonID[? CONTROL_INFO]){
	control_info_add_control_data(ICON_AUX_MENU_LEFT, LEFT_ANCHOR, "", false);
	control_info_add_control_data(ICON_AUX_MENU_RIGHT, LEFT_ANCHOR, "Change Section", true);
	control_info_fade_in(false, [64, 64, 64]);
	alpha = 1;
}

#endregion