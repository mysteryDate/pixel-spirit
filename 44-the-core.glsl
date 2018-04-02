#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: hsv2rgb = require('./lib/hsv2rgb')
#pragma glslify: map = require('./lib/map')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.176;
const float strokeWidth = 0.007;
const vec2 offset = vec2(0.0, 0.3);
// const int NUM_POINTS = 8;

const float duration = 50.0;
const float squareBrightness = 1.0 / 2.0;
#define numSquares 36.0
vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);

  float NUM_POINTS = map(sin(2.0 * PI * u_time/duration), -1.0, 1.0, 0.0, 1.0);
  NUM_POINTS = map(pow(NUM_POINTS, 2.0), 0.0, 1.0, 1.0, numSquares);

  // float angle = 2.0 * PI / float(NUM_POINTS);
  float angle = 2.0 * PI / NUM_POINTS;
  for(float i = 0.0; i < numSquares; i++) {
    vec2 xy = rotateAboutPoint(st, angle * i, CENTER);
    float square = rectangleSDF(rotateAboutPoint(xy - offset, PI/4.0, CENTER));
    // vec3 squareColor = vec3(0.33 * mod(i, 3.0), 0.33 * mod(i + 1.0, 3.0), 0.33 * mod(i + 2.0, 3.0));
    float hue = i / numSquares;
    vec3 squareColor = hsv2rgb(vec3(hue, 1.0, 1.0));
    color += fill(square, size) * squareBrightness * squareColor;

    float centerLine = stroke(abs(xy.x - 0.5), 0.0, strokeWidth);
    float lineLength = 2.0;
    // float lineLength = max(1.19, length(st.y - xy.y));
    // lineLength = 1.0 - step(0.2, lineLength);
    centerLine *= step(lineLength, 1.0/length(st.y - xy.y)) / 3.0;
    color += centerLine * squareColor;
  }

  return color;
}

vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += mySolution(st);
  // color += theirSolution(st);
  // color = 1.0 - color;
  vec3 invColor = 1.0 - color;
  // color = mix(color, invColor, sin(2.0 * PI * u_time));
  // color = invColor;

  gl_FragColor = vec4(color, 1.0);
}
