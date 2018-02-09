#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

const int numSides = 5;
const float polySize = 0.3;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float sdf = polygonSDF(st, numSides);
  float invSDF = polygonSDF(rotateAboutPoint(st, PI, vec2(0.5)), numSides);
  float radiusRatio = cos(PI/float(numSides));

  // Their compact solution, it doesn't actually work tho...
  color += fill(sdf, 0.75) * fill(fract(sdf * 5.0), 0.5);
  color -= fill(invSDF, 0.75 * radiusRatio) * fill(fract(invSDF * 4.9), 0.5 * radiusRatio);

  // My crazy-ass solution
  // float strokeSize = 0.05;
  // color += stroke(sdf, polySize, strokeSize);
  //
  // float outerSize = polySize - 2.0 * strokeSize;
  // float size = (polySize - strokeSize) * cos(PI/5.0);
  // color += stroke(sdf, outerSize, strokeSize);
  // strokeSize *= cos(PI/5.0);
  // color -= stroke(invSDF, size, strokeSize);
  //
  // size -= 2.0 * strokeSize;
  // size *= cos(PI/5.0);
  // color += stroke(sdf, size, strokeSize);
  // strokeSize *= cos(PI/5.0);
  // color -= stroke(invSDF, size, strokeSize);
  //
  // size -= 2.0 * strokeSize;
  // size *= cos(PI/5.0);
  // color += stroke(sdf, size, strokeSize);
  // strokeSize *= cos(PI/5.0);
  // color -= stroke(invSDF, size, strokeSize);

  // FIXME This one could actually be fun

  gl_FragColor = vec4(color, 1.0);
}
