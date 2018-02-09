float heart(vec2 st) {
  float h;
  st -= vec2(0.5, 0.8);
  float r = 5.0 * length(st);
  st = normalize(st);
  h = st.y * pow(abs(st.x), 0.67);
  h /= st.y + 1.5;
  h -= 2.0 * st.y - 1.26;
  h = r - h;
  return h;
}

#pragma glslify: export(heart)
