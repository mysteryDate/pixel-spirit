#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')


void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float rectSize = 0.4;
  float borderSize = 0.02;
  float disp = 0.025;

  st = rotateAboutPoint(st, radians(45.0), vec2(0.5));

  vec2 s = vec2(1.0);
  color += fill(rectangleSDF(st + vec2(disp), s), rectSize);
  color += fill(rectangleSDF(st - vec2(disp), s), rectSize);
  // My solution
  // color *= 1.0 - fill(rectangleSDF(st - vec2(disp), s), rectSize - borderSize);
  // Theirs
  color *= step(rectSize - borderSize, rectangleSDF(st - vec2(disp), s));

  gl_FragColor = vec4(color, 1.0);
}
