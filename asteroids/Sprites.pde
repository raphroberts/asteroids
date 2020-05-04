// FUNCTIONS AND GLOBALS RELATING TO SPRITES: Ship, Asteroids, Weapons

/*
  ___ _  _ ___ ___ 
 / __| || |_ _| _ \
 \__ \ __ || ||  _/
 |___/_||_|___|_|                     
 
 */

// SHIP GLOBALS

// Ship weapon
byte currentWeapon = 0; //index of current weapon, 0 = green laser

// Ship graphics
PImage[] shipGraphic = new PImage[3]; // ship image array
int shipImageIndex = 0;

// Thruster graphics
PImage[] thrusterGraphic = new PImage[3]; // ship image array
int thrusterImageIndex = 1;

// Shield graphics
PImage[] shieldGraphic = new PImage[3]; // ship image array
int shieldImageIndex = 0;

// Ship movement

PVector shipAcceleration;
PVector shipVelocity;
  
float maxSpeed = 4;
boolean accelerate = false;
boolean rotateLeft = false;
boolean rotateRight = false;
float shipRotationSpeed = 0.1;
float shipRotation = -1.56; // radians
float shipThrust = 0.1;
PVector shipLocation = new PVector(width/2, height/2);

void initialiseSprites() {
  
  // Reset ship PVector
  shipRotation = -1.56; // radians
  shipVelocity = new PVector(0, -0.1);
  shipLocation = new PVector(width/2,height-height/3); 
  bossLocation = new PVector(width/2,-height/3);
  
  // Return boss to full health
  bossStrength = bossInitialStrength;
  bossSpeed = bossInitialSpeed;
  bossDefeated = false;
  
  //Bullet setup
  bulletLocation = new PVector(width/2, height/2);
  
  // Default weapon
  changeWeapon(1);

}

void moveShip() {
  weaponCooldownTick++; //increase cooldown tick
  
  // Handle ship movement & thruster sound
  if (accelerate) {
    shipAcceleration = new PVector(shipThrust * cos(shipRotation), shipThrust * sin(shipRotation));
    if (!soundArray[13].isPlaying()) {
      soundArray[13].rewind();
      soundArray[13].play();
    }
  }
  else if (soundArray[13].isPlaying())
    soundArray[13].pause();

  if (abs(shipVelocity.x + shipAcceleration.x) <= maxSpeed) {
    shipVelocity.x = shipVelocity.x + shipAcceleration.x;
  }
  if (abs(shipVelocity.y + shipAcceleration.y) <= maxSpeed) {
    shipVelocity.y = shipVelocity.y + shipAcceleration.y;
  }

  decelerateShip();  //allow ship to lose velocity when thrusted in different direction

  shipLocation.add(shipVelocity);
  if (rotateLeft) {
    shipRotation -= shipRotationSpeed;
  }
  if (rotateRight) {
    shipRotation += shipRotationSpeed;
  }
  if (shipLocation.x > width + screenPadding) {
    shipLocation.x = 0 - screenPadding;
  }
  if (shipLocation.y > height + screenPadding) {
    shipLocation.y = 0 - screenPadding;
  }
  if (shipLocation.x < 0 - screenPadding) {
    shipLocation.x = width + screenPadding;
  }
  if (shipLocation.y < 0 - screenPadding) {
    shipLocation.y = height + screenPadding;
  }
  
  translate(shipLocation.x, shipLocation.y);  
  rotate(shipRotation);
  
  // If ship is being damaged, render shield
  if (isBeingDamaged){
    image(shieldGraphic[shieldImageIndex], 0, 0);
  }
  
  // Render ship
  image(shipGraphic[shipImageIndex], 0, 0);
  
  // If ship is thrusting, render thrusters
  if (accelerate){
    image(thrusterGraphic[thrusterImageIndex], -50, 0);
  }
  
  rotate(-shipRotation);
  translate(-shipLocation.x, -shipLocation.y);

  if (debug) {
    //println("Acceleration: " + shipAcceleration);
    //println("Velocity: " + shipVelocity);
    //println("Location: " + shipLocation);
  }
}

