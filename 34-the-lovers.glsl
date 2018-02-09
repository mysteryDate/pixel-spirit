#pragma glslify: circleSDF = require('./lib/sdf/circle')
#pragma glslify: heartSDF = require('./lib/sdf/heart')
#pragma glslify: polySDF = require('./lib/sdf/polygon')

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

float flip(float v, float pct) {
  return mix(v, 1.0 - v, pct);
}

float stroke(float x, float s, float w) {
  float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
  return clamp(d, 0.0, 1.0);
}

vec3 bridge(vec3 c, float d, float s, float w) {
  c *= 1.0 - stroke(d, s, 2.0 * w);
  return c + stroke(d, s, w);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  // My solution is pretty much the same as theirs
  // after looking up the SDF
  float heart = heartSDF(st);
  color += fill(heart, 0.5);

  color -= stroke(polySDF(st, 3), 0.15, 0.05);

  gl_FragColor = vec4(color, 1.0);
}
