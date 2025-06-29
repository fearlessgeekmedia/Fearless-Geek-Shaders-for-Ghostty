void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;

    // Get the original terminal content
    vec4 terminalColor = texture(iChannel0, uv);

    // Subtle neon glow effect on text
    float textBrightness = length(terminalColor.rgb);
    float glowIntensity = smoothstep(0.2, 0.4, textBrightness) * 0.15; // Much gentler glow

    // Create subtle neon glow with fewer passes and smaller radius
    vec3 neonGlow = vec3(0.0);
    float glowRadius = 0.0012; // Smaller glow radius

    for(int i = 0; i < 3; i++) { // Fewer passes
        float offset = float(i) * glowRadius;
        vec2 glowUV = uv + vec2(offset, 0.0);
        vec2 glowUV2 = uv + vec2(-offset, 0.0);
        vec2 glowUV3 = uv + vec2(0.0, offset);
        vec2 glowUV4 = uv + vec2(0.0, -offset);

        vec4 glowSample1 = texture(iChannel0, glowUV);
        vec4 glowSample2 = texture(iChannel0, glowUV2);
        vec4 glowSample3 = texture(iChannel0, glowUV3);
        vec4 glowSample4 = texture(iChannel0, glowUV4);

        float glowStrength = 1.0 - float(i) * 0.33;
        neonGlow += (glowSample1.rgb + glowSample2.rgb + glowSample3.rgb + glowSample4.rgb) * glowStrength * 0.25;
    }

    // Subtle color cycling, but much closer to original text color
    float time = iTime * 0.5;
    float colorCycle = sin(time * 0.1) * 0.5 + 0.5;
    vec3 cyclingColor = mix(vec3(0.7, 0.9, 1.0), vec3(0.5, 1.0, 0.8), colorCycle);

    // Dynamic holographic shimmer (both horizontal and vertical)
    float shimmerX = sin(uv.y * 120.0 + time * 3.0) * 0.5 + 0.5;
    float shimmerY = sin(uv.x * 80.0 - time * 2.0) * 0.5 + 0.5;
    float shimmer = shimmerX * shimmerY;
    shimmer = pow(shimmer, 1.5); // Sharper shimmer
    float shimmerContrast = mix(0.08, 0.18, shimmer); // Subtle but visible

    // Subtle color shift for holographic look
    vec3 holoColor = mix(vec3(0.2, 0.6, 1.0), vec3(0.1, 1.0, 0.8), sin(time + uv.x * 2.0) * 0.5 + 0.5);
    vec3 holographicEffect = holoColor * shimmerContrast;

    // Only subtle neon glow and dynamic holographic effect
    vec3 neonEffect = neonGlow * cyclingColor * glowIntensity;
    vec3 cyberpunkColor = terminalColor.rgb + neonEffect + holographicEffect;

    fragColor = vec4(cyberpunkColor, 1.0);
} 