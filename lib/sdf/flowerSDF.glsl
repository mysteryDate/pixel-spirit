float flowerSDF(vec2 st, int N) {
  st = 2.0 * st - 1.0;
  float radius = 2.0 * length(st);
  float angle = atan(st.y, st.x);
  float petalNum = 0.5 * float(N);
  return 1.0 - (abs(0.5 * cos(angle * petalNum)) + 0.5) / radius;
}

#pragma glslify: export(flowerSDF)
