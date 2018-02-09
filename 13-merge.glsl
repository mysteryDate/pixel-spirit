#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  vec2 offset = vec2(0.05 + sin(u_time / 3.0)/4.0, 0.0);
  float left = circleSDF(st + offset);
  float right = circleSDF(st - offset);
  color += flip(
    stroke(left, 0.5, 0.05),
    fill(right, 0.525)
  );

  gl_FragColor = vec4(color, 1.0);
}
