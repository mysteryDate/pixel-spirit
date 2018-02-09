#pragma glslify: triangle = require('./triangle')

float rhombus(vec2 st) {
  float triangleSDF = triangle(st);
  float invertedTriangleSDF = triangle(vec2(st.x, 1.0 - st.y));
  return max(triangleSDF, invertedTriangleSDF);
}

#pragma glslify: export(rhombus)
