#pragma glslify: flowerSDF = require('./lib/sdf/flowerSDF')
#pragma glslify: circleSDF = require('./lib/sdf/circleSDF')
#pragma glslify: starSDF = require('./lib/sdf/starSDF')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: map = require('./lib/map')
#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')

#define PI 3.14159
#define CENTER vec2(0.5)
const int numPoints = 5;
const vec2 offset = vec2(0.4, 0.0);
vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);

  float flower = flowerSDF(st, numPoints);
  color += fill(flower, 0.25);

  vec2 st2 = st;
  for(int i = 0; i < numPoints; i++)
  {
    float r = rectangleSDF(rotateAboutPoint(st2 - offset, PI/4.0, CENTER));
    color *= 1.0 - fill(r, 0.15);
    st2 = rotateAboutPoint(st2, 2.0 * PI / float(numPoints), CENTER);
  }

  color += stroke(circleSDF(st), 0.8, 0.087);
  color *= 1.0 - stroke(circleSDF(st), 0.1, 0.05);

  return color;
}

vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);

  color += fill(flowerSDF(st, 5), 0.25);
  color -= step(0.95, starSDF(rotateAboutPoint(st, 0.628, vec2(0.5)), 5, 0.1));
  color = clamp(color, 0.0, 1.0);
  float circle = circleSDF(st);
  color -= stroke(circle, 0.1, 0.05);
  color += stroke(circle, 0.8, 0.07);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // color += mySolution(st);
  color += theirSolution(st);

  gl_FragColor = vec4(color, 1.0);
}
