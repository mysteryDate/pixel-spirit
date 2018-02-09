#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: raysSDF = require('./lib/sdf/raysSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

const int numSides = 8;
const float outerSize = 0.6;
const float innerSize = 0.15;
const float outerStrokeWidth = 0.1;
const float innerStrokeWidth = 0.05;
const float rayStrokeWidth = 0.2;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // // My solution, pretty simple
  // float rays = raysSDF(st, numSides);
  // color += stroke(rays, 0.5, rayStrokeWidth);
  // float octo = polygonSDF(st, 8);
  // color *= fill(octo, outerSize - outerStrokeWidth);
  // color += stroke(octo, outerSize, outerStrokeWidth);
  // color *= 1.0 - step(octo, innerSize + 1.5 * innerStrokeWidth);
  // color += stroke(octo, innerSize, innerStrokeWidth);

  // Their solution
  float sdf = polygonSDF(st, numSides);
  color += fill(sdf, outerSize - outerStrokeWidth);
  color *= stroke(raysSDF(st, numSides), 0.5, rayStrokeWidth);
  color *= step(0.27, sdf);
  color += stroke(sdf, rayStrokeWidth, innerStrokeWidth);
  color += stroke(sdf, outerSize, outerStrokeWidth);

  gl_FragColor = vec4(color, 1.0);
}
