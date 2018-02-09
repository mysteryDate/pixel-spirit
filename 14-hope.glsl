#pragma glslify: vesicaSDF = require('./lib/sdf/vesicaSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: flip = require('./lib/drawing/flip')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;
  float t = sin(5.0 * u_time) * 0.5 + 0.5;
  float t2 = sin(5.0 * u_time/1.7 + 0.5) * 0.5 + 0.5;
  float t3 = sin(5.0 * u_time/1.2 + 0.5) * 0.5 + 0.5;

  float sdf = vesicaSDF(st, 0.2);
  color += flip(fill(sdf, 0.5),
    step((st.x + st.y) * 0.5, 0.5));

  gl_FragColor = vec4(color.r, t, t2, 1.0);
}
