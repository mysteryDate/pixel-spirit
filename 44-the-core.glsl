#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: bridge = require('./lib/drawing/bridge')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.115;
const float strokeWidth = 0.003;
const vec2 offset = vec2(0.0, 0.2);
const int NUM_POINTS = 8;

vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);

  float angle = 2.0 * PI / float(NUM_POINTS);
  for(int i = 0; i < NUM_POINTS; i++) {
  // for(int i = 0; i < 1; i++) {
    vec2 xy = rotateAboutPoint(st, angle * float(i), CENTER);
    float square = rectangleSDF(rotateAboutPoint(xy - offset, PI/4.0, CENTER));
    color += fill(square, size);

    color += stroke(abs(xy.x - 0.5), 0.0, strokeWidth);
  }
  color *= 1.0 - step(length(offset), length(st - 0.5));

  return color;
}

vec3 theirSolution(vec2 st) { // respectfully, this is a fucking mess
  vec3 color = vec3(0.0);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += mySolution(st);
  // color += theirSolution(st);

  gl_FragColor = vec4(color, 1.0);
}
