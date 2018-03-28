#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

const float size = 0.4;
const vec2 offset = vec2(0.1, 0.0);
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

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

  gl_FragColor = vec4(color, 1.0);
}
