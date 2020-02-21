#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// simulation texture state, swapped each frame
uniform sampler2D state;

// from The Book of Shaders
float random(vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// look up individual cell values
vec3 get(int x, int y) {
  return texture2D(state, (mod(gl_FragCoord.xy + vec2(x, y), resolution)) / resolution).rgb;
}

// change color
vec3 munch(vec3 center, int x, int y) {
  vec3 neighbor = get(x, y);
  const float minimum = 0.0625;
  // if adjacent to a hostile neighbor or empty
  if (
    (neighbor.g > 0.0 && center.r > 0.0)
    ||(neighbor.b > 0.0 && center.g > 0.0)
    ||(neighbor.r > 0.0 && center.b > 0.0)
  ) {
    gl_FragColor = vec4(vec3(neighbor), 1.0);
  }
  else if (center.r < minimum && center.g < minimum && center.b < minimum) {
    gl_FragColor = vec4(vec3(neighbor - sign(neighbor) * vec3(0.0125)), 1.0);
  } else {
    gl_FragColor = vec4(center, 1.0);
  }
  return neighbor;
}

void main() {
  float r = random(gl_FragCoord.xy * 1.234 + time);
  float i = r * 8.0;
  vec3 center = get(0, 0); // cache this so it so lookup doesn't happen every munch
  
  if (i < 1.0) {munch(center, - 1, - 1); }
  else if (i < 2.0) {munch(center, - 1, 0); }
  else if (i < 3.0) {munch(center, - 1, 1); }
  else if (i < 4.0) {munch(center, 0, - 1); }
  else if (i < 5.0) {munch(center, 0, 1); }
  else if (i < 6.0) {munch(center, 1, - 1); }
  else if (i < 7.0) {munch(center, 1, 0); }
  else if (i < 8.0) {munch(center, 1, 1); }
}
