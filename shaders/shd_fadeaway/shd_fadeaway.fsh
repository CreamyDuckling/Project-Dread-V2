//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

uniform vec4 threshold;	 // x = left-sided threshold, y = top-sided threshold, z = right-sided threshold, w = bottom-sided threshold
uniform vec4 fadeCutoff; // Variables coorespond to the same directions as the "threshold" variable above

void main() {
	vec4 baseColor = texture2D( gm_BaseTexture, v_vTexcoord );
	// All the calculations are based on the texture's base alpha values, and not a value of 1 explicitly
	float alpha = baseColor.a;
	
	// If the texture's coordinates are completely out of the bounds of the fadeaway; just don't bother drawing the pixel.
	if (v_vPosition.x < fadeCutoff.x || v_vPosition.y < fadeCutoff.y || v_vPosition.x > fadeCutoff.z || v_vPosition.y > fadeCutoff.w){
		gl_FragColor = vec4(0.0);
		return;
	}
	
	// Fading away the texture on the x-axis
	if (v_vPosition.x <= threshold.x){ // Left-sided fading
		alpha *= (v_vPosition.x - fadeCutoff.x) / (threshold.x - fadeCutoff.x);
	} else if (v_vPosition.x >= threshold.z){ // Right-sided fading
		alpha *= (fadeCutoff.z - v_vPosition.x) / (fadeCutoff.z - threshold.z);
	}
	
	// Fading away the texture on the y-axis
	if (v_vPosition.y <= threshold.y){ // Top-sided fading
		alpha *= (v_vPosition.y - fadeCutoff.y) / (threshold.y - fadeCutoff.y);
	} else if (v_vPosition.y >= threshold.w){ // Bottom-sided fading
		alpha *= (fadeCutoff.w - v_vPosition.y) / (fadeCutoff.w - threshold.w);
	}
	
    gl_FragColor = v_vColour * vec4(baseColor.rgb, alpha);
}
