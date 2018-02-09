
#define PI 3.14159
const float sqrt3over2 = sqrt(3.0)/2.0;

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

  float bigRectSize = 0.5;
  float littleRectSize = 0.325;
  float strokeWidth = 0.05;

  st = rotate(st, radians(45.0));
  vec2 s = vec2(1.0);
  // My convoluted solution
  // color += fill(rectSDF(st, s), bigRectSize + strokeWidth);
  // color -= fill(rectSDF(st, s), bigRectSize);
  // color += stroke(rectSDF(st + vec2(bigRectSize/2.0), s), littleRectSize, strokeWidth * 3.0);
  // color -= 2.0 * stroke(rectSDF(st + vec2(bigRectSize/2.0), s), littleRectSize, strokeWidth);
  // color -= fill(-1.0 * rectSDF(st, s) + 1.1, bigRectSize + strokeWidth);
  // Theirs
  float offset = 0.15;
  float r1 = rectSDF(st, s);
  float r2 = rectSDF(st + offset, s);
  color += stroke(r1, bigRectSize, strokeWidth);
  color *= step(littleRectSize, r2);
  color += stroke(r2, littleRectSize, strokeWidth) * fill(r1, bigRectSize + strokeWidth/2.0);
  color += stroke(r2, littleRectSize - offset + strokeWidth/2.0, strokeWidth);
  // ... kinda convoluted too

  gl_FragColor = vec4(color, 1.0);
}
