#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += stroke(circleSDF(st), 0.5, 0.05);

  gl_FragColor = vec4(color, 1.0);
}
