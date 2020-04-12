PImage shipGraphic;
float shipRotation = 0; // radians
float shipX = 400;
float shipY = 400;
float shipOffset = 0;
int bulletIndex = 0;

float[] bulletRotations = new float[20];
float[] bulletLocations = new float[20];

void setup() {
  size(800, 800);
  shipGraphic = loadImage("ship.png");
  rectMode(CENTER); 
  imageMode(CENTER); 
 }

void draw() {
  background(51);
  text("Press space bar to shoot, A and D to rotate", 10, 30); 
  bulletHandler();
  moveShip();

}

void moveShip(){
    pushMatrix();
    translate(shipX, shipY);
    rotate(shipRotation);
    image(shipGraphic, 0, 0);
    popMatrix();
}

void bulletHandler(){
  // for each bullet in bulletLocations, fetch matching rotation
  // then render to the screen. Once 10 shots fired, trim furthermost bullet from array
  
  for (int i = 0; i < bulletLocations.length; i++) {
    pushMatrix();
    translate(shipX, shipY);
    rotate(bulletRotations[i]);
    square(0, bulletLocations[i], 5);
    bulletLocations[i] -= 1;
    popMatrix();
  }
}


void keyPressed() {
  if (key == 'a') {
    shipRotation -= 0.2;
  }
  if (key == 'd') {
    shipRotation += 0.2;
  }
  if (key == 'w') {
    shipOffset -= 4.2;
  }
   if (key == ' ') {
    bulletRotations[bulletIndex] = shipRotation; 
    bulletLocations[bulletIndex] = -40; 
    bulletIndex ++;
    if (bulletIndex > 10){
       bulletIndex = 0; 
    }
    printArray(bulletRotations);
    printArray(bulletLocations);
  }
}
