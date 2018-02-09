#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: starSDF = require('./lib/sdf/starSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

const int numPoints = 8;
const int theirNumPoints = 16;
const float starSize = 1.0;
const float strokeWidth = 0.03;
const float circleSize = 0.8;
const float speed = 0.5;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // // My code, 0.1 is curious here
  // // See test shaders folder for an animated one
  vec2 starST = st;
  float star = starSDF(starST, numPoints, 0.1);
  color += fill(star, starSize);
  vec2 rotST = rotateAboutPoint(st, PI/8.0, vec2(0.5));
  float rotStar = starSDF(rotST, numPoints, 0.1);
  color += fill(rotStar, starSize * 0.9);
  color *= 1.0 - stroke(star, starSize, strokeWidth);
  float octo = starSDF(rotST, numPoints, 0.0);
  color *= 1.0 - stroke(octo, 0.2 * starSize, strokeWidth);

  for (int i = 0; i < numPoints; i++) {
    vec2 triST = st;
    triST = rotateAboutPoint(triST, float(i)/float(numPoints) * PI * 2.0, vec2(0.5));
    triST -= vec2(0.0, 0.25);
    float tri = polygonSDF(triST, 3);
    color *= 1.0 - stroke(tri, 0.22 * starSize, strokeWidth);
  }

  // Their solution, think mine is MUCH clearer
  // Plus, theirs doesn't fit...
  // float bgSize = 1.3;
  // float background = starSDF(st, theirNumPoints, 0.1);
  // color += fill(background, bgSize);
  // float l = 0.0;
  // for(float i = 0.0; i < float(theirNumPoints)/2.0; i++)
  // {
  //   vec2 rotST = rotateAboutPoint(st, PI/4.0 * i, vec2(0.5));
  //   rotST.y -= 0.3;
  //   float tri = polygonSDF(rotST, 3);
  //   color += fill(tri, 0.3);
  //   l += stroke(tri, 0.3, 0.03);
  // }
  // color *= 1.0 - l;
  // float c = polygonSDF(st, 8);
  // color -= stroke(c, 0.15, 0.04);

  gl_FragColor = vec4(color, 1.0);
}
