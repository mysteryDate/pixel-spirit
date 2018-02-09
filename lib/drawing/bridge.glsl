#pragma glslify: stroke = require('./stroke')

vec3 bridge(vec3 c, float d, float s, float w) {
  c *= 1.0 - stroke(d, s, 2.0 * w);
  return c + stroke(d, s, w);
}

#pragma glslify: export(bridge)
