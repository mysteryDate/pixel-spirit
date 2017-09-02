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
  float intensity = 0.0;
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  intensity += fill(circleSDF(st), 0.65);
  vec2 offset = vec2(0.5) * sin(u_time / 5.0);
  intensity -= fill(circleSDF(st - offset), 0.65);

  vec3 color = intensity * vec3(1.0, 0.9, 0.8);
  gl_FragColor = vec4(color + vec3(0.5), 1.0);
  // gl_FragColor = vec4(sin(iGlobalTime), st, 1.0);
}
