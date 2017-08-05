// vec2 iResolution
#define PI 3.14159

float stroke(float x, float s, float w) {
  float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
  return clamp(d, 0.0, 1.0);
}

float circleSDF(vec2 st) {
  return length(st - 0.5) * 2.0;
}

float fill(float x, float size) {
  return 1.0 - step(size, x);
}

void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  color += fill(circleSDF(st), 0.65);
  vec2 offset = vec2(0.1, 0.05);
  color -= fill(circleSDF(st - offset), 0.5);

  gl_FragColor = vec4(color, 1.0);
}
