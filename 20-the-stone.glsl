#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st = rotateAboutPoint(st, radians(45.0), vec2(0.5));
  float sdf = rectangleSDF(st, vec2(1.0));
  color += fill(sdf, 0.4);
  color -= stroke(st.x, 0.5, 0.02);
  color -= stroke(st.y, 0.5, 0.02);

  gl_FragColor = vec4(color, 1.0);
}
