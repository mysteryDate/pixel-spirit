#pragma glslify: hexagonSDF = require('./lib/sdf/hexagonSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')
#pragma glslify: fill = require('./lib/drawing/fill')

const float polySize = 0.6;
const float strokeWidth = 0.1;
const float smallHexSize = 0.15;
const float spacing = 0.06;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  st = st.yx;

  // My solution
  float sdf = hexagonSDF(st);
  color += stroke(sdf, polySize, strokeWidth);
  sdf = hexagonSDF(st + vec2(-spacing, 0.0));
  color += fill(sdf, smallHexSize);
  sdf = hexagonSDF(st + vec2(spacing, 1.1 * spacing));
  color += fill(sdf, smallHexSize);
  sdf = hexagonSDF(st + vec2(spacing, -1.1 * spacing));
  color += fill(sdf, smallHexSize);

  color *= 0.0; // Just to reset stuff
  // Theirs
  color += stroke(hexagonSDF(st), polySize, strokeWidth);
  color += fill(hexagonSDF(st - vec2(-0.06, -0.1)), smallHexSize);
  color += fill(hexagonSDF(st - vec2(-0.06, 0.1)), smallHexSize);
  color += fill(hexagonSDF(st - vec2(0.11, 0.0)), smallHexSize);

  gl_FragColor = vec4(color, 1.0);
}
