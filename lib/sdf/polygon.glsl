#define PI 3.14159

float polygon(vec2 st, int numSides) {
  st = 2.0 * st - 1.0;
  float a = atan(st.x, st.y) + PI;
  float r = length(st);
  float v = 2.0 * PI/float(numSides);
  return cos(floor(0.5 + a/v) * v - a) * r;
}

#pragma glslify: export(polygon)
