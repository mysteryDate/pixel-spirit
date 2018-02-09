#define pulse(center, width, a) step(center - width/2.0, a) * step(a, center + width/2.0)

float circleSDF(vec2 st, float radius) {
  return length(st) - radius;
}

float rectangleSDF(vec2 st, vec2 s) {
  st = st * 2.0 - 1.0;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float crossSDF(vec2 st, float s) {
  vec2 size = vec2(0.25, s);
  return min(rectangleSDF(st, size.xy), rectangleSDF(st, size.yx));
}

void main() {
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  float aspect = iResolution.x / iResolution.y;
  uv.x *= aspect;

  // vec2 st = uv * 2.0 - 1.0; // [-1, 1] in xy
  vec2 st = uv;

  float d;
  // d = circleSDF(st, 0.5);
  // d = circleSDF2(st);
  // d = rectangleSDF(st, vec2(1.0,0.5));
  d = crossSDF(st, 1.0);

  d -= 0.5;
  vec3 shape = vec3(1.0 - step(0.0, d));

  // Negative parts are red / Positive parts are blue / Green is hard to for me
  // to see / So I don't use that color...
  vec3 field = vec3(0.0);
  if (d < 0.0) {
    field.r = -d;
  } else {
    field.b = d;
  }

  float edge = pulse(0.0, 0.01, d);

  // Move the mouse horizontally to show the field:
  vec3 color = mix(shape, field + vec3(edge), iMouse.x);

  gl_FragColor = vec4(color, 1.0);
}
