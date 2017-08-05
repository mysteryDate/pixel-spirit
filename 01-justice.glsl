// vec2 iResolution

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  color += step(0.5, st.x);
  gl_FragColor = vec4(color, 1.0);
}
