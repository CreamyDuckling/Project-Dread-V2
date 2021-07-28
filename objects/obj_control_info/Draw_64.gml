/// @description Display All Current Control Information

// Doesn't bother drawing anything if no information is currently available, which is stored in the variable
// below and used in the loops throughout the block of code.
var _length = ds_list_size(controlData);
if (_length == 0 || alpha <= 0) {return;} // Don't waste time drawing if no control data exists or it's invisible

// Draws the background that the controller information will be placed on top of, which allows for slightly
// easier readability for the text and control icons.
draw_sprite_ext(spr_rectangle, 0, 0, WINDOW_HEIGHT - 14, WINDOW_WIDTH, 1, 0, c_black, alpha);
draw_sprite_general(spr_rectangle, 0, 0, 0, 1, 1, 0, WINDOW_HEIGHT - 13, WINDOW_WIDTH, 13, 0, backgroundColor, backgroundColor, c_black, c_black, alpha * 0.75);

// Set the text and icon to the correct alpha value and then also initialize the shader that draws outlines
// and enabled the flag that allows the outline shader to actually do its thing.
draw_set_alpha(alpha);
shader_set(outlineShader);
shader_set_uniform_i(sDrawOutline, 1);

// Sets the color for the outline and the font that is also used for all control information.
outline_set_color(c_white, [0.5, 0.5, 0.5], sOutlineColor, -1);
currentFont = outline_set_font(font_gui_small, global.fontTextures[? font_gui_small], sPixelWidth, sPixelHeight, currentFont);

// Loops through all the current control data and displays the text with the outline shader providing a nice
// outline around said text. The positions are all pre-calculated and the only thing that needs to be done
// is the alignment of said position relative to how and where the text is drawn on the screen.
for (var i = 0; i < _length; i++){
	with(controlData[| i]){ // Draws the text at the calculated position with the correct alignment
		if (anchor == RIGHT_ANCHOR) {draw_set_halign(fa_right);}
		else if (anchor == LEFT_ANCHOR) {draw_set_halign(fa_left);}
		draw_text(textPos[X], textPos[Y], infoText);
	}
}
draw_set_halign(fa_left);

// Ensures the outline shader isn't active when drawing the icon sprites below here, which would look awful.
shader_reset();

// Like stated above, the outline shader is disabled for this portion of the code that is responsible for
// drawing sprites for the control input bindings. 
var _data;
for (var i = 0; i < _length; i++) {
	with(controlData[| i]){ // Draws the control's icon at the calculated position relative to its anchor
		_data = global.controlIcons[? iconKey];
		if (anchor == RIGHT_ANCHOR) {draw_sprite(_data[0], _data[1], sprPos[X] - sprite_get_width(_data[0]), sprPos[Y]);}
		else if (anchor == LEFT_ANCHOR) {draw_sprite(_data[0], _data[1], sprPos[X], sprPos[Y]);}
	}
}