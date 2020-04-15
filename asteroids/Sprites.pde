// FUNCTIONS RELATING TO SPRITES: Ship, Asteroids, Bullets

/*
  ___ _  _ ___ ___ 
 / __| || |_ _| _ \
 \__ \ __ || ||  _/
 |___/_||_|___|_|                     

*/

// SHIP GLOBALS

byte currentWeapon = 0; //index of current weapon, 0 = green laser
PImage[] shipGraphic = new PImage[2]; // ship image array
int shipImageIndex = 0;

float maxSpeed = 4;
boolean accelerate = false;
boolean rotateLeft = false;
boolean rotateRight = false;
float shipRotationSpeed = 0.1;
float shipRotation = 0; // radians
float shipThrust = 0.1;
PVector shipAcceleration;
PVector shipVelocity;
PVector shipLocation;

void initialiseShip(){
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(230, 230); 
}

void shipHandler(){
  // if rotate key(s) pressed, rotate ship
  // if thruster pressed, apply thruster
  // limit speed to shipMaxSpeed
}

void moveShip(){
  if (accelerate) {
    shipAcceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));
  }
  
  if (abs(shipVelocity.x + shipAcceleration.x) <= maxSpeed) {
    shipVelocity.x = shipVelocity.x + shipAcceleration.x;
  }
  if (abs(shipVelocity.y + shipAcceleration.y) <= maxSpeed) {
    shipVelocity.y = shipVelocity.y + shipAcceleration.y;
  }
  
  decelerateShip();  //allow ship to lose velocity when thrusted in different direction
    
  shipLocation.add(shipVelocity);
    if (rotateLeft){
      shipRotation -= shipRotationSpeed;
    }
    if (rotateRight){
      shipRotation += shipRotationSpeed;
    }
    if (shipLocation.x > width){
      shipLocation.x = 0;
    }
    if (shipLocation.y > height){
      shipLocation.y = 0;
    }
    if (shipLocation.x < 0){
      shipLocation.x = width;
    }
    if (shipLocation.y < 0){
      shipLocation.y = height;
    }
    rotate(shipRotation);
    image(shipGraphic[shipImageIndex], 0, 0);
    rotate(-shipRotation);
    translate(-shipLocation.x, -shipLocation.y);
    
    if (debug) {
      println("Acceleration: " + shipAcceleration);
      println("Velocity: " + shipVelocity);
      println("Location: " + shipLocation);
    }
}

void decelerateShip() {
  if (shipAcceleration.x >= 0.001) {
    shipAcceleration.sub(0.01, 0);
  } else if (shipAcceleration.x <= -0.001) {
    shipAcceleration.add(0.01, 0);
  } else {
    shipAcceleration = new PVector(0, shipAcceleration.y);
  }
  if (shipAcceleration.y >= 0.01) {
    shipAcceleration.sub(0, 0.01);
  } else if (shipAcceleration.y <= -0.001) {
    shipAcceleration.add(0, 0.01);
  } else {
    shipAcceleration = new PVector(shipAcceleration.x, 0);
  }
}

/*
  ___ _   _ _    _    ___ _____ ___ 
 | _ ) | | | |  | |  | __|_   _/ __|
 | _ \ |_| | |__| |__| _|  | | \__ \
 |___/\___/|____|____|___| |_| |___/

*/


// BULLET GLOBALS

boolean shipShooting = false;
boolean shotFinished = false;
int bulletIndex = 0;
int maxBullets = 50;
float[] bulletRotations = new float[maxBullets];
float[] bulletLocations = new float[maxBullets];


void bulletHandler(){
  
  // Render all bullets / update location
  translate(shipLocation.x, shipLocation.y);
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

/*
    _   ___ _____ ___ ___  ___ ___ ___  
   /_\ / __|_   _| __| _ \/ _ \_ _|   \ 
  / _ \\__ \ | | | _||   / (_) | || |) |
 /_/ \_\___/ |_| |___|_|_\\___/___|___/ 
     
*/

// temp code
int collisionObjectX = 100;
int collisionObjectY = 100;
 
void asteroidHandler(){
  // iterate through asteroid array and update their positions
  // movement can be simple, just linear and “wrap” around screen edges
  // as per original game.
  
  // temp code
  square(collisionObjectX, collisionObjectY, 50);

}
