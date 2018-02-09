#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: flip = require('./lib/drawing/flip')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float rect = rectangleSDF(st, vec2(0.5, 1.0));
  float diag = (st.x + st.y) * 0.5;
  color += flip(
    fill(rect, 0.6),
    stroke(diag, 0.5, 0.01)
  );

  gl_FragColor = vec4(color, 1.0);
}
