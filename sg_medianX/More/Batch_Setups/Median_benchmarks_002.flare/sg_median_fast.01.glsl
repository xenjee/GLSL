// Input texture (changed)
uniform sampler2D front;


//declare adsk 'magic' uniform and 'magic variables (probably too many)

// vec2 res = vec2(adsk_result_w, adsk_result_h);
// vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );

// only this one needed, apparently
uniform float adsk_result_w, adsk_result_h;



// from original
#ifndef G3D
// vec2(1/width, 1/height) of the texture
    uniform vec2 size;
#else
#    define size g3d_sampler2DInvSize(front)
#endif 


// from original: Change these 2 defines to change precision,
// #define vec vec3
// #define toVec(x) x.rgb

#define vec vec4
#define toVec(x) x.rgba


// from original
#define s2(a, b)				temp = a; a = min(a, b); b = max(temp, b);
#define mn3(a, b, c)			s2(a, b); s2(a, c);
#define mx3(a, b, c)			s2(b, c); s2(a, c);

#define mnmx3(a, b, c)			mx3(a, b, c); s2(a, b);                                   // 3 exchanges
#define mnmx4(a, b, c, d)		s2(a, b); s2(c, d); s2(a, c); s2(b, d);                   // 4 exchanges
#define mnmx5(a, b, c, d, e)	s2(a, b); s2(c, d); mn3(a, c, e); mx3(b, d, e);           // 6 exchanges
#define mnmx6(a, b, c, d, e, f) s2(a, d); s2(b, e); s2(c, f); mn3(a, b, c); mx3(d, e, f); // 7 exchanges

void main() {

// added	
	vec2 coords = gl_FragCoord.xy / vec2( adsk_result_w, adsk_result_h );


// from original
  vec v[9];

// from original: Add the pixels which make up our window to the pixel array.
  for(int dX = -1; dX <= 1; ++dX) {
    for(int dY = -1; dY <= 1; ++dY) {		
      vec2 offset = vec2(float(dX), float(dY));
	
		    

// If a pixel in the window is located at (x+dX, y+dY), put it at index (dX + R)(2R + 1) + (dY + R) of the
// pixel array. This will fill the pixel array, with the top left pixel of the window at pixel[0] and the bottom right pixel of the window at pixel[N-1].

	  	  
      v[(dX + 1) * 3 + (dY + 1)] = toVec(texture2D(front, gl_TexCoord[0].xy + offset * (size/1000.0)));
    }
  }

  vec temp;

// Starting with a subset of size 6, remove the min and max each time
  mnmx6(v[0], v[1], v[2], v[3], v[4], v[5]);
  mnmx5(v[1], v[2], v[3], v[4], v[6]);
  mnmx4(v[2], v[3], v[4], v[7]);
  mnmx3(v[3], v[4], v[8]);
  toVec(gl_FragColor) = v[4];

}








