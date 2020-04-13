/* Proposed changes to be made from test.pde: (comment out other file to test)
  UPDATE 2:
  1) added debug mode (print stats to console if true)
  2) Experimental bullet style + sound effect
  3) Fixed thruster?
  
  KNOWN ISSUES -
  1) Holding space allows infinite quick bullet firing
*/

//Added globals
import processing.sound.*; //import sound effects library, results in console warning
SoundFile[] soundArray = new SoundFile[3]; //index corresponds to sound of the currentWeapon index

float maxSpeed = 4;
boolean accelerate = false;
boolean debug = true; //print stats to console for debugging purposes

byte currentWeapon = 0; //index of the current weapon, 0 = green laser
//End test 2 added globals


PImage[] shipGraphic = new PImage[2];
int shipImageIndex = 0;
boolean rotateLeft = false;
boolean rotateRight = false;
boolean shipShooting = false;
boolean shotFinished = false;
float shipRotationSpeed = 0.1;

float shipRotation = 0; // radians
int bulletIndex = 0;
float shipThrust = 0.1;

int maxBullets = 50;
float[] bulletRotations = new float[maxBullets];
float[] bulletLocations = new float[maxBullets];

PVector acceleration;
PVector velocity;
PVector location;

void settings() {
  size(800, 800);
}

void setup() {
  frameRate(60);
  shipGraphic[0] = loadImage("ship_float.png");
  shipGraphic[1] = loadImage("ship_thrust.png");
  rectMode(CENTER); 
  imageMode(CENTER); 
  acceleration = new PVector(0, 0);
  acceleration.limit(0.1);
  velocity = new PVector(0, 0);
  location = new PVector(230, 230);
  
  //populate sounds
  soundArray[0] = new SoundFile(this, "sounds/laserfire01.mp3");
}

void draw() {
  background(51);
  text("Press space bar to shoot, A and D to rotate, and W to thrust", 10, 30); 
  bulletHandler();
  moveShip();
}

void moveShip(){
  if (accelerate) {
    acceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));
  }
  
  if (abs(velocity.x + acceleration.x) <= maxSpeed) {
    velocity.x = velocity.x + acceleration.x;
  }
  if (abs(velocity.y + acceleration.y) <= maxSpeed) {
    velocity.y = velocity.y + acceleration.y;
  }
  
  decelerateShip();  //allow ship to lose velocity when thrusted in different direction
    
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
    
    if (debug) {
      println("Acceleration: " + acceleration);
      println("Velocity: " + velocity);
      println("Location: " + location);
    }
}

void decelerateShip() {
  if (acceleration.x >= 0.001) {
    acceleration.sub(0.01, 0);
  } else if (acceleration.x <= -0.001) {
    acceleration.add(0.01, 0);
  } else {
    acceleration = new PVector(0, acceleration.y);
  }
  if (acceleration.y >= 0.01) {
    acceleration.sub(0, 0.01);
  } else if (acceleration.y <= -0.001) {
    acceleration.add(0, 0.01);
  } else {
    acceleration = new PVector(acceleration.x, 0);
  }
}

void bulletHandler(){
  
  // Render all bullets / update location
  translate(location.x, location.y);
  for (int i = 0; i < bulletRotations.length; i++) {
    rotate(bulletRotations[i]);
    //square(bulletLocations[i], 0, 5);
    
    //bullet experiment
    fill(15, 206, 0);
    rect(bulletLocations[i], 0, 10, 5);
    //end bullet experiment
    
    bulletLocations[i] += 10;
    rotate(-bulletRotations[i]);
  }
  fill(255, 255, 255); //set fill back to default
  
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
    accelerate = true;
    shipImageIndex = 1;
    
  }
  if (key == ' ') {
    shipShooting = true;
    shotFinished = false;
    soundArray[0].play();
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
