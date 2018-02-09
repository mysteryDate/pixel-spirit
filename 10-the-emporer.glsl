#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float sdf = rectangleSDF(st, vec2(1.0));
  color += stroke(sdf, 0.5, 0.125);
  color += fill(sdf, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
