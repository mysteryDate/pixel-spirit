#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')

const float size = 0.3;
const float strokeWidth = 0.04;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float angle = radians(45.0);
  float square = rectangleSDF(st, vec2(1.0));
  vec2 rotatedST = rotateAboutPoint(st, angle, vec2(0.5));
  float bigSquare = rectangleSDF(rotatedST, vec2(1.0));

  // Their solution, v clever
  // float inv = step(0.5, 0.5 * (st.x + st.y));
  // inv = flip(inv, step(0.5, 0.5 + 0.5 * (st.x - st.y)));
  // color += stroke(square, size, strokeWidth) + stroke(bigSquare, size, strokeWidth);
  // float bridges = mix(square, bigSquare, inv); // This is kinda like mine
  // color = bridge(color, bridges, size, strokeWidth);

  color *= 0.0;
  color += stroke(bigSquare, size, strokeWidth);
  float mediumSquare = rectangleSDF(rotateAboutPoint(st + vec2(0.2, 0.0), angle, vec2(0.5)), vec2(1.0));
  color += stroke(mediumSquare, size, strokeWidth);
  // color = bridge(color, mediumSquare, size/2.0, strokeWidth);
  // float littleSquare = rectangleSDF(rotateAboutPoint(st + vec2(0.33, 0.0), angle, vec2(0.5)), vec2(1.0));
  // color += stroke(littleSquare, size/8.0, strokeWidth);

  float invertControl = step(0.5, st.y);
  float bridges = mix(bigSquare, mediumSquare, invertControl);
  color = bridge(color, bridges, size, strokeWidth);

  gl_FragColor = vec4(color, 1.0);
}
