#pragma glslify: circle = require('./circle')

float vesica(vec2 st, float w) {
  vec2 offset = vec2(w * 0.5, 0.0);
  return max(circle(st - offset),
             circle(st + offset));
}

#pragma glslify: export(vesica)
