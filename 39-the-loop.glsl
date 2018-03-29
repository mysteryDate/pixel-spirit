#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: map = require('./lib/map')

const vec2 CENTER = vec2(0.5);
const float size = 0.25;
const float strokeWidth = 0.03;
const float medSize = size / 1.5;
const float medOffset = size / 1.8;
const float smallSize = medSize / 4.0;
const float smallOffset = medOffset + medSize * sqrt(2.0)/2.0 + sqrt(2.0)/2.0 * smallSize;
const float angle = radians(45.0);
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution, long, but I like it
  st = rotateAboutPoint(st, radians(180.0) * step(0.5, st.x), CENTER);
  vec2 bigSquareST = rotateAboutPoint(st, angle, CENTER);
  float bigSquare = rectangleSDF(bigSquareST);
  color += stroke(bigSquare, size, strokeWidth);

  vec2 medSquareST = rotateAboutPoint(st + vec2(medOffset, 0.0), angle, CENTER);
  float mediumSquare = rectangleSDF(medSquareST);
  color += stroke(mediumSquare, medSize, strokeWidth);
  float invertControl = step(0.5, st.y);
  float bridges = mix(bigSquare, mediumSquare, invertControl);
  float bridgeSize = mix(size, medSize, invertControl);
  color = bridge(color, bridges, bridgeSize, strokeWidth);

  vec2 smallSquareST = rotateAboutPoint(st + vec2(smallOffset, 0.0), angle, CENTER);
  float smallSquare = rectangleSDF(smallSquareST);
  color += stroke(smallSquare, smallSize, strokeWidth);
  bridges = mix(mediumSquare, smallSquare, 1.0 - invertControl);
  bridgeSize = mix(medSize, smallSize, 1.0 - invertControl);
  color = bridge(color, bridges, bridgeSize, strokeWidth);

  // Their solution, senseless, yet cool
  color *= 0.0;
  st = gl_FragCoord.xy / iResolution.xy;
  float inv = step(0.5, st.y);
  st = rotateAboutPoint(st, -angle, CENTER) - 0.2;
  st = mix(st, 0.6 - st, step(0.5, inv));
  for (int i = 0; i < 5; i++) {
    float currentRect = rectangleSDF(st);
    float currentSize = size;
    currentSize -= abs(0.1 * float(i) - 0.2);
    color = bridge(color, currentRect, currentSize, strokeWidth);
    st += 0.1;
  }

  gl_FragColor = vec4(color, 1.0);
}
