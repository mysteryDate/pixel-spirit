#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: vesicaSDF = require('./lib/sdf/vesicaSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.45;
const float strokeWidth = 0.05;
const float vesicaSlope = 0.3;
const vec2 offset = vec2(0.0, 0.189);
const int NUM_POINTS = 12;

vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);

  float angle = 2.0 * PI / float(NUM_POINTS);
  for(int i = 0; i < NUM_POINTS; i++) {
    float center = vesicaSDF(st - offset, vesicaSlope);
    float distanceMask = step(0.9 * size/2.0, length(st - CENTER));
    color = bridge(color, center * distanceMask, size, strokeWidth);
    color += stroke(center * (1.0 - distanceMask), size, strokeWidth);
    st = rotateAboutPoint(st, angle, CENTER);
  }

  return color;
}

vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);

  float angle = 2.0 * PI / float(NUM_POINTS);
  for(int i = 0; i < NUM_POINTS; i++) {
    vec2 xy = rotateAboutPoint(st, angle * float(i), CENTER) - offset;
    float vsc = vesicaSDF(xy, vesicaSlope);
    color *= 1.0 - stroke(vsc, size, 0.1) * step(0.5, xy.y);
    color += stroke(vsc, size, strokeWidth);
  }

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += mySolution(st);
  color += theirSolution(st);

  gl_FragColor = vec4(color, 1.0);
}
