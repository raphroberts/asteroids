/* Proposed changes to be made from test.pde: (comment out other file to test)
 1) size within settings() to allow running in stand-alone files (for testing)
 2) Refactor ship movement from keypressed into moveShip, added accelerate boolean check to maintain consistency with other keyPressed keys
 3) Modify ship movement to respond to when 'W' is held down
 4) Moved Ship Shooting from keyReleased into keyPressed for most instant respone. What do you think? I'm happy either way
 
 KNOWN ISSUES: Ship movement is jerky. I'll be happy to add this to my task list and work on it more, or if someone else comes up with a better solution we can use that
 */

//Added globals
float maxSpeed = 3;
boolean accelerate = false;

PImage[] shipGraphic = new PImage[2];
int shipImageIndex = 0;
boolean rotateLeft = false;
boolean rotateRight = false;
boolean shipShooting = false;
boolean shotFinished = false;
float shipRotationSpeed = 0.1;

float shipRotation = 0; // radians
int bulletIndex = 0;
float shipThrust = 0.02;

int maxBullets = 50;
float[] bulletRotations = new float[maxBullets];
float[] bulletLocations = new float[maxBullets];
float bulletRotation = 0; // radians

// Bullet array to store PVector information for each bullet
int[][] bulletArray =  new int[20][3];  

int collisionObjectX = 100;
int collisionObjectY = 100;


PVector acceleration;
PVector velocity;
PVector location;

PVector bulletAcceleration;
PVector bulletVelocity;
PVector bulletLocation;

void settings() {
  size(800, 800);
  //bulletArray[0][0] = 1;
  //bulletArray[0][1] = 2;
  //bulletArray[0][2] = 3;
  //println(bulletArray[0][1]);
}

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
  
  bulletAcceleration = new PVector(0, 0);
  bulletVelocity = new PVector(0, 0);
  bulletLocation = new PVector(230, 230);
  
}

void draw() {
  background(51);
  square(collisionObjectX, collisionObjectY, 50);

  text("Press space bar to shoot, A and D to rotate, and W to thrust", 10, 30); 
  //bulletHandler();
  moveShip();
  moveBullet();
  checkCollision();
}

void checkCollision() {
  // check if ship has hit the square
  if (dist(location.x, location.y, collisionObjectX, collisionObjectY) < 50) {
    println("ship collision");
  }
  // check if bullet has hit the square
  if (dist(bulletLocation.x, bulletLocation.y, collisionObjectX, collisionObjectY) < 100) {
    println("bullet collision");
  }
}

void moveBullet() {
  bulletAcceleration.x = 18 * cos(bulletRotation);
  bulletAcceleration.y = 18 * sin(bulletRotation);
  bulletLocation.add(bulletAcceleration);
  square(bulletLocation.x, bulletLocation.y, 50);
}


void moveShip() {
  
  translate(location.x, location.y);
  if (accelerate) {
    acceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));
  }

  if (abs(velocity.x + acceleration.x) <= maxSpeed) {
    velocity.x = velocity.x + acceleration.x;
  }
  if (abs(velocity.y + acceleration.y) <= maxSpeed) {
    velocity.y = velocity.y + acceleration.y;
  }

  location.add(velocity);
  if (rotateLeft) {
    shipRotation -= shipRotationSpeed;
  }
  if (rotateRight) {
    shipRotation += shipRotationSpeed;
  }
  if (location.x > width) {
    location.x = 0;
  }
  if (location.y > height) {
    location.y = 0;
  }
  if (location.x < 0) {
    location.x = width;
  }
  if (location.y < 0) {
    location.y = height;
  }
  rotate(shipRotation);
  image(shipGraphic[shipImageIndex], 0, 0);
  rotate(-shipRotation);
  translate(-location.x, -location.y);
}


void bulletHandler() {

  // Render all bullets / update location
  translate(location.x, location.y);

  bulletAcceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));

  // For every bullet in bulletArray, read its PVector info and render
  for (int i = 0; i < bulletRotations.length; i++) {
    square(bulletLocations[i], 0, 5);
    bulletLocations[i] += 10;
    rotate(-bulletRotations[i]);
  }

  // if ship is shooting, append new bullet to 2d bulletArray
  if (shipShooting && !shotFinished) {
    println("ship rotation is " + shipRotation);
    if (bulletIndex > maxBullets-1) {
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
    accelerate = true;
    shipImageIndex = 1;
  }
  if (key == ' ') {
    shipShooting = true;
    shotFinished = false;
    bulletLocation.x = location.x;
    bulletLocation.y = location.y;
    bulletRotation = shipRotation;
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
    accelerate = false;
  }
}
