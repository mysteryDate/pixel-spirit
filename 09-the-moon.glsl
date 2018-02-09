#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')

void main() {
  float intensity = 0.0;
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  intensity += fill(circleSDF(st), 0.65);
  vec2 offset = vec2(0.5) * sin(u_time / 5.0);
  intensity -= fill(circleSDF(st - offset), 0.65);

  vec3 color = intensity * vec3(1.0, 0.9, 0.8);
  gl_FragColor = vec4(color + vec3(0.5), 1.0);
  // gl_FragColor = vec4(sin(iGlobalTime), st, 1.0);
}
