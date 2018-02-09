
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

float crossSDF(vec2 st, float s) {
  vec2 size = vec2(0.25, s);
  return min(rectSDF(st, size.xy), rectSDF(st, size.yx));
}

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

float flip(float v, float pct) {
  return mix(v, 1.0 - v, pct);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  vec2 offset = vec2(0.05 + sin(u_time / 3.0)/4.0, 0.0);
  float left = circleSDF(st + offset);
  float right = circleSDF(st - offset);
  color += flip(
    stroke(left, 0.5, 0.05),
    fill(right, 0.525)
  );

  gl_FragColor = vec4(color, 1.0);
}
