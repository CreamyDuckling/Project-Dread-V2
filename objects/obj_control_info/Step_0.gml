/// @description Handle Alpha Values/Shifting the Color of the Background to Match its Target RGB Values

// 
if (!overrideAlpha){
	alpha += (alphaTarget - alpha) * alphaSpeed * global.deltaTime;
	// 
	if (alpha > 1){alpha = 1;}
	else if (alpha < 0){alpha = 0;}
}

// 
for (var i = 0; i < 3; i++) {backgroundColorRGB[i] += (backgroundColorRGB[i + 3] - backgroundColorRGB[i]) / 5 * global.deltaTime;}
backgroundColor = make_color_rgb(backgroundColorRGB[0], backgroundColorRGB[1], backgroundColorRGB[2]);