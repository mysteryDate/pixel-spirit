float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

#pragma glslify: export(circleSDF)
