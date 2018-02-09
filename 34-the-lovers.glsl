#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: polySDF = require('./lib/sdf/polygonSDF')
#pragma glslify: heartSDF = require('./lib/sdf/heartSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: stroke = require('./lib/drawing/stroke')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution is pretty much the same as theirs
  // after looking up the SDF
  float heart = heartSDF(st);
  color += fill(heart, 0.5);

  color -= stroke(polySDF(st, 3), 0.15, 0.05);

  gl_FragColor = vec4(color, 1.0);
}
