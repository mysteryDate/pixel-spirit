
#define PI 3.14159
const float sqrt3over2 = sqrt(3.0)/2.0;

float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

float rectangleSDF(vec2 st, vec2 s) {
  st = st * 2.0 - 1.0;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float crossSDF(vec2 st, float s) {
  vec2 size = vec2(0.25, s);
  return min(rectangleSDF(st, size.xy), rectangleSDF(st, size.yx));
}

float vesicaSDF(vec2 st, float w) {
  vec2 offset = vec2(w * 0.5, 0.0);
  return max( circleSDF(st - offset),
              circleSDF(st + offset));
}

float triangleSDF(vec2 st) {
  st = 2.0 * (2.0 * st - 1.0) ;
  return max(sqrt3over2 * abs(st.x) + 0.5 * st.y, -0.5 * st.y);
}

float rhombusSDF(vec2 st) {
  float triangleSDF = triangleSDF(st);
  float invertedTriangleSDF = triangleSDF(vec2(st.x, 1.0 - st.y));
  return max(triangleSDF, invertedTriangleSDF);
}

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

float flip(float v, float pct) {
  return mix(v, 1.0 - v, pct);
}

float stroke(float x, float s, float w) {
  float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
  return clamp(d, 0.0, 1.0);
}

vec2 rotate(vec2 st, float a) {
  mat2 rotationMatrix = mat2(cos(a), -sin(a), sin(a), cos(a));
  vec2 rotated = rotationMatrix * (st - 0.5);
  return rotated + 0.5;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float smallRectSize = 0.2;
  float smallRectDist = 0.12;
  float largeRectSize = 0.3;
  float largeRectBorder = 0.03;

  st = rotate(st, radians(-45.0));
  vec2 s = vec2(1.0);
  color += fill(rectangleSDF(st + vec2(smallRectDist), s), smallRectSize);
  color += fill(rectangleSDF(st - vec2(smallRectDist), s), smallRectSize);
  // My complex attempt
  // color -= fill(rectangleSDF(st, s), largeRectSize + largeRectBorder);
  // color = max(color, 0.0);
  // Better from the card
  color *= step(largeRectSize + largeRectBorder, rectangleSDF(st, s));
  color += fill(rectangleSDF(st, s), largeRectSize);

  gl_FragColor = vec4(color, 1.0);
}
