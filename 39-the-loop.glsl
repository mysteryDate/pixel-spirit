#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: map = require('./lib/map')

const float size = 0.3;
const float strokeWidth = 0.04;
// const float medOffset = 0.2;
// const float smallOffset = 0.1;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st = rotateAboutPoint(st, radians(180.0) * step(0.5, st.x), vec2(0.5));

  float angle = radians(45.0);
  float square = rectangleSDF(st, vec2(1.0));
  vec2 rotatedST = rotateAboutPoint(st, angle, vec2(0.5));
  float bigSquare = rectangleSDF(rotatedST, vec2(1.0));

  float bounceTimer = map(sin(u_time/2.0), -1.0, 1.0, 0.0, 1.0);
  float medSquareSize = size * 0.5;

  color *= 0.0;
  color += stroke(bigSquare, size, strokeWidth);
  vec2 medSquareST = rotateAboutPoint(st + vec2(0.2, 0.0), angle, vec2(0.5));
  float mediumSquare = rectangleSDF(medSquareST, vec2(1.0));
  color += stroke(mediumSquare, medSquareSize, strokeWidth);

  float invertControl = step(0.5, st.y);
  float bridges = mix(bigSquare, mediumSquare, invertControl);
  float bridgeSize = mix(size, medSquareSize, invertControl);
  color = bridge(color, bridges, bridgeSize, strokeWidth);

  float smallSquareSize = medSquareSize / 4.0;
  vec2 smallSquareST = rotateAboutPoint(st + vec2(0.333, 0.0), angle, vec2(0.5));
  float smallSquare = rectangleSDF(smallSquareST, vec2(1.0));
  color += stroke(smallSquare, smallSquareSize, strokeWidth);
  bridges = mix(mediumSquare, smallSquare, 1.0 - invertControl);
  bridgeSize = mix(medSquareSize, smallSquareSize, 1.0 - invertControl);
  color = bridge(color, bridges, bridgeSize, strokeWidth);

  gl_FragColor = vec4(color, 1.0);
}
