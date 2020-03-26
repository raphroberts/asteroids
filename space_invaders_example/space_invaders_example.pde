// invader_matrix represents pixels in a 6 * 6 grid
int[] invader_matrix = {
  1, 0, 0, 0, 0, 1, 
  1, 1, 1, 1, 1, 1, 
  1, 0, 1, 1, 0, 1, 
  1, 1, 1, 1, 1, 1, 
  1, 0, 0, 0, 0, 1, 
  1, 1, 0, 0, 1, 1};


void setup() {
  size(800, 600);
  noCursor();
  noSmooth();
}

void draw() {
  background(33);
  drawInvader();
  drawPlayer();
}

void drawInvader() {
  fill(250);
  noStroke();
  // position to draw "pixel"
  int xpos = 0;
  int ypos = 0;
  int pixel_counter = 0;

  // loop through invader_matrix and render "pixels"
  for (int i = 0; i < invader_matrix.length; i++) {
    if (invader_matrix[i] == 1) {
      rect(xpos*10, ypos*10, 10, 10);
      xpos += 1;
    } else {
      xpos += 1;
    }
    // move to "new line" every 6 "pixels"
    pixel_counter ++;
    if (pixel_counter == 6) {
      ypos += 1;
      xpos = 0;
      pixel_counter = 0;
    }
  }
}

void drawPlayer() {
  fill(random(225,255));
  rect(mouseX-5, height-50, 10, 10);
  rect(mouseX-25, height-40, 50, 10);
  strokeCap(SQUARE);
  strokeWeight(10); 
  stroke(random(160,180));
  line(mouseX-40,height-25,mouseX+40,height-25);
  stroke(random(120,150));
  line(mouseX-50,height-15,mouseX+50,height-15);
}
