#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: crossSDF = require('./lib/sdf/crossSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

#define PI 3.14159

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  // st = rotateAboutPoint(st, u_time, vec2(0.5));

  float rect = rectangleSDF(rotateAboutPoint(st, -u_time/2.0, vec2(0.5)), vec2(1.0));
  color += fill(rect, 0.5);
  // float cross = crossSDF(rotate(st, u_time), 1.0);
  float cross = crossSDF(rotateAboutPoint(st, u_time, vec2(0.5)), 1.0);
  color *= step(0.5, fract(cross * 4.0));
  color *= step(1.0, cross);
  color += fill(cross, 0.5 * sin(u_time) + 0.5);
  color += stroke(rect, 0.65, 0.05);
  color += stroke(rect, 0.75, 0.025);

  gl_FragColor = vec4(color, 1.0);
}
