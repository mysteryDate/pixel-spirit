#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: vesicaSDF = require('./lib/sdf/vesicaSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.45;
const float strokeWidth = 0.05;
const float vesicaSlope = 0.3;
const vec2 offset = vec2(0.0, 0.09);
const int NUM_POINTS = 3;

vec3 mySolution(vec2 st) {
  vec3 color = vec3(0.0);

  float angle = 2.0 * PI / float(NUM_POINTS);
  for(int i = 0; i < NUM_POINTS; i++) {
    vec2 nextST = rotateAboutPoint(st, angle, CENTER);
    float center = vesicaSDF(st - offset, vesicaSlope);
    float next = vesicaSDF(nextST - offset, vesicaSlope);
    color += stroke(next, size, strokeWidth) * step(0.5, nextST.x);
    float bridgeControl = (1.0 - step(0.5, st.x)) * step(0.5, st.y);
    color = bridge(color, center * bridgeControl, size, strokeWidth);
    st = nextST;
  }

  return color;
}

vec3 theirSolution(vec2 st) { // respectfully, this is a fucking mess
  vec3 color = vec3(0.0);

  float angle = 2.0 * PI / float(NUM_POINTS);
  for(int i = 0; i < 2 * NUM_POINTS; i++) {
    vec2 xy = rotateAboutPoint(st, angle * float(i), CENTER) - offset;
    float vsc = vesicaSDF(xy, vesicaSlope);
    color = mix(
      color + stroke(vsc, size, strokeWidth),
      mix(
        color,
        bridge(color, vsc, size, strokeWidth),
      step(xy.x, 0.5) - step(xy.y, 0.4)),
    step(3.0, float(i)));
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
