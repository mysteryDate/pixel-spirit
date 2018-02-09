const float sqrt3over2 = sqrt(3.0)/2.0;

float triangle(vec2 st) {
  st = 2.0 * (2.0 * st - 1.0) ;
  return max(sqrt3over2 * abs(st.x) + 0.5 * st.y, -0.5 * st.y);
}

#pragma glslify: export(triangle)
