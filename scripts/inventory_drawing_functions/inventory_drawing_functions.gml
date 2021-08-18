/// @description 
function inventory_draw_item_section(){
	// Set the alpha for the entire section of code, but don't let anything be drawn when the alpha is set
	// a value of 0. It'll be invisible to the player, and thus a waste to process.
	if (image_alpha <= 0) {return;}
	draw_set_alpha(image_alpha);
	
	// Draw all the background elements/GUI images and textures that are drawn with a fadeaway in any of the
	// four coordinate directions (-x/+x and -y/+y axis). Drawn before any text to prevent the text from
	// apprearing behind the menu's background elements.
	shader_set(fadeawayShader);

	// Background for the player portrait area within the item section of the player's inventory
	shader_set_uniform_f_array(sThreshold, [0, 0, 45, WINDOW_HEIGHT]);
	shader_set_uniform_f_array(sFadeCutoff, [0, 0, 80, WINDOW_HEIGHT]);
	draw_sprite_ext(spr_rectangle, 0, 24, 18, 58, 14, 0, backgroundColor, image_alpha * 0.75);
	draw_sprite_ext(spr_rectangle, 0, 0, 17, 80, 1, 0, c_black, image_alpha);
	draw_sprite_ext(spr_rectangle, 0, 24, 32, 58, 1, 0, c_black, image_alpha);

	shader_reset();
	
	// Drawing the rest of the player's portrait image background, which doesn't use any fancy shaders
	draw_sprite_ext(spr_rectangle, 0, 0, 18, 24, 30, 0, backgroundColor, image_alpha * 0.75);
	draw_sprite_ext(spr_rectangle, 0, 0, 48, 25, 1, 0, c_black, image_alpha);
	draw_sprite_ext(spr_rectangle, 0, 24, 32, 1, 16, 0, c_black, image_alpha);
	
	// 
	draw_sprite_ext(spr_hitpoint_icon, 0, 26, 19, 1, 1, 0, c_white, image_alpha);
	
	// The lines of code that handle the animation for the player's portrait sprite. It's based on the same
	// animation speeds used when the player is animated in-game; just with different variables. The key
	// different is the player's hitpoints corresponds to the speed that the sprite is animated at.
	spriteImageIndex += sprite_get_speed(sprite) / ANIMATION_FPS * spriteImageSpeed * playerHitpointPercentage * global.deltaTime;
	if (spriteImageIndex >= spriteLoopRange[1]) {spriteImageIndex = spriteLoopRange[0];}
	
	// Draw the player's portrait, which animates their downward walking sprite in an endless loop
	draw_sprite_ext(sprite, floor(spriteImageIndex), 11, 42, 1, 1, 0, c_white, image_alpha);
	
	// 
	shader_set(outlineShader);
	shader_set_uniform_i(sDrawOutline, 1);
	
	// Display the player's current hitpoints; abstracted from the true value as four different words to give
	// a general idea of how good/bad the character is doing.
	currentFont = outline_set_font(optionFont, global.fontTextures[? optionFont], sPixelWidth, sPixelHeight, currentFont);
	draw_text(40, 18, playerHitpointString + "%");

	/*draw_sprite_ext(spr_rectangle, 0, 5, 136, 120, 1, 0, c_black, image_alpha);
	
	shader_set(fadeawayShader);

	shader_set_uniform_f_array(sThreshold, [0, 0, 160, WINDOW_HEIGHT]);
	shader_set_uniform_f_array(sFadeCutoff, [0, 0, 240, WINDOW_HEIGHT]);
	draw_sprite_ext(spr_rectangle, 0, 0, 121, 240, 45, 0, backgroundColor, image_alpha * 0.75);
	draw_sprite_ext(spr_rectangle, 0, 0, 120, 240, 1, 0, c_black, image_alpha);
	
	shader_set_uniform_f_array(sThreshold, [0, 0, 88, WINDOW_HEIGHT]);
	shader_set_uniform_f_array(sFadeCutoff, [0, 0, 110, WINDOW_HEIGHT]);
	draw_sprite_ext(spr_rectangle, 0, 0, 14, 110, 106, 0, backgroundColor, image_alpha * 0.75);

	shader_reset();

	// Drawing the rectangles for the inventory slots, and the item's images that go inside said rectangles.
	// The item's image will be slightly highlighted white when highlighted, and green/red when selected or
	// an auxillary selection.
	var _rectAlpha, _rectColor, _outlineColor, _curOption;
	_rectAlpha = 1;
	_rectColor = c_dkgray;
	_outlineColor = c_black;
	for (var yy = 0; yy < menuDimensions[Y]; yy++){
		for (var xx = 0; xx < menuDimensions[X]; xx++){
			_curOption = (menuDimensions[X] * yy) + xx; // Gets the option's true index within the menu based on its width
			
			// Exit the loop if the number of options has been surpassed
			if (_curOption >= numOptions) {break;}
			
			// Select the correct combo of colors for the item icon's rectangle outline
			_rectAlpha = 1;
			if (_curOption == selectedOption){ // The item has been selected by the player
				_rectColor = optionSelectedColor;
				_outlineColor = optionRectSelectedOutlineColor;
			} else if (_curOption == auxSelectedOption){ // The item was selected by the player and stored for later use
				_rectColor = optionAuxSelectedColor;
				_outlineColor = optionRectAuxSelectedOutlineColor;
			} else if (_curOption == curOption){ // The item is being highlighted by the player
				_rectColor = optionHighlightColor;
				_outlineColor = optionRectHighlightOutlineColor;
			} else{ // The option isn't highlighted or selected; it's just visible
				_rectAlpha = 0.5;
				_rectColor = c_dkgray;
				_outlineColor = c_black;
			}
			
			// Finally, draw the outline with the color corresponding to the menu's cursor and selections
			draw_rect_outline(optionPos[X] + (xx * optionSpacing[X]), optionPos[Y] + (yy * optionSpacing[Y]), 18, 18, _rectColor, _outlineColor, _rectAlpha * image_alpha, image_alpha);
			// TODO -- Draw the item's sprite at the same position as the outline rectangle
		}
	}

	// Drawing all the required text for the section between the outline shader's initialization and reset
	shader_set(outlineShader);
	shader_set_uniform_i(sDrawOutline, 1);

	// Draw the current option's name only above the information about the item. Also, draw the total number
	// of items found in the highlighted slot next to said name. This is because the inventory is actually
	// made up of a grid of icons instead of just text like most menus.
	currentFont = outline_set_font(optionFont, global.fontTextures[? optionFont], sPixelWidth, sPixelHeight, currentFont);
	if (curOption == selectedOption) {currentOutlineColor = outline_set_color(optionSelectedColor, optionSelectedOutlineColor, sOutlineColor, currentOutlineColor);}
	else {currentOutlineColor = outline_set_color(optionHighlightColor, optionHighlightOutlineColor, sOutlineColor, currentOutlineColor);}
	
	var _name, _optionWidth, _isWeapon;
	_name = option[| curOption].option;
	_optionWidth = string_width(_name);
	draw_text(infoPos[X] + 5, infoPos[Y] - 18, _name);
	
	// Only draw the quantity and the item's description if an item actually exists within the highlighted slot
	if (_name != NO_ITEM){
		// This line should change the font to font_gui_small, so the total quantity will go right after that
		menu_draw_option_info();
		// The item quantity won't show up for weapon and items that cannot be stacked
		if (global.itemData[? ITEM_LIST][? _name][? MAX_STACK] > 1){
			_isWeapon = (string_count(WEAPON, global.itemData[? ITEM_LIST][? _name][? ITEM_TYPE]) == 1);
			if (!_isWeapon) {draw_text(infoPos[X] + _optionWidth + 10, infoPos[Y] - 14, "x" + string(global.invItem[curOption][1]));}	
		}
	}
	
	// Loop through and draw the quantities for each item above the icon of the item itself; white if the 
	// stack isn't full, and bright green if it is a full stack of items.
	currentFont = outline_set_font(infoFont, global.fontTextures[? infoFont], sPixelWidth, sPixelHeight, currentFont);
	draw_set_halign(fa_right);
	for (var yy = 0; yy < menuDimensions[Y]; yy++){
		for (var xx = 0; xx < menuDimensions[X]; xx++){
			_curOption = (menuDimensions[X] * yy) + xx; // Gets the option's true index within the menu based on its width
			_name = global.invItem[_curOption][0];
			
			// Skip to the next item in the inventory if the current slot is empty OR it's stack size is 1
			// and it's not the grenade launcher, which is the only weapon that has an exception to display 
			// the stack on top of the icon.
			if (_name == NO_ITEM || (global.itemData[? ITEM_LIST][? _name][? MAX_STACK] == 1 && _name != GRENADE_LAUNCHER)) {continue;}
			
			if (global.invItem[_curOption][1] == global.itemData[? ITEM_LIST][? _name][? MAX_STACK]){ // Highlight the stack quantity green to signify it is full
				currentOutlineColor = outline_set_color(optionSelectedColor, optionSelectedOutlineColor, sOutlineColor, currentOutlineColor);
			} else{ // The stack isn't currently filled; use the default option text colors (white/gray)
				currentOutlineColor = outline_set_color(optionColor, optionOutlineColor, sOutlineColor, currentOutlineColor);
			}
			draw_text(optionPos[X] + 19 + (xx * optionSpacing[X]), optionPos[Y] + 12 + (yy * optionSpacing[Y]), string(global.invItem[_curOption][1]));
		}
	}
	draw_set_halign(fa_left);*/
	
	// Reset both the outline color that's being used and the outline shader
	currentOutlineColor = [0, 0, 0];
	shader_reset();
}

/// @description
function inventory_draw_note_section(){
	draw_set_font(font_gui_large);
	draw_set_color(c_white);
	draw_text(25, 25, "NOTE SECTION");
}

/// @description
function inventory_draw_map_section(){
	draw_set_font(font_gui_large);
	draw_set_color(c_white);
	draw_text(25, 25, "MAP SECTION");
}