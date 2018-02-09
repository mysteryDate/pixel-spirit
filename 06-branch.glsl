#pragma glslify: stroke = require('./lib/drawing/stroke')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float sdf = 0.5 + (st.x - st.y) * 0.5;
  color += stroke(sdf, 0.5, 0.1);

  gl_FragColor = vec4(color, 1.0);
}
