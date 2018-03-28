float flip(float v, float pct) {
  return mix(v, 1.0 - v, pct);
}

vec2 flip(vec2 v, float pct) {
  return mix(v, 1.0 - v, pct);
}

#pragma glslify: export(flip)
