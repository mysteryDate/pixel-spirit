float flip(float v, float pct) {
  return mix(v, 1.0 - v, pct);
}

#pragma glslify: export(flip)
