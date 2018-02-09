
#define PI 3.14159
const float sqrt3over2 = sqrt(3.0)/2.0;

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

float vesicaSDF(vec2 st, float w) {
  vec2 offset = vec2(w * 0.5, 0.0);
  return max( circleSDF(st - offset),
              circleSDF(st + offset));
}

float triSDF(vec2 st) {
  st = 2.0 * (2.0 * st - 1.0) ;
  return max(sqrt3over2 * abs(st.x) + 0.5 * st.y, -0.5 * st.y);
}

float rhombSDF(vec2 st) {
  float triangleSDF = triSDF(st);
  float invertedTriangleSDF = triSDF(vec2(st.x, 1.0 - st.y));
  return max(triangleSDF, invertedTriangleSDF);
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

  float circle = circleSDF(st - vec2(0.0, 0.1));
  float triangle = triSDF(st + vec2(0.0, 0.1));

  float sdf = rhombSDF(st);
  color += fill(sdf, 0.425);
  color += stroke(sdf, 0.5, 0.05);
  color += stroke(sdf, 0.6, 0.03);

  gl_FragColor = vec4(color, 1.0);
}
