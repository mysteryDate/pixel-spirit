#pragma glslify: triangleSDF = require('./lib/sdf/triangleSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st.y = 1.0 - st.y;
  vec2 ts = vec2(st.x, 0.82 - st.y);
  color += fill(triangleSDF(st), 0.7);
  color -= fill(triangleSDF(ts), 0.36);

  gl_FragColor = vec4(color, 1.0);
}
