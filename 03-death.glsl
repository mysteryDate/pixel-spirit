#define PI 3.14159

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  color += step(0.5, (st.x + st.y) * 0.5);
  gl_FragColor = vec4(color, 1.0);
}
