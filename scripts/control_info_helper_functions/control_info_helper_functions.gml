/// @description A single function call that tells the control information propmt object to fade away into
/// transparency once again, since it's not useful when menu inputs aren't necessary, but the object iself
/// will always exist in memory since menu inputs can be needed at any given momvment of gameplay.
function control_info_fade_away(){
	alphaTarget = 0; // Fading away should always make the control information transparent to the player
	// Since the control information is fading away, the background color should be reset to its default,
	// which is black or [0, 0, 0] in RGB color coding. The last three indexes store said RGB values.
	backgroundColorRGB[3] = 0;
	backgroundColorRGB[4] = 0;
	backgroundColorRGB[5] = 0;
}

/// @description A simple function that fades the control information into visiblity to convey menu inputs
/// for the player to use to navigate the menu, and so on. The alpha isn't controlable since it will always
/// need to be set to 1, but the color can be set to whatever color is needed to match the current menu's UI.
/// @param setAlpha
/// @param targetColor[r/g/b]
function control_info_fade_in(_setAlpha, _targetColor){
	if (_setAlpha) {alphaTarget = 1;} // Fading in should always make the control information full visible
	// The backgroundColorRGB array's last three indexes contain the target values for the actual background's
	// RGB values, which are then stored as a color in the backgroundColor variable for use in drawing.
	backgroundColorRGB[3] = _targetColor[0];
	backgroundColorRGB[4] = _targetColor[1];
	backgroundColorRGB[5] = _targetColor[2];
}