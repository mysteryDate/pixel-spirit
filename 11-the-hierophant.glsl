#pragma glslify: crossSDF = require('./lib/sdf/cross')
#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')

#define PI 3.14159

float stroke(float x, float s, float w) {
  float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
  return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

float rectSDF(vec2 st, vec2 s) {
  st = st * 2.0 - 1.0;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  // st = rotateAboutPoint(st, u_time, vec2(0.5));

  float rect = rectSDF(rotateAboutPoint(st, -u_time/2.0, vec2(0.5)), vec2(1.0));
  color += fill(rect, 0.5);
  // float cross = crossSDF(rotate(st, u_time), 1.0);
  float cross = crossSDF(rotateAboutPoint(st, u_time, vec2(0.5)), 1.0);
  color *= step(0.5, fract(cross * 4.0));
  color *= step(1.0, cross);
  color += fill(cross, 0.5 * sin(u_time) + 0.5);
  color += stroke(rect, 0.65, 0.05);
  color += stroke(rect, 0.75, 0.025);

  gl_FragColor = vec4(color, 1.0);
}
