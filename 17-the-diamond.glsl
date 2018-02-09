#pragma glslify: triangleSDF = require('./lib/sdf/triangleSDF')
#pragma glslify: rhombusSDF = require('./lib/sdf/rhombusSDF')
#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float circle = circleSDF(st - vec2(0.0, 0.1));
  float triangle = triangleSDF(st + vec2(0.0, 0.1));

  float sdf = rhombusSDF(st);
  color += fill(sdf, 0.425);
  color += stroke(sdf, 0.5, 0.05);
  color += stroke(sdf, 0.6, 0.03);

  gl_FragColor = vec4(color, 1.0);
}
