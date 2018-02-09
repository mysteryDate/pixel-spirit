#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float smallRectSize = 0.2;
  float smallRectDist = 0.12;
  float largeRectSize = 0.3;
  float largeRectBorder = 0.03;

  st = rotateAboutPoint(st, radians(-45.0), vec2(0.5));
  vec2 s = vec2(1.0);
  color += fill(rectangleSDF(st + vec2(smallRectDist), s), smallRectSize);
  color += fill(rectangleSDF(st - vec2(smallRectDist), s), smallRectSize);
  // My complex attempt
  // color -= fill(rectangleSDF(st, s), largeRectSize + largeRectBorder);
  // color = max(color, 0.0);
  // Better from the card
  color *= step(largeRectSize + largeRectBorder, rectangleSDF(st, s));
  color += fill(rectangleSDF(st, s), largeRectSize);

  gl_FragColor = vec4(color, 1.0);
}
