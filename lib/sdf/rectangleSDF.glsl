float rectangleSDF(vec2 st, vec2 s) {
  st = st * 2.0 - 1.0;
  return max(abs(st.x/s.x), abs(st.y/s.y));
}

float rectangleSDF(vec2 st) { // For squares
  return rectangleSDF(st, vec2(1.0));
}

#pragma glslify: export(rectangleSDF)
