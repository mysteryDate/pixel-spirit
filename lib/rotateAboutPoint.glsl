#pragma glslify: rotate = require('./rotate')

vec2 rotateAboutPoint(vec2 st, float theta, vec2 point) {
  return rotate(st - point, theta) + point;
}

#pragma glslify: export(rotateAboutPoint)
