#pragma glslify: triangleSDF = require('./lib/sdf/triangleSDF')
#pragma glslify: rhombusSDF = require('./lib/sdf/rhombusSDF')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += flip(fill(triangleSDF(st), 0.5), fill(rhombusSDF(st), 0.4));

  gl_FragColor = vec4(color, 1.0);
}
