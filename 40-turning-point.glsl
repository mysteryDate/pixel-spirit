#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.2;
const float strokeWidth = 0.07;
const float offset = 0.13;

vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);
  st = rotateAboutPoint(st, -PI/3.0, CENTER);
  st = rotateAboutPoint(st, PI * (1.0 - step(0.5, st.x)), CENTER); // For the mirroring
  float bottom = polygonSDF(st + vec2(0.0, offset), 3);
  color += stroke(bottom, size, strokeWidth);
  vec2 topST = rotateAboutPoint(st - vec2(0.0, offset), PI, CENTER);
  float top = polygonSDF(topST, 3);
  color = bridge(color, top, size, strokeWidth);

  return color;
}

vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);
  st = rotateAboutPoint(st, -PI/3.0, CENTER);
  st.y = flip(st.y, step(0.5, st.x));
  st.y += offset;
  float down = polygonSDF(st, 3);
  st.y = 1.0 + 2.0 * offset - st.y;
  float top = polygonSDF(st, 3);
  color += stroke(top, size, strokeWidth);
  color = bridge(color, down, size, strokeWidth);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color = mySolution(st);
  // color = theirSolution(st); // They made theirs huge..

  gl_FragColor = vec4(color, 1.0);
}
