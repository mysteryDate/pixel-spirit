#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: rhombusSDF = require('./lib/sdf/rhombusSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

const vec2 offset = vec2(0.10, 0.0);
const float radius = 0.25;
const float width = 0.06;
#define PI 3.14159
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution
  vec2 rotatedST = rotateAboutPoint(st, PI/2.0, vec2(0.5));
  rotatedST.x = flip(rotatedST.x, step(0.5, rotatedST.y));
  vec2 rect1UV = rotateAboutPoint(rotatedST, PI/4.0, vec2(0.5) - offset) + offset;
  float rect1 = rectangleSDF(rect1UV, vec2(1.0));
  color += stroke(rect1, radius, width);
  vec2 rect2UV = rotateAboutPoint(rotatedST, PI/4.0, vec2(0.5) + offset) - offset;
  float rect2 = rectangleSDF(rect2UV, vec2(1.0));
  color = bridge(color, rect2, radius, width);
  st.y = flip(st.y, step(0.5, st.y));
  float rhombus = rhombusSDF(st + vec2(0.0, 0.4));
  color += fill(rhombus, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
