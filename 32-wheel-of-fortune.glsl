// vec2 iResolution
#define PI 3.14159
const float sqrt3over2 = sqrt(3.0)/2.0;

float map(float value, float inMin, float inMax, float outMin, float outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec2 map(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  vec2 result = vec2(0.0);
  result.x = map(value.x, inMin.x, inMax.x, outMin.x, outMax.x);
  result.y = map(value.y, inMin.y, inMax.y, outMin.y, outMax.y);
  return result;
}

vec2 map(vec2 value, float inMin, float inMax, float outMin, float outMax) {
  return map(value, vec2(inMin), vec2(inMax), vec2(outMin), vec2(outMax));
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

float polySDF(vec2 st, int V) {
  st = 2.0 * st - 1.0;
  float a = atan(st.x, st.y) + PI;
  float r = length(st);
  float v = 2.0 * PI/float(V);
  return cos(floor(0.5 + a/v) * v - a) * r;
}

float hexSDF(vec2 st) {
  st = abs(2.0 * st - 1.0);
  float result = sqrt3over2 * st.x + 0.5 * st.y;
  result = max(result, abs(st.y));
  return result;
}

float starSDF(vec2 st, int V, float s) {
  st = 4.0 * st - 2.0;
  float a = atan(st.y, st.x)/(2.0 * PI);
  float seg = a * float(V);
  a = (floor(seg) + 0.5)/float(V);
  a += mix(s, -s, step(0.5, fract(seg)));
  a *= 2.0 * PI;
  float result = dot(vec2(cos(a), sin(a)), st);
  return abs(result);
}

float raysSDF(vec2 st, int N) {
  st -= 0.5;
  float theta = atan(st.y, st.x) / (2.0 * PI);
  return fract(theta * float(N));
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

const int numSides = 8;
const float outerSize = 0.6;
const float innerSize = 0.15;
const float outerStrokeWidth = 0.1;
const float innerStrokeWidth = 0.05;
const float rayStrokeWidth = 0.2;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // // My solution, pretty simple
  // float rays = raysSDF(st, numSides);
  // color += stroke(rays, 0.5, rayStrokeWidth);
  // float octo = polySDF(st, 8);
  // color *= fill(octo, outerSize - outerStrokeWidth);
  // color += stroke(octo, outerSize, outerStrokeWidth);
  // color *= 1.0 - step(octo, innerSize + 1.5 * innerStrokeWidth);
  // color += stroke(octo, innerSize, innerStrokeWidth);

  // Their solution
  float sdf = polySDF(st, numSides);
  color += fill(sdf, outerSize - outerStrokeWidth);
  color *= stroke(raysSDF(st, numSides), 0.5, rayStrokeWidth);
  color *= step(0.27, sdf);
  color += stroke(sdf, rayStrokeWidth, innerStrokeWidth);
  color += stroke(sdf, outerSize, outerStrokeWidth);

  gl_FragColor = vec4(color, 1.0);
}