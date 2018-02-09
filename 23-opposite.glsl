#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: flip = require('./lib/drawing/flip')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float rectSize = 0.4;
  float borderSize = 0.02;
  float disp = 0.05;

  st = rotateAboutPoint(st, radians(-45.0), vec2(0.5));

  vec2 s = vec2(1.0);
  float r1 = fill(rectangleSDF(st + disp, s), rectSize);
  float r2 = fill(rectangleSDF(st - disp, s), rectSize);
  color += flip(r1, r2);

  gl_FragColor = vec4(color, 1.0);
}
