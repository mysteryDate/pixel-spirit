#pragma glslify: map = require('./lib/map')


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

float heartSDF(vec2 st) {
  float h;
  st -= vec2(0.5, 0.8);
  float r = 5.0 * length(st);
  st = normalize(st);
  h = st.y * pow(abs(st.x), 0.67);
  h /= st.y + 1.5;
  h -= 2.0 * st.y - 1.26;
  h = r - h;
  return h;
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

vec3 bridge(vec3 c, float d, float s, float w) {
  c *= 1.0 - stroke(d, s, 2.0 * w);
  return c + stroke(d, s, w);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float d = map(sin(u_time), -1.0, 1.0, 0.0, 0.2);
  color += fill(circleSDF(st + vec2(d, 0.0)), 0.4);
  gl_FragColor = vec4(color, 1.0);
}
