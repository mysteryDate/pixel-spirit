#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: raysSDF = require('./lib/sdf/raysSDF')
#pragma glslify: starSDF = require('./lib/sdf/starSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

const int numPoints = 8;
float rayThickness = 0.1;
float lineThickness = 0.05;
float starSize = 0.4;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // // My solution, I BET it's better than theirs
  // // I cheated and looked up the raysSDF
  // float ray = raysSDF(rotate(st, PI/8.0), numPoints);
  // color += fill(ray, rayThickness);
  // float starSDF = min(polySDF(st, 3), polySDF(rotate(st, PI), 3));
  // color *= 1.0 - step(starSDF, starSize);
  // color += stroke(starSDF, starSize - lineThickness, lineThickness);
  // color += fill(starSDF, starSize - 3.0 * lineThickness);
  // float star2 = min(polySDF(rotate(st, PI/6.0), 3), polySDF(rotate(st, PI + PI/6.0), 3));
  // color *= 1.0 - step(star2, starSize - 5.0 * lineThickness);
  // color += fill(star2, starSize - 5.5 * lineThickness);

  // Their solution, I was wrong. It's super clever
  color += stroke(raysSDF(st, numPoints), 0.5, 0.15);
  float inner = starSDF(st, 6, 0.09);
  float outer = starSDF(st.yx, 6, 0.09);
  color *= step(0.7, outer);
  color += fill(outer, 0.5);
  color -= stroke(inner, 0.25, 0.06);
  color += stroke(outer, 0.6, 0.05);

  gl_FragColor = vec4(color, 1.0);
}
