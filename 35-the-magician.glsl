#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: map = require('./lib/map')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float d = map(sin(u_time), -1.0, 1.0, 0.0, 0.2);
  color += fill(circleSDF(st + vec2(d, 0.0)), 0.4);
  gl_FragColor = vec4(color, 1.0);
}
