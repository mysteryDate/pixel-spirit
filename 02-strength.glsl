#define PI 3.14159

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  color += step(0.5 + cos(st.y * PI) * 0.25, st.x);
  gl_FragColor = vec4(color, 1.0);
}
