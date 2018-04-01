#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')
#pragma glslify: flip = require('./lib/drawing/flip')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.2;
const float strokeWidth = 0.04;
const vec2 offset = vec2(0.0, 0.1);

vec3 mySolution(vec2 st) { // A bit hacky, but it works!
  vec3 color = vec3(0.0);

  st = rotateAboutPoint(st, PI, CENTER);
  st.x = 1.0 - st.x;
  for(int i = 0; i < 3; i++) {
    float inv = step(0.5, st.x) * (1.0 - step(0.5, st.y));
    float center = polygonSDF(st + offset, 3);
    color += stroke(center, size, strokeWidth) * step(0.0, st.x - st.y);
    float next = polygonSDF(rotateAboutPoint(st, 2.0*PI/3.0, CENTER) + offset, 3);
    color = bridge(color, next * inv, size, strokeWidth);
    st = rotateAboutPoint(st, 2.0*PI/3.0, CENTER);
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

  color = mySolution(st);
  // color = theirSolution(st); // They made theirs huge..

  gl_FragColor = vec4(color, 1.0);
}
