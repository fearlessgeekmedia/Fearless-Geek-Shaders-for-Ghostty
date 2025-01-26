void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalize pixel coordinates
    vec2 uv = fragCoord / iResolution.xy;

    // Get the video frame as a texture (use iChannel0 for the video texture)
    vec4 videoColor = texture(iChannel0, uv);

    // Film grain noise: create a static-like effect
    float grain = fract(sin(uv.x * 12.9898 + uv.y * 78.233 + iTime * 0.2) * 43758.5453123);
    grain = smoothstep(0.0, 1.0, grain); // Smooth the grain

    // Adding a grainy effect to the video texture
    videoColor.rgb += grain * 0.05; // Adjust the grain intensity (0.05 is subtle)

    // Horizontal scratches: simulate horizontal lines across the screen
    float scratches = smoothstep(0.0, 1.0, sin(uv.y * 100.0 + iTime * 5.0) * 0.5 + 0.5);
    scratches = pow(scratches, 3.0); // Sharpen the scratches for a more defined look

    // Add scratches to the image (lighten or darken based on the scratch intensity)
    videoColor.rgb *= 1.0 - scratches * 0.3;

    // Slight random flicker to simulate light exposure inconsistencies (flicker noise)
    float flickerTime = iTime * 0.1;
    float flickerNoise = fract(sin(uv.x * 12.9898 + uv.y * 78.233 + flickerTime) * 43758.5453123);
    flickerNoise = smoothstep(0.0, 1.0, flickerNoise * 5.0); // Flicker intensity

    // Apply flicker effect to video brightness
    videoColor.rgb *= flickerNoise;

    // Set the alpha channel for transparency (optional)
    float alpha = 1.0; // Fully opaque for the scratched effect
    fragColor = vec4(videoColor.rgb, alpha);
}

