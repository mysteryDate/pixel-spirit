#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')

const float size = 0.5;
const float strokeWidth = 0.075;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution, the final mix is maybe cheating, but it's clear!
  // float angle = sin(u_time);
  float angle = radians(45.0);
  float square = rectangleSDF(st, vec2(1.0));
  vec2 rotatedST = rotateAboutPoint(st, angle, vec2(0.5));
  float rotatedSquare = rectangleSDF(rotatedST, vec2(1.0));
  vec3 outerColor = color + stroke(rotatedSquare, size, strokeWidth);
  outerColor = bridge(outerColor, square, size, strokeWidth);
  vec3 innerColor = color + stroke(square, size, strokeWidth);
  innerColor = bridge(innerColor, rotatedSquare, size, strokeWidth);
  color = mix(innerColor, outerColor, step(0.5 * (size - strokeWidth), abs(st.x - 0.5)));

  // Their solution, v clever
  color *= 0.0;
  float inv = step(0.5, 0.5 * (st.x + st.y));
  inv = flip(inv, step(0.5, 0.5 + 0.5 * (st.x - st.y)));
  color += stroke(square, size, strokeWidth) + stroke(rotatedSquare, size, strokeWidth);
  float bridges = mix(square, rotatedSquare, inv); // This is kinda like mine
  color = bridge(color, bridges, size, strokeWidth);

  gl_FragColor = vec4(color, 1.0);
}
