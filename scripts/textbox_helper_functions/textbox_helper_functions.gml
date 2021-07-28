/// @description Adds textbox data to the end of the ds_list of said data. The text MUST be formatted during
/// or before passing it into this function because no formatting occurs within the function.
/// @param text
/// @param actor
/// @param imageIndex
function add_textbox_data(_text, _actor, _imageIndex){
	ds_list_add(textboxData, [_text, _actor, _imageIndex]);
	if (ds_list_size(textboxData) == 1){ // Sets the final character to take into account the code in the text.
		var _index = string_last_pos("~", textboxData[| 0][0]);
		finalCharacter = _index == 0 ? string_length(textboxData[| 0][0]) : _index - 1;
		// Fade in the control prompt information if is hasn't been faded in already. Also, set the proper 
		// color to match the current textbox color.
		with(global.singletonID[? CONTROL_INFO]){
			var _color = get_actor_data(_actor).textboxColor; // Stores into a temporary variable for improved readability
			control_info_fade_in(true, [color_get_red(_color) / 4, color_get_green(_color) / 4, color_get_blue(_color) / 4]);
		}
	}
}

/// @description Attempts to parse the data found at the end of the textbox's text data. This data is formatted
/// by typing a "~" character, and anything after that will be checked as a code or numerical index value. It
/// allows a textbox to jump to whatever index necessary for the event/dialog.
function open_next_textbox(){
	// Before moving onto the next index, the code that points to said index needs to be found inside of
	// the current text's string data, and than parsed based on the resulting code/number.
	var _codeIndex = string_last_pos("~", textboxData[| textboxIndex][0]);
	if (_codeIndex == 0){ // No code for the next textbox index could be found; move onto the next available index
		textboxIndex++;
	} else{
		// If the code was found (The test after the "~" character) it will be parsed and move to the desired
		// index. If no valid index was found, the textbox object will be deleted -- signifying an error.
		textboxCode = string_copy(textboxData[| textboxIndex][0], _codeIndex + 1, 10);
		if (textboxCode == "next"){ // Moves to the next available textbox
			textboxIndex++;
		} else if (textboxCode == "end"){ // Causes the textbox to close after the textbox
			isClosing = true;
			return; // Exit the script early
		} else{ // It must be a numerical index, attempt to parse that number from the remaining string.
			var _index = real(string_digits(textboxCode));
			textboxIndex = clamp(_index, 0, ds_list_size(textboxData) - 1);
		}
	}
	
	// If the next index is at the end of the list of data; set the textbox to close and delete itself.
	if (textboxIndex >= ds_list_size(textboxData)){
		textboxIndex = ds_list_size(textboxData) - 1;
		textboxCode = "end";
		isClosing = true;
		// Fade away the control information data if the textbox is in control of the control information.
		if (commandControlInfoObject){
			with(global.singletonID[? CONTROL_INFO]) {control_info_fade_away();}
		}
		return; // Exit the script early
	}
	
	// Fades over to the next color for the textbox if the current color for the control prompt doesn't 
	// match the new color for the coming textbox.
	if (commandControlInfoObject){
		var _color = actorData[? textboxData[| textboxIndex][1]].textboxColor;
		with(global.singletonID[? CONTROL_INFO]){
			if (backgroundColor != _color) {control_info_fade_in(false, [color_get_red(_color) / 4, color_get_green(_color) / 4, color_get_blue(_color) / 4]);}
		}
	}
	
	// Check if a code exists for the next textbox. If so, the final character will be set the character
	// right before that character index. Otherwise, it sets it to the last string in the text.
	var _index = string_last_pos("~", textboxData[| textboxIndex][0]);
	finalCharacter = _index == 0 ? string_length(textboxData[| textboxIndex][0]) : _index - 1;
	// Finally, reset the variables needed for the typewriter effect to function.
	visibleText = "";
	nextCharacter = 0;
	textboxSoundTimer = 0;
}

/// @description Attempts to add an actor's data to the map of actors for the current textboxes. However, if
/// the actor's data already exists within the map, no actor data will be searched for or added and this
/// function will essentially do nothing.
/// @param actor
function add_actor_data(_actor){
	var _existingActor = ds_map_find_value(actorData, _actor);
	if (is_undefined(_existingActor)){ // Only add new data to the map if is a new actor struct
		var _newActor = get_actor_data(_actor);
		ds_map_add(actorData, _actor, _newActor);
	}
}

/// @description Fetches the struct containing data about the actor based on the index provided. The struct
/// contains data about the textbox sprite that's used, the namespace's sprite, the color of both of those
/// textboxes, the portrait sprite index for the actor, and their first and last names.
/// @param actor
function get_actor_data(_actor){
	// This variable will either store the value noone (-4) or a pointer to the struct created by the
	// name provided in the function's argument value.
	var _data = noone;
	// The variables that can exist within the _data struct include:
	//
	//			firstName			--		string
	//			textboxColor		--		color
	//			textboxSprite		--		sprite_index
	//			namespaceSprite		--		sprite_index
	//			portraitSprite		--		sprite_index
	//
	
	// Go through the list of possible actor indexes to find the one taht needs to be returned
	switch(_actor){
		case Actor.Claire: // The main character's actor data
			_data = {
				firstName : "Claire",
				textboxColor : make_color_rgb(110, 0, 204),
				textboxSprite : spr_textbox0,
				namespaceSprite : spr_textbox0_namespace,
				portraitSprite : spr_claire_portraits
			}
			break;
		case Actor.Unknown: // An unknown/unseen actor's data
			_data = {
				firstName : "???",
				textboxColor : make_color_rgb(110, 110, 110),
				textboxSprite : spr_textbox0,
				namespaceSprite : spr_textbox0_namespace,
				portraitSprite : -1
			}
			break;
		default: // The default actor data (No specified actor)
			_data = {
				firstName : "NoActor",
				textboxColor : make_color_rgb(0, 0, 188),
				textboxSprite : spr_textbox0,
				namespaceSprite : -1,
				portraitSprite : -1
			}
			break;
	}
	
	// Finaly, either return the struct data or a -4, which signifies no struct was successfully created
	return _data;
}