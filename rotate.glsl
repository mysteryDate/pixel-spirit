#pragma glslify: rotate = require(./lib/rotate)
#define PI 3.14159

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  st = rotate(st - vec2(0.5), u_time) + vec2(0.5);
  vec2 diff = st - vec2(0.7);

  color += 1.0 - 100.0 * dot(diff, diff);
  gl_FragColor = vec4(color, 1.0);
}
