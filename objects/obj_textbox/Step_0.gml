/// @description Updating Textbox Information/Handling Input

#region CHECKING INPUT FROM PLAYER

// Gets input from the currently active control method (Keyboard/Gamepads supported)
if (!global.gamepadActive) {keyAdvance = keyboard_check_pressed(global.settings[Settings.Interact]);}
else {keyAdvance = gamepad_button_check_pressed(global.gamepadID, global.settings[Settings.InteractGP]);}

#endregion

#region OPENING AND CLOSING ANIMATION

// Moves the textbox towards its target; which is faster the further away it is from the target
y += ((yTarget - y) / 5) * global.deltaTime;
// Handling the visiblity of the textbox
if (!isClosing){ // Fades the textbox into visiblity
	alpha += alphaSpeed * global.deltaTime;
	if (alpha > 1) {alpha = 1;}
	else {return;} // Doesn't allow text scrolling until fade is completed
} else{ // Fades the textbox out
	alpha -= alphaSpeed * global.deltaTime;
	if (alpha < 0){ // Switching from the currently visible textbox to the next one
		if (textboxCode != "end") {open_next_textbox();}
		else {instance_destroy(self);}
		// Finally, reset the flag for the animation and the position of the textbox
		y = WINDOW_HEIGHT + 10;
		isClosing = false;
	}
	// Don't allow input when the textbox is "closing"
	return;
}

#endregion

#region HANDLING INPUT/UPDATING TEXTBOX/UPDATING COLORS

// Advancing the text/skipping the typewriter effect
if (keyAdvance){
	if (nextCharacter > 4 && nextCharacter < finalCharacter){ // Display the entire string at once, skipping the animation
		nextCharacter = finalCharacter;
	} else if (nextCharacter >= finalCharacter){ // Starts the "closing" transition to move onto the next textbox if the actor is different; changes to next chunk of data if not
		var _nextActor = ds_list_find_value(textboxData, textboxIndex + 1);
		if (is_undefined(_nextActor) || textboxData[| textboxIndex][1] != _nextActor){
			open_next_textbox();
		} else{ // The actor isn't the same; start the transition to the next textbox
			isClosing = true;
		}
	}
}

// Makes the "text fully visible" indicator move up and down
indicatorOffset += indicatorSpeed * global.deltaTime;
if (indicatorOffset >= 2) {indicatorOffset = 0;}

// Updating the currently visible portion of the text based on current set text speed
if (nextCharacter <= finalCharacter){
	nextCharacter += global.settings[Settings.TextSpeed] * global.deltaTime;
	visibleText = string_copy(textboxData[| textboxIndex][0], 1, nextCharacter);
	// Play the text crawl's sound effect at a set speed interval
	textboxSoundTimer -= global.deltaTime;
	if (textboxSoundTimer < 0){
		textboxSoundID = play_sound_effect(snd_ui_textbox_scroll, 0.15, true);
		textboxSoundTimer += textboxSoundSpeed;
	}
}

#endregion