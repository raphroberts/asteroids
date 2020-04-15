/*PImage[] shipGraphic = new PImage[2];
int shipImageIndex = 0;
boolean rotateLeft = false;
boolean rotateRight = false;
boolean shipShooting = false;
boolean shotFinished = false;
float shipRotationSpeed = 0.1;

float shipRotation = 0; // radians
int bulletIndex = 0;
float shipThrust = 0.5;

int maxBullets = 50;
float[] bulletRotations = new float[maxBullets];
float[] bulletLocations = new float[maxBullets];

PVector acceleration;
PVector velocity;
PVector location;

void setup() {
  size(800, 800);
  shipGraphic[0] = loadImage("ship_float.png");
  shipGraphic[1] = loadImage("ship_thrust.png");
  rectMode(CENTER); 
  imageMode(CENTER); 
  acceleration = new PVector(0, 0);
  acceleration.limit(0.1);
  velocity = new PVector(0, 0);
  location = new PVector(230, 230);
}

void draw() {
  background(51);
  text("Press space bar to shoot, A and D to rotate, and W to thrust", 10, 30); 
  bulletHandler();
  moveShip();
}

void moveShip(){
    
  location.add(velocity);
    if (rotateLeft){
      shipRotation -= shipRotationSpeed;
    }
    if (rotateRight){
      shipRotation += shipRotationSpeed;
    }
    if (location.x > width){
      location.x = 0;
    }
    if (location.y > height){
      location.y = 0;
    }
    if (location.x < 0){
      location.x = width;
    }
    if (location.y < 0){
      location.y = height;
    }
    rotate(shipRotation);
    image(shipGraphic[shipImageIndex], 0, 0);
}

void bulletHandler(){
  
  // Render all bullets / update location
  translate(location.x, location.y);
  for (int i = 0; i < bulletRotations.length; i++) {
    rotate(bulletRotations[i]);
    square(bulletLocations[i], 0, 5);
    bulletLocations[i] += 10;
    rotate(-bulletRotations[i]);
  }
  // if ship is shooting, spawn bullets
  // if bullet count gets too high, overwrite old bullets
  if(shipShooting && !shotFinished){
    println("ship rotation is " + shipRotation);
    if (bulletIndex > maxBullets-1){
       bulletIndex = 0; 
    }
    bulletRotations[bulletIndex] = shipRotation; 
    bulletLocations[bulletIndex] = 0;
    bulletIndex ++;
    shotFinished = true;
  }
    
}


void keyPressed() {
  if (key == 'a') {
    rotateLeft = true;
  }
  if (key == 'd') {
    rotateRight = true;
  }
  if (key == 'w') {
    shipImageIndex = 1;
    acceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));
    velocity.x = velocity.x + acceleration.x;
    velocity.y = velocity.y + acceleration.y;
  }
}

void keyReleased() {
  
  if (key == 'a') {
    rotateLeft = false;
  }
  if (key == 'd') {
    rotateRight = false;
  }
  if (key == 'w') {
    shipImageIndex = 0;
  }
  if (key == ' ') {
    shipShooting = true;
    shotFinished = false;
  }
}*/
