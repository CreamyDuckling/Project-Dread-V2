/// @description Variable Initialization

// Add the object as a singleton to prevent duplicates. If it fails, exit the create event early.
if (!add_singleton_object()) {return;}

#region EDITING INHERITED VARIABLES

image_index = 0;
image_alpha = 0;
image_speed = 0;

#endregion

#region UNIQUE VARIABLE INITIALIZATION

// Holds the index for the shader used for outlining the text
outlineShader = shd_outline;
// Getting the uniforms for the shader; storing them in local variables
sPixelWidth = shader_get_uniform(outlineShader, "pixelWidth");
sPixelHeight = shader_get_uniform(outlineShader, "pixelHeight");
sOutlineColor = shader_get_uniform(outlineShader, "outlineColor");
sDrawOutline = shader_get_uniform(outlineShader, "drawOutline");

// Stores the currently used font for this object,which prevents unnecessary batch breaks whenever the 
// outline shader is being utilized.
currentFont = -1;

// 
leftAnchor = [5, WINDOW_HEIGHT - 10];
rightAnchor = [WINDOW_WIDTH - 5, WINDOW_HEIGHT - 10];

// Stores the structs that contain the data for the control; what it does, and the helping text that's next
// to it to tell the user what that key/button does upon activation. They don't actually store the icons,
// since what the controls are is handled by a global map that swaps over from keyboard icons to controller
// icons automatically.
controlData = ds_list_create();

// Controls the visibility of the control information on the screen. It allows an independent fading animation
// from whatever menus are using the control info object currently; which allows more flexibility with how the
// menus are animated since they don't have to take the control prompt stuff into account.
alpha = 0;
alphaTarget = 0;
alphaSpeed = 0.2;

// A flag that allows the alpha for the control prompt to be handled by another object entirely, which allows
// for the syncing of the fading in and out of control information to match the current piece of UI or menu
// that has control over the transparency level of the control information.
overrideAlpha = false;

// 
backgroundColorRGB = [0, 0, 0, 0, 0, 0];
backgroundColor = c_black;

#endregion