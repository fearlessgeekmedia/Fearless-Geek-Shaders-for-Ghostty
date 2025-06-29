void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;
    
    // Get the original terminal content
    vec4 terminalColor = texture(iChannel0, uv);
    
    // Subtle neon glow effect on text (from the readable version)
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
    
    // Cyberpunk color palette
    vec3 neonPink = vec3(1.0, 0.2, 0.8);
    vec3 neonBlue = vec3(0.2, 0.8, 1.0);
    vec3 neonGreen = vec3(0.2, 1.0, 0.4);
    vec3 neonPurple = vec3(0.8, 0.2, 1.0);
    
    // Color cycling effect
    float time = iTime * 0.5;
    float colorCycle = sin(time * 0.3) * 0.5 + 0.5;
    vec3 cyclingColor = mix(neonPink, neonBlue, colorCycle);
    cyclingColor = mix(cyclingColor, neonGreen, sin(time * 0.2) * 0.5 + 0.5);
    
    // Digital rain effect (Matrix-style)
    float rainSpeed = time * 2.0;
    float rainDensity = 0.02;
    float rain = 0.0;
    for(int i = 0; i < 20; i++) {
        float rainX = fract(sin(float(i) * 123.456) * 456.789);
        float rainY = fract(rainSpeed + float(i) * 0.1);
        float rainDrop = step(rainX - rainDensity, uv.x) * step(uv.x, rainX + rainDensity) * 
                        step(rainY - 0.1, uv.y) * step(uv.y, rainY + 0.1);
        rain += rainDrop * (0.3 + 0.7 * sin(time * 3.0 + float(i)));
    }
    
    // Holographic interference patterns
    float interference1 = sin(uv.x * 100.0 + time * 2.0) * sin(uv.y * 80.0 + time * 1.5);
    float interference2 = sin(uv.x * 60.0 - time * 1.8) * sin(uv.y * 120.0 - time * 2.2);
    float interference = (interference1 + interference2) * 0.5;
    vec3 interferenceEffect = vec3(0.2, 0.6, 1.0) * interference * 0.1;
    
    // Combine cyberpunk effects
    vec3 neonEffect = neonGlow * cyclingColor * glowIntensity;
    vec3 rainEffect = vec3(0.0, 0.8, 0.4) * rain * 0.3;
    
    // Final color composition
    vec3 cyberpunkColor = terminalColor.rgb + neonEffect + rainEffect + interferenceEffect;
    
    // Add subtle vignette
    float vignette = smoothstep(1.0, 0.3, length(uv - 0.5));
    cyberpunkColor *= vignette;
    
    // Add subtle noise for film grain effect
    float noise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
    cyberpunkColor += noise * 0.02;
    
    // Color grading for cyberpunk look
    cyberpunkColor.r = pow(cyberpunkColor.r, 0.9);
    cyberpunkColor.g = pow(cyberpunkColor.g, 1.1);
    cyberpunkColor.b = pow(cyberpunkColor.b, 1.2);
    
    // Boost contrast
    cyberpunkColor = (cyberpunkColor - 0.5) * 1.2 + 0.5;
    
    fragColor = vec4(cyberpunkColor, 1.0);
} 