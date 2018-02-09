#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: raysSDF = require('./lib/sdf/raysSDF')
#pragma glslify: flip = require('./lib/drawing/flip')
#pragma glslify: fill = require('./lib/drawing/fill')

const int numRays = 28;
float rayWidth = 0.15;
float rectSize = 0.25;
float rectThickness = 0.05;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // // My solution, pretty easy
  // float ray = raysSDF(st, numRays);
  // color += flip(stroke(ray, 0.5, rayWidth), step(st.y, 0.5));
  // float rect = rectangleSDF(st, vec2(1.0));
  // color *= 1.0 - step(rect, rectSize);
  // color += fill(rect, rectSize - rectThickness);

  // Their solution, pretty much exactly the same
  color += flip(stroke(raysSDF(st, numRays), 0.5, rayWidth), fill(st.y, 0.5));
  float rect = rectangleSDF(st, vec2(1.0));
  color *= step(rectSize, rect);
  color += fill(rect, rectSize - rectThickness);

  gl_FragColor = vec4(color, 1.0);
}
