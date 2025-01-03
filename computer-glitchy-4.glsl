void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;
    
    // Brutal digital glitch timing
    float glitchTime = floor(iTime * 10.0) / 10.0;
    
    // Aggressive digital distortions
    vec2 glitchUV = uv;
    
    // Restore aggressive horizontal splits
    float splitChance = fract(sin(glitchTime * 23.0));
    if (splitChance > 0.7) {
        float splitHeight = fract(sin(glitchTime * 17.0));
        float splitIntensity = step(abs(uv.y - splitHeight), 0.02) * 
                                step(fract(sin(glitchTime * 11.0)), 0.5);
        
        // Sharp pixel-level horizontal shift
        ivec2 pixelCoord = ivec2(fragCoord);
        pixelCoord.x += int(splitIntensity * 10.0 * sin(iTime * 50.0));
        
        // Direct pixel sampling with sharp shifts
        vec3 rChannel = vec3(texelFetch(iChannel0, pixelCoord + ivec2(2, 0), 0).r, 0.0, 0.0);
        vec3 gChannel = vec3(0.0, texelFetch(iChannel0, pixelCoord, 0).g, 0.0);
        vec3 bChannel = vec3(0.0, 0.0, texelFetch(iChannel0, pixelCoord - ivec2(2, 0), 0).b);
        
        // Harsh color manipulation
        vec3 glitchColor = rChannel + gChannel + bChannel;
        
        // Digital noise
        float digitalNoise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
        float noiseThreshold = step(0.9, digitalNoise);
        glitchColor *= 1.0 + noiseThreshold * 0.4;
        
        // Harsh digital lines
        float digitalLines = step(fract(uv.y * 100.0 + iTime * 10.0), 0.5);
        glitchColor *= 1.0 - digitalLines * 0.3;
        
        // Color quantization
        glitchColor = floor(glitchColor * 6.0) / 6.0;
        
        fragColor = vec4(glitchColor, 1.0);
        return;
    }
    
    // Fallback to standard rendering with minimal glitch
    vec3 rChannel = vec3(texelFetch(iChannel0, ivec2(fragCoord + vec2(1.0, 0.0)), 0).r, 0.0, 0.0);
    vec3 gChannel = vec3(0.0, texelFetch(iChannel0, ivec2(fragCoord), 0).g, 0.0);
    vec3 bChannel = vec3(0.0, 0.0, texelFetch(iChannel0, ivec2(fragCoord - vec2(1.0, 0.0)), 0).b);
    
    vec3 glitchColor = rChannel + gChannel + bChannel;
    
    // Subtle glitch effects
    float digitalNoise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
    float noiseThreshold = step(0.95, digitalNoise);
    glitchColor *= 1.0 + noiseThreshold * 0.2;
    
    // Scan lines
    float digitalLines = step(fract(uv.y * 100.0 + iTime * 10.0), 0.5);
    glitchColor *= 1.0 - digitalLines * 0.2;
    
    // Color quantization
    glitchColor = floor(glitchColor * 8.0) / 8.0;
    
    fragColor = vec4(glitchColor, 1.0);
}