void decelerateShip() {
  // Handle ship deceleration
  
  if (shipAcceleration.x >= 0.01) {
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
 __      __                          
 \ \    / /__ __ _ _ __  ___ _ _  ___
  \ \/\/ / -_) _` | '_ \/ _ \ ' \(_-<
   \_/\_/\___\__,_| .__/\___/_||_/__/
                  |_|                
*/


// WEAPON GLOBALS

boolean gunReloaded = true;
PVector bulletVelocity;
PVector bulletLocation;
float bulletRotation = 0; // radians

int bulletSpeed = 18;
int bulletID = 1; // can be used later for different bullet types
float bulletSize = 1;

// Array list for storing bullet data
//index 0 = bullet ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = initial rotation, 7 = bulletType, 8 = bullet damage

ArrayList<Float[]> bulletObject = new ArrayList<Float[]>(); 

int weaponIndex = 1; //0 = single pulse laser
int shieldIndex = 1;
int thrusterIndex = 1;
boolean gameStarted = false;

int weaponCooldown = -1; //must wait this # of frames per shot 
int weaponCooldownTick = 0; //current ticket of cooldown
String shieldName = "Basic";
String thrusterName = "Standard";

void createBullet() {
  // Create a new bullet when the ship fires the gun
  // shoot bullet as long as gun is reloaded
  if (gunReloaded && weaponCooldownTick > weaponCooldown) {
    weaponCooldownTick = 0;
    
    // Set bullet location/rotation to match ship
    bulletLocation.x = shipLocation.x;
    bulletLocation.y = shipLocation.y;
    bulletRotation = shipRotation;
    
    // Add bullet depending on current weapon that is firing it
    //index 0 = bullet ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = initial rotation, 7 = bulletType, 8 = bullet damage
    if (weaponIndex == 1) { //standard laser gun
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation, 1.0, 8.0});
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      if (bulletshotIndex > 2) //allow mulitple sound channels for this bullet
        bulletshotIndex = 0;
    }
    else if (weaponIndex == 2) { //triple shot
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation, 2.0, 15.0});
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      if (bulletshotIndex > 2) //allow mulitple sound channels for this bullet
        bulletshotIndex = 0;
    }
    else if (weaponIndex == 3) { //laser cannon
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * 0.1 * cos(bulletRotation)), (bulletSpeed * 0.1 * sin(bulletRotation)), bulletRotation, 3.0, 200.0});
      soundArray[4].rewind();
      soundArray[4].play();
    }
    else if (weaponIndex == 4) {
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * 0.1 * cos(bulletRotation)), (bulletSpeed * 0.1 * sin(bulletRotation)), bulletRotation, 4.0, 40.0});
      soundArray[laserShotIndex].rewind();
      soundArray[laserShotIndex++].play();
      if (laserShotIndex > 12) //allow mulitple sound channels for this bullet
        laserShotIndex = 10;
    }
  }
}

void drawAndMoveBullets() {
  //iterate through all bullet objects draw and update their positions

  for (int i = 0; i < bulletObject.size(); i++) {
    Float[] obj = bulletObject.get(i);
    PVector bulletCoords = new PVector(obj[1], obj[2]);
    PVector bulletVelocity = new PVector(obj[4], obj[5]);
    int bulletType = round(obj[7]);
    
    translate(bulletCoords.x, bulletCoords.y);
    rotate(obj[6]);
    noStroke();
    
    if (bulletType == 1) {
      fill(#b6ed57);
      rect(20, 0, 15, 5);
    }
    else if (bulletType == 2) {
      fill(#b6ed57);
      rect(-20, 30, 15, 5);
      rect(20, 0, 15, 5);
      rect(-20, -30, 15, 5);
    }
    else if (bulletType == 3) {
      fill(#31A5FF);
      rect(20, 0, 35, 10);
    }
    
    
    rotate(-obj[6]);
    translate(-bulletCoords.x, -bulletCoords.y);
    fill(255);

    //move
    if (obj[7] != 4.0) { // laser beam moves faster, so check for it
      obj[1] = obj[1] + (int)(bulletSpeed * cos(obj[6])); //move in x direction given the object velocity
      obj[2] = obj[2] + (int)(bulletSpeed * sin(obj[6])); //move in y direction given the object velocity
    }
    else {
      obj[1] = obj[1] + (int)(bulletSpeed * cos(obj[6]) * 2); 
      obj[2] = obj[2] + (int)(bulletSpeed * sin(obj[6]) * 2); 
    }
  }
}

/*
   _   ___ _____ ___ ___  ___ ___ ___  
  /_\ / __|_   _| __| _ \/ _ \_ _|   \ 
 / _ \\__ \ | | | _||   / (_) | || |) |
/_/ \_\___/ |_| |___|_|_\\___/___|___/ 
 
 */

// Array list to store enemy object data
//index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1)
/*
object ID as follows. This must match the enemyGraphics ID:
 0 = large asteroid ID 1
 1 = large asteroid ID 2
 2 = large asteroid ID 3
 3 = small asteroid ID 1
 4 = small asteroid ID 2
 5 = small asteroid ID 3
 */
ArrayList<int[]> enemyObject = new ArrayList<int[]>(); 

// Asteroid graphic images (large and small)
PImage[] enemyGraphics = new PImage[6]; //index should correspond to enemyObject ID

void createAsteroid(int x, int y, String size) {
  //create an asteroid at the given x, y coords, with size = "large" or "small"
  
  //pick random asteroid from ID 0-2
  int ID;
  PVector initialVelocity = new PVector(0, 0);
    
  switch (size) {
    case "large":
      ID = randomInt(0, 2);
      initialVelocity = new PVector(random(-gameLevel + -2, gameLevel + 2), random(-gameLevel + -2, gameLevel + 2)); //initial velocity
      initialVelocity = preventStationaryVelocity(initialVelocity);
      
      //index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = enemyDamage
      enemyObject.add(new int[] {ID, x, y, enemyGraphics[ID].width, (int)initialVelocity.x, (int)initialVelocity.y, 1, 5});
      break;
  
    case "small":
      ID = randomInt(3, 5);
      initialVelocity = new PVector(random(-gameLevel + -2, gameLevel + 2) * 2, random(-gameLevel + -2, gameLevel + 2) * 2); //initial velocity, small asteroid is twice as fast
      initialVelocity = preventStationaryVelocity(initialVelocity);
      
      //index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = enemyDamage
      enemyObject.add(new int[] {ID, x, y, enemyGraphics[ID].width * 2, (int)initialVelocity.x, (int)initialVelocity.y, 1, 1});
      break;
    default:
      println("WARNING: createAsteroid called with " + size + " instead of large or small");
  }
  
  if (debug)
      {
        //println("Spawned asteroid with initialVelocity: " + initialVelocity);
      }
}

PVector preventStationaryVelocity(PVector initialVelocity) {
  //prevent stationary objects. Give them some velocity if it has 0 velocity.
  if ((initialVelocity.x < 1 && initialVelocity.x > 0) || (initialVelocity.x < 0 && initialVelocity.x > -1)) 
    initialVelocity = new PVector(random(1, 3), random(1, 3));
  else if ((initialVelocity.y < 1 && initialVelocity.y > 0) || (initialVelocity.y < 0 && initialVelocity.y > -1))
    initialVelocity = new PVector(random(1, 3), random(1, 3));
  return initialVelocity;
}


void drawAndMoveEnemies() {
  // Iterate through all enemyObjects. Draw them and update their locations

  for (int i = 0; i < enemyObject.size(); i++) {
    int[] obj = enemyObject.get(i);
    PVector objCoords = new PVector(obj[1], obj[2]);
    PVector objVelocity = new PVector(obj[4], obj[5]);

    //draw
    image(enemyGraphics[obj[0]], objCoords.x, objCoords.y);

    //move
    obj[1] = obj[1] + (int)objVelocity.x;
    obj[2] = obj[2] + (int)objVelocity.y;

    //Screen overlap check
    if (obj[1] > width + screenPadding) {
      obj[1] = 0 - screenPadding;
    }
    if (obj[2] > height + screenPadding) {
      obj[2] = 0 - screenPadding;
    }
    if (obj[1] < 0 - screenPadding) {
      obj[1] = width + screenPadding;
    }
    if (obj[2] < 0 - screenPadding) {
      obj[2] = height + screenPadding;
    }
  }
}


/*

  ___            
 | _ ) ___ ______
 | _ \/ _ (_-<_-<
 |___/\___/__/__/
                 
*/

  // Boss object
  ArrayList<int[]> bossObject = new ArrayList<int[]>(); 

  // Boss PVectors
  PVector bossLocation;
  PVector bossBladeRotation = new PVector(10,10); 
  
  // Boss graphics
  PImage[] bossGraphic = new PImage[4]; // ship image array
  int bossGraphicIndex = 0;
  PImage[] bossBladeGraphic = new PImage[2]; // ship image array
  int bossBladeGraphicIndex = 0;
  
    // Animation data
  float bossBladeAngle;
  
  // Movement data
  PVector target;
  final float bossInitialSpeed = .3;
  float bossSpeed = bossInitialSpeed;
  
  // Positioning data
  int bossBladeOffsetY = 30;
  int bossIndicatorOffsetY = 5;
  
  // Collision data
  int bossSize = 80;
  final int bossInitialStrength = 1000;
  int bossStrength = bossInitialStrength;
  final float bossDamage = 0.03;
  
  // Indicator rotation
  float indicatorRotation;
  
  // State tracking
  boolean bossDefeated = false;
  boolean bossThisLevel = false;
  boolean deathAnimationFinished = false;
  boolean bossLaughed = false;
  

void bossSequence() {
  // Start the boss sequence
  
  thread("attentionLifeformSoundSequence");
  
  // Here we have 2 boss themes, alternating based upon even level number
  if (gameLevel % 4 == 0) 
    fadeInSongCoroutine("boss1");
  else
    fadeInSongCoroutine("boss2");
    
  delay(2000);
  
  while (!bossDefeated)
    delay(100);
  
}

void handleBoss(){
  // Handles boss related functionality

  //get vector pointing from ship to Boss
  PVector target = PVector.sub (shipLocation,bossLocation);
  
  // normalize to a unit vector in which each component is [0..1]
  target.normalize();

  // multiply target vector by speed to get vector from [0..speed]
  target.mult (bossSpeed);
  
  // Move the boss vector towards the ship
  bossLocation.add (target);
  
  // Spin and render his blade
  bossBladeAngle = bossBladeAngle + 4;
  translate(bossLocation.x, bossLocation.y + bossBladeOffsetY);
  rotate( radians(bossBladeAngle) );
  image(bossBladeGraphic[bossBladeGraphicIndex], 0, 0);
  rotate(- radians(bossBladeAngle));
  translate(- bossLocation.x, - bossLocation.y - bossBladeOffsetY);
  
  // Render his body
  image(bossGraphic[bossGraphicIndex], bossLocation.x, bossLocation.y);
  bossGraphicIndex = 0;
  
  // Render his health indicator
  indicatorRotation = norm(bossStrength, 0, bossInitialStrength);
  indicatorRotation *= 4.5;
  translate(bossLocation.x, bossLocation.y + bossIndicatorOffsetY);
  rotate( + indicatorRotation );
  image(bossGraphic[2], 0, 0);
  rotate( - indicatorRotation );
  translate( - bossLocation.x, - bossLocation.y - bossIndicatorOffsetY);
  
  // if boss is within health range, he gets mad and plunges towards player
  if (bossStrength < bossInitialStrength/2){
    // animate blinking light
    if (bossGraphicIndex == 0){
      bossGraphicIndex = 3;
      if (!bossLaughed) {
        soundArray[21].rewind();
        soundArray[21].play();
        bossLaughed = true;
      }
    }
    bossSpeed = 1.6;
  }
  if(bossStrength < 1){
   // stop boss following player and play explosion animations
   target = new PVector(bossLocation.x,height * 2); 
   bossSpeed = bossInitialSpeed;
   renderExplosion();
   if(explosionFrame == 15){
     explosionFrame = 0;
     lastCollisionLocation.x = bossLocation.x + random(-125,125);
     lastCollisionLocation.y = bossLocation.y + random(-35,35);
   }
  }
  
}
