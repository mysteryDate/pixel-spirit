float circle(vec2 st) {
  return length(st - 0.5) * 2.0;
}

#pragma glslify: export(circle)
