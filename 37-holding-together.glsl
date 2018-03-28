#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

// This isn't on the card, but the ratios here are important
const float size = 0.3;
const vec2 offset = vec2(size * sqrt(2.0)/4.0, 0.0);
const float strokeWidth = 2.0/3.0 * size;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution, not quite
  st = rotateAboutPoint(st, radians(180.0) * step(0.5, st.x), vec2(0.5));
  st += offset;
  st = rotateAboutPoint(st, radians(45.0), vec2(0.5));
  vec2 squareST = st;
  float square = rectangleSDF(squareST, vec2(1.0));
  color += fill(square, size);
  vec2 rectST = st - vec2(1.0, 0.0) * size / 3.0;
  float rectangle = rectangleSDF(rectST, vec2(1.0, 1.0/3.0));
  color -= fill(rectangle, size * 1.2);
  color += fill(rectangle, size);

  // Reset
  color = vec3(0.0);
  st = gl_FragCoord.xy / iResolution.xy;

  // Their solution, this one is super brittle, I don't like it
  st.x = flip(st.x, 1.0 - step(0.5, st.y));
  float angle = radians(45.0);
  vec2 leftST = rotateAboutPoint(st + offset, angle, vec2(0.5));
  float leftSquare = rectangleSDF(leftST, vec2(1.0));
  vec2 rightST = rotateAboutPoint(st - offset, -angle, vec2(0.5));
  float rightSquare = rectangleSDF(rightST, vec2(1.0));
  color += stroke(leftSquare, size, strokeWidth);
  // color += stroke(rightSquare, size, strokeWidth);
  color = bridge(color, rightSquare, size, strokeWidth);

  gl_FragColor = vec4(color, 1.0);
}
