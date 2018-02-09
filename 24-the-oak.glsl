#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float bigRectSize = 0.5;
  float littleRectSize = 0.325;
  float strokeWidth = 0.05;

  st = rotateAboutPoint(st, radians(45.0), vec2(0.5));
  vec2 s = vec2(1.0);
  // My convoluted solution
  // color += fill(rectangleSDF(st, s), bigRectSize + strokeWidth);
  // color -= fill(rectangleSDF(st, s), bigRectSize);
  // color += stroke(rectangleSDF(st + vec2(bigRectSize/2.0), s), littleRectSize, strokeWidth * 3.0);
  // color -= 2.0 * stroke(rectangleSDF(st + vec2(bigRectSize/2.0), s), littleRectSize, strokeWidth);
  // color -= fill(-1.0 * rectangleSDF(st, s) + 1.1, bigRectSize + strokeWidth);
  // Theirs
  float offset = 0.15;
  float r1 = rectangleSDF(st, s);
  float r2 = rectangleSDF(st + offset, s);
  color += stroke(r1, bigRectSize, strokeWidth);
  color *= step(littleRectSize, r2);
  color += stroke(r2, littleRectSize, strokeWidth) * fill(r1, bigRectSize + strokeWidth/2.0);
  color += stroke(r2, littleRectSize - offset + strokeWidth/2.0, strokeWidth);
  // ... kinda convoluted too

  gl_FragColor = vec4(color, 1.0);
}
