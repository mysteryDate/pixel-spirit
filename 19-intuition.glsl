#pragma glslify: triangleSDF = require('./lib/sdf/triangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: rotate = require('./lib/rotate')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st = rotate(st, radians(-25.0));
  float sdf = triangleSDF(st);
  sdf /= triangleSDF(st + vec2(0.0, 0.2));
  color += fill(abs(sdf), 0.56);

  gl_FragColor = vec4(color, 1.0);
}
