void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalize coordinates
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Fetch the video frame (assume iChannel0 is the video texture)
    vec4 videoColor = texture(iChannel0, uv);

    // --- Subtle Film Grain ---
    float grain = fract(sin(dot(fragCoord.xy, vec2(12.9898, 78.233))) * 43758.5453);
    grain *= mix(0.9, 1.0, sin(iTime * 0.5 + uv.x * 50.0)); // Slow, animated grain
    vec3 grainEffect = videoColor.rgb * (1.0 - grain * 0.03); // Blend grain with video

    // --- Reduced Frequency Scratches ---
    float scratchChance = step(0.995, fract(sin(uv.x * 200.0 + iTime * 20.0) * 43758.5453123)); // 25% frequency
    float scratchIntensity = smoothstep(0.0, 0.02, abs(sin(uv.y * 50.0 + iTime * 3.0)));
    float scratch = scratchChance * scratchIntensity * step(0.9, fract(sin(iTime * 20.0 + uv.x * 500.0) * 43758.545));
    vec3 scratchEffect = vec3(1.0) - vec3(scratch * 0.7); // Overlay random vertical scratches

    // --- Irregular Blotches ---
    float blotch = step(0.995, fract(sin(dot(uv * iTime * 0.5, vec2(43.32, 27.85))) * 1234.567));
    blotch *= smoothstep(0.0, 0.1, fract(sin(dot(uv * 20.0, vec2(15.45, 25.33))) * 546.89)); // Irregular, fading blotches
    vec3 blotchEffect = mix(vec3(1.0), vec3(0.4, 0.3, 0.3), blotch * 0.8); // Dark reddish blotches

    // --- Vignette Effect ---
    float vignette = smoothstep(0.8, 0.4, length(uv - 0.5));
    vec3 vignetteEffect = grainEffect * vignette;

    // Combine effects
    vec3 finalColor = videoColor.rgb * vignetteEffect * scratchEffect * blotchEffect;

    // Output final color
    fragColor = vec4(finalColor, 1.0);
}

