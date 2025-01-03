void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalize pixel coordinates
    vec2 uv = fragCoord / iResolution.xy;

    // Get the video frame as a texture (use iChannel0 for the video texture)
    vec4 videoColor = texture(iChannel0, uv);

    // Animate the noise by adding time-based variation
    float time = iTime * 0.1;  // Scale time for slower animation
    float noise = fract(sin(uv.x * 12.9898 + uv.y * 78.233 + time) * 43758.5453123);

    // Darken the noise effect by scaling it down
    float darkenedNoise = noise * 0.1;

    // Set the alpha channel for transparency (adjust as needed)
    float alpha = 0.2;  // Adjust this value for more or less transparency

    // Mix the video frame with the noise, adjusting the alpha for transparency
    fragColor = mix(videoColor, vec4(vec3(darkenedNoise), alpha), 0.5);
}

