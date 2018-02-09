#pragma glslify: rotateAboutPoint = require('./lib/rotateAboutPoint')
#pragma glslify: rectangleSDF = require('./lib/sdf/rectangleSDF')
#pragma glslify: stroke = require('./lib/drawing/stroke')

const int numSquares = 4;
void main() {
  vec3 color = vec3(0.0);
  vec2 st = gl_FragCoord.xy / iResolution.xy;

  float rectSize = 0.29;
  float strokeWidth = 0.05 + sin(u_time * 1.3)/64.;
  float offset = 0.02 + sin(u_time)/16.;

  st = rotateAboutPoint(st, radians(-45.0), vec2(0.5));
  vec2 s = vec2(1.0);

  for(int i = 0; i < numSquares; i++)
  {
    float currentOffset = float(i) - float(numSquares) / 2.0 + 0.5;
    color += stroke(rectangleSDF(st + offset * currentOffset, s), rectSize + (float(i))/40., strokeWidth);
  }
  // I like my method better than theirs so I'm not including it
  color *= vec3(st, 1.0);
  color.b += sin(u_time);

  gl_FragColor = vec4(color, 1.0);
}
