// vec2 iResolution
#define PI 3.14159

float stroke(float x, float s, float w) {
  float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
  return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

float rectSDF(vec2 st, vec2 s) {
  st = st * 2.0 - 1.0;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float sdf = rectSDF(st, vec2(1.0));
  color += stroke(sdf, 0.5, 0.125);
  color += fill(sdf, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
