// Prime factorization diagram
//
// Copyright (c) 2012 John Graham-Cumming
//
// Draws a picture of the numbers 1 to 100 as a square.  Each number
// is represented by a circle broken up into arcs of equal size.  Each
// arc represents a prime factor of the number such that all the arcs
// together form the original number.  Each prime is given a unique
// color.
//
// Inspired by the prime factorization sweater:
// http://sonderbooks.com/blog/?p=843

// 25 distinct RGB colors generated using the generating service on
// http://phrogz.net/css/distinct-colors.html.  This tries to find
// visually distinct colors that humans will be able to distinguish.

int[] colors = { #c75058, #503973, #00574b, #c7be3c, #e3b6bc, #daccff, 
#e5fffa, #ffaa00, #e31776, #3228c7, #80ffcc, #735322, #ffb3e0, #120b73, 
#67736d, #e3822d, #735067, #4d70ff, #1aff66, #e3c8b6, #030102, #455173, 
#003b00, #ff5500, #3b0033, #1784e3, #52ab44, #ffad99, #ab22a2, #77b2c7, 
#141f0f, #ab2611, #bb00ff, #002b3b, #e5ffb2, #572323, #cf99ff, #00bbff, 
#4d5734, #1f0303, #150c1f, #17d5e3, #a6e300 };

// This is the size of the square on which the prime factorization is
// drawn.  This can be made much larger than the screen for saving a
// large file using saveFrame()

int side = 1024;

// When set to true the factors are printed inside the circles,
// otherwise just colors are used

boolean number = true;

// I do everything in setup() because there's no animation and
// therefore no reason to have code in draw()

void setup() {
    size(side, side);
    background(255);
    stroke(255);
    strokeWeight(2);
    smooth();
    textAlign(CENTER, CENTER);

    int square = 12;
    int[] primes = new int[square * square];
    int space = side/square - 2;
    int used = 0;
  
    for (int c = 0; c < square; c++ ) {
        for (int r = 0; r < square; r++ ) {
          int n = r+1 + c*square;
          if ( n != 1 ) {
            
            // Factorize the number into its prime factors and
            // determine if it was itself prime.  If so, then assign
            // the next color available to this number for future use.
            
            int[] f = factor(n);
            
            if ( f.length == 1 ) {
              primes[n] = used;
              used += 1;              
            }
            
            float start_angle = PI / 4;
            float angle = start_angle;
            float per_factor = (2 * PI) / f.length;
            float x = space*(r+0.5);
            float y = space*(c+0.5);
            
            // First draw the arcs themselves with the right colors
            // based on the prime factor each represents.  Then draw
            // white lines across the circle that break up the arcs
            // and (if necessary) add the number itself.
            
            for ( int i = 0; i < f.length; i++ ) {
              fill(colors[primes[f[i]]]);
              arc(x, y, space, space, angle, angle+per_factor);
              angle += per_factor;
            }
            
            if ( f.length > 1 ) {
              angle = start_angle;
              for ( int i = 0; i < f.length; i++ ) {
                line( x, y, x + space/2 * cos(angle), y + space/2.0 *
		      sin(angle) );
                line( x, y, x + space/2 * cos(angle+per_factor), 
                  y + space/2.0 * sin(angle+per_factor) );
                
                if ( number ) {
                  opposite(colors[primes[f[i]]]);
                  text(f[i], x + space/4*cos(angle+per_factor/2),
                    y + space/4*sin(angle+per_factor/2));
                }
                
                angle += per_factor;
              }
            } else {
              if ( number ) {
                opposite(colors[primes[n]]);
                text(n, x, y);
              }
            }
          } else {
            if ( number ) {
              opposite(#FFFFFF);
              text(1, space/2, space/2);
            }
          }
        }
    }
    
    saveFrame();
}

// factor: return an ordered list (smallest to largest) of the prime
// factors of an integer.
int[] factor(int n) {
  int factors[] = new int[0];
  
  int d = 2;
  
  while (n > 1) {
    while (n % d == 0) {
      factors = append(factors, d);
      n /= d;
    }
    d += 1;
  }
    
  return factors;
}

// opposite: set the current fill color to the 'opposite' of the
// passed in color so that it can be seen on top of it. It does this
// by calculating the Euclidean distance of the color from white (255,
// 255, 255) and having a cut off the determines whether to display
// text in white or black.
void opposite(int c) {
  float distance = sqrt(red(c)*red(c)+green(c)*green(c)+blue(c)*blue(c));

  if ( distance < 250 ) {
    fill(255);
  } else {
    fill(0);
  }
}
