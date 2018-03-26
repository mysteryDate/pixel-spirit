#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: map = require('./lib/map')

const vec2 offset = vec2(0.15, 0.0);
const float radius = 0.4;
const float width = 0.075;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution (I looked up flip)
  // st.x = flip(st.x, step(0.5, st.y));
  // float leftCircle = circleSDF(st + offset);
  // color += stroke(leftCircle, radius, width);
  // float rightCircle = circleSDF(st - offset);
  // color += stroke(rightCircle, radius, width);
  // color = bridge(color, rightCircle, radius, width);

  // Their solution, slightly more elegant
  st.x = flip(st.x, step(0.5, st.y));
  float left = circleSDF(st + offset);
  float right = circleSDF(st - offset);
  color += stroke(left, radius, width);
  color = bridge(color, right, radius, width);

  gl_FragColor = vec4(color, 1.0);
}
