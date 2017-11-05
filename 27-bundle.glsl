// vec2 iResolution
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

const float polySize = 0.6;
const float strokeWidth = 0.1;
const float smallHexSize = 0.15;
const float spacing = 0.06;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st = st.yx;

  // My solution
  float sdf = hexSDF(st);
  color += stroke(sdf, polySize, strokeWidth);
  sdf = hexSDF(st + vec2(-spacing, 0.0));
  color += fill(sdf, smallHexSize);
  sdf = hexSDF(st + vec2(spacing, 1.1 * spacing));
  color += fill(sdf, smallHexSize);
  sdf = hexSDF(st + vec2(spacing, -1.1 * spacing));
  color += fill(sdf, smallHexSize);

  color *= 0.0; // Just to reset stuff
  // Theirs
  color += stroke(hexSDF(st), polySize, strokeWidth);
  color += fill(hexSDF(st - vec2(-0.06, -0.1)), smallHexSize);
  color += fill(hexSDF(st - vec2(-0.06, 0.1)), smallHexSize);
  color += fill(hexSDF(st - vec2(0.11, 0.0)), smallHexSize);

  gl_FragColor = vec4(color, 1.0);
}
