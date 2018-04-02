#pragma glslify: rhombusSDF = require('./lib/sdf/rhombusSDF')
#pragma glslify: fill = require('./lib/drawing/fill')
#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')

#define PI 3.14159
vec3 theirSolution(vec2 st) {
  vec3 color = vec3(0.0);

  st -= 0.5;
  float r = dot(st, st);
  float a = atan(st.y, st.x) / PI;

  float t = map(sin(u_time/4.0), -1.0, 1.0, 0.0, 1.0);
  vec2 uv = vec2(a, r);
  vec2 grid = vec2(3.0, 10.0 * log(r) * t + 1.0);
  vec2 uvInteger = floor(uv * grid);
  uv.x += 0.5 * mod(uvInteger.y, 2.0 * (1.0 - t));
  vec2 uvFloat = fract(uv * grid);
  float shape = rhombusSDF(uvFloat);
  float size = (1.0 - t) + 1.0;
  color += 1.0 - smoothstep(size - 0.5, size + 0.5, shape);
  color *= vec3(hash(uvFloat / 1000.0 + t), 1.0);
  vec3 invColor = 1.0 - color;
  float invT = map(sin(u_time/2.0), -1.0, 1.0, 0.0, 1.0);
  color = mix(color, invColor, invT);

  return color;
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += theirSolution(st);

  gl_FragColor = vec4(color, 1.0);
}
