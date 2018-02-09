#pragma glslify: triangleSDF = require('./triangleSDF')

float rhombusSDF(vec2 st) {
  float triangle = triangleSDF(st);
  float invertedTriangle = triangleSDF(vec2(st.x, 1.0 - st.y));
  return max(triangle, invertedTriangle);
}

#pragma glslify: export(rhombusSDF)
