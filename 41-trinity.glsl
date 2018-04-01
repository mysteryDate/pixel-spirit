#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: polygonSDF = require('./lib/sdf/polygonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: bridge = require('./lib/drawing/bridge')

#define PI 3.14159
const vec2 CENTER = vec2(0.5);
const float size = 0.25;
const float strokeWidth = 0.08;
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

vec3 theirSolution(vec2 st) { // I actually think this is quite clean
  vec3 color = vec3(0.0);

  st.y = 1.0 - st.y;
  float t1 = polygonSDF(st + vec2(0.0, 0.175), 3);
  float t2 = polygonSDF(st + vec2(0.1, 0.0), 3);
  float t3 = polygonSDF(st - vec2(0.1, 0.0), 3);
  color += stroke(t1, size, strokeWidth);
  color += stroke(t2, size, strokeWidth);
  color += stroke(t3, size, strokeWidth);

  // take advantage of the quadrant-ness similar to my mySolution
  float bridges = mix(
                    mix(t1, t2, step(0.5, st.y)),
                    mix(t3, t2, step(0.5, st.y)),
                  step(0.5, st.x));

  color = bridge(color, bridges, size, strokeWidth);
  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += vec3(0.0, 1.0, 0.0) * mySolution(st);
  color += vec3(1.0, 0.0, 0.0) * theirSolution(st);

  // Their solution isn't even in the center!
  color += vec3(1.0) * (1.0 - step(0.05, length(st - CENTER)));

  gl_FragColor = vec4(color, 1.0);
}
