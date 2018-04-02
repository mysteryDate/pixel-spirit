#pragma glslify: rhombusSDF = require('./lib/sdf/rhombusSDF')
#pragma glslify: fill = require('./lib/drawing/fill')

#define PI 3.14159
vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);

  st -= 0.5;
  float r = dot(st, st);
  float a = atan(st.y, st.x) / PI;

  vec2 uv = vec2(a, r);
  vec2 grid = vec2(5.0, 20.0 * log(r));
  vec2 uvInteger = floor(uv * grid);
  uv.x += 0.5 * mod(uvInteger.y, 2.0);
  vec2 uvFloat = fract(uv * grid);
  float shape = rhombusSDF(uvFloat);
  color += fill(shape, 0.9) * step(0.75, 1.0 - r);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += theirSolution(st);

  gl_FragColor = vec4(color, 1.0);
}
