float rays(vec2 st, int N) {
  st -= 0.5;
  float theta = atan(st.y, st.x) / (2.0 * PI);
  return fract(theta * float(N));
}

#pragma glslify: export(rays)