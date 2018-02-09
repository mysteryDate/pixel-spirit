const float sqrt3over2 = sqrt(3.0)/2.0;

float hexagonSDF(vec2 st) {
  st = abs(2.0 * st - 1.0);
  float result = sqrt3over2 * st.x + 0.5 * st.y;
  result = max(result, abs(st.y));
  return result;
}

#pragma glslify: export(hexagonSDF)
