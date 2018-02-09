#pragma glslify: stroke = require('./lib/drawing/stroke')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  color += stroke(st.x, 0.5, 0.15);
  gl_FragColor = vec4(color, 1.0);
}
