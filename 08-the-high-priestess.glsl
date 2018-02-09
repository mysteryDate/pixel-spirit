#pragma glslify: stroke = require('./lib/drawing/stroke')

float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += stroke(circleSDF(st), 0.5, 0.05);

  gl_FragColor = vec4(color, 1.0);
}
