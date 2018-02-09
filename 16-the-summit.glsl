#pragma glslify: triangleSDF = require('./lib/sdf/triangleSDF')
#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float circle = circleSDF(st - vec2(0.0, 0.1));
  float triangle = triangleSDF(st + vec2(0.0, 0.1));

  color += stroke(circle, 0.45, 0.1);
  color *= step(0.55, triangle);
  color += fill(triangle, 0.45);

  gl_FragColor = vec4(color, 1.0);
}
