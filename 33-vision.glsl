
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

int numRays = 50;
float vesicaSize = 0.8;
float vesicaShape = 0.3;
float smallVesicaSize = 0.7;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution, lotsa magic numbers
  // float rays = raysSDF(st, numRays);
  // color += stroke(rays, 0.5, 0.15);
  // float vesica = vesicaSDF(st, vesicaShape);
  // color *= fill(vesica, vesicaSize);
  //
  // float v2 = vesicaSDF(st.yx, 0.5);
  // color *= 1.0 - fill(v2, smallVesicaSize);
  // color += stroke(v2, smallVesicaSize, 0.03);
  //
  // float circle = circleSDF(st - vec2(0.0, 0.03));
  // color += stroke(circle, 0.2, 0.03) * fill(v2, smallVesicaSize);

  // Their solution, too big again!
  float v1 = vesicaSDF(st, 0.5);
  vec2 st2 = st.yx + vec2(0.04, 0.0);
  float v2 = vesicaSDF(st2, 0.7);
  color += stroke(v2, 1.0, 0.05);
  color += fill(v2, 1.0) * stroke(circleSDF(st), 0.3, 0.05);
  color += fill(raysSDF(st, numRays), 0.2) * fill(v1, 1.25) * step(1.0, v2);

  gl_FragColor = vec4(color, 1.0);
}
