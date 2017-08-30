
#define pulse(center, width, a) step(center - width/2.0, a) * step(a, center + width/2.0)

float circleSDF(vec2 st, float radius) {
  return length(st) - radius;
}

float rectSDF(vec2 st, vec2 s) {
  st = st;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float circleSDF2(vec2 st) {
  return length(st - 0.5) * 2.0;
}

void main() {
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  float aspect = iResolution.x / iResolution.y;
  uv.x *= aspect;

  vec2 st = uv * 2.0 - 1.0; // [-1, 1] in xy

  // float d = circleSDF(st, 0.5);
  // float d = circleSDF2(st);
  float d = rectSDF(st, vec2(1.0));

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
