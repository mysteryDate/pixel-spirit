#pragma glslify: stroke = require('./lib/drawing/stroke')
#define PI 3.14159

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float offset = cos(st.y * PI) * 0.15;
  color += stroke(st.x, 0.25 + offset, 0.1);
  color += stroke(st.x, 0.5 + offset, 0.1);
  color += stroke(st.x, 0.72 + offset, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
