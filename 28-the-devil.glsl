#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: starSDF = require('./lib/sdf/starSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')

const int numPoints = 5;
const float starSize = 0.5;
const float strokeWidth = 0.05;
const float circleSize = 0.8;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My attempt, hacky but close I think
  // st = rotate(st, radians(-15.0));
  // // float star = starSDF(st, numPoints, sin(5.0 * u_time / PI + PI/4.0)/10.0);
  // float star = starSDF(st, numPoints, 0.1);
  // color += stroke(star, starSize, strokeWidth);
  // float circle = circleSDF(st);
  // // color += stroke(circle, starSize * 1.8 * mod(u_time, 2.0) / 2.0, strokeWidth/2.0);
  // color += stroke(circle, starSize * 1.8, strokeWidth/2.0);
  // color -= stroke(star, starSize + strokeWidth, strokeWidth);
  // color -= stroke(star, starSize + 2.0 * strokeWidth, strokeWidth);

  // Their code, magic numbers and all
  color += stroke(circleSDF(st), circleSize, strokeWidth);
  st.y = 1.0 - st.y;
  float star = starSDF(st.yx, numPoints, 0.1);
  color *= step(0.7, star);
  color += stroke(star, 0.4, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
