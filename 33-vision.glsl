#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: vesicaSDF = require('./lib/sdf/vesicaSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: raysSDF = require('./lib/sdf/raysSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

int numRays = 50;
float vesicaSize = 0.8;
float vesicaShape = 0.3;
float smallVesicaSize = 0.7;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution, lotsa magic numbers
  // float rays = raysSDF(st, numRays);
  // color += stroke(rays, 0.5, 0.15);
  // float vesica = vesicaSDF(st, vesicaShape);
  // color *= fill(vesica, vesicaSize);
  //
  // float v2 = vesicaSDF(st.yx, 0.5);
  // color *= 1.0 - fill(v2, smallVesicaSize);
  // color += stroke(v2, smallVesicaSize, 0.03);
  //
  // float circle = circleSDF(st - vec2(0.0, 0.03));
  // color += stroke(circle, 0.2, 0.03) * fill(v2, smallVesicaSize);

  // Their solution, too big again!
  float v1 = vesicaSDF(st, 0.5);
  vec2 st2 = st.yx + vec2(0.04, 0.0);
  float v2 = vesicaSDF(st2, 0.7);
  color += stroke(v2, 1.0, 0.05);
  color += fill(v2, 1.0) * stroke(circleSDF(st), 0.3, 0.05);
  color += fill(raysSDF(st, numRays), 0.2) * fill(v1, 1.25) * step(1.0, v2);

  gl_FragColor = vec4(color, 1.0);
}
