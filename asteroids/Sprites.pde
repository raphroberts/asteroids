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

// Ship movement data
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

// SHIP FUNCTIONS

void moveShip() {
  // Move and render the player ship
  
  // Increase cooldown tick for weapon recharge delay
  weaponCooldownTick++;
  // Handle ship acceleration, deceleration & looping thruster sound
  accelerateShip();
  decelerateShip();
  shipLocation.add(shipVelocity);
  // Update rotation
  if (rotateLeft) {
    shipRotation -= shipRotationSpeed;
  }
  if (rotateRight) {
    shipRotation += shipRotationSpeed;
  }
  // Screen wrapping
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
  // Move the and rotate the draw matrix to match the ship
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
  // Reset the draw matrix
  rotate(-shipRotation);
  translate(-shipLocation.x, -shipLocation.y);
}

void accelerateShip(){
  // Handles ship acceleration
  
  if (accelerate) {
    shipAcceleration = new PVector(
      shipThrust * cos(shipRotation),
      shipThrust * sin(shipRotation)
    );
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
}

void decelerateShip() {
  // Handles ship deceleration
  
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


// WEAPON & BULLET GLOBALS

// Bullet data is stored in an array list as follows:
// 0 = bullet ID, 1 = x coord, 2 = y coord, 3 = hitbox size 4 = x velocity
// 5 = y velocity, 6 = initial rotation, 7 = bulletType, 8 = bullet damage
ArrayList<Float[]> bulletObject = new ArrayList<Float[]>(); 

boolean gunReloaded = true;
PVector bulletVelocity;
PVector bulletLocation;
float bulletRotation = 0; // radians

int bulletSpeed = 18;
int bulletID = 1;
float bulletSize = 1;

// Weapon damage inflicted
final float damageLaser = 8;
final float damageTripleShot = 15;
final float damageEnforcer = 200;

// Index of current weapon, shield & thruster
int weaponIndex = 1;
int shieldIndex = 1;
int thrusterIndex = 1;

// State tracking
boolean gameStarted = false;

// Weapon cooldown length (in frames) and counter
int weaponCooldown = -1;
int weaponCooldownTick = 0;

// Shield text to display
String shieldName = "Basic";
String thrusterName = "Standard";

// WEAPON & BULLET FUNCTIONS

void createBullet() {
  // Create and spawn a new bullet & play associated sound
  // (if gun is reloaded & recharged)
  
  if (gunReloaded && weaponCooldownTick > weaponCooldown) {
    weaponCooldownTick = 0;    
    // Set bullet location/rotation to match ship
    bulletLocation.x = shipLocation.x;
    bulletLocation.y = shipLocation.y;
    bulletRotation = shipRotation;    
    // Add bullet depending on current weapon that is firing it
    if (weaponIndex == 1) {
      // Standard laser gun
      spawnBullet(1,damageLaser);
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      //Allow mulitple sound channels for this bullet
      if (bulletshotIndex > 2) bulletshotIndex = 0;
    }
    else if (weaponIndex == 2) { 
      // Triple shot
      spawnBullet(2,damageTripleShot);
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      //Allow mulitple sound channels for this bullet
      if (bulletshotIndex > 2) bulletshotIndex = 0;
    }
    else if (weaponIndex == 3) { 
      // Magnum enforcer
      spawnBullet(3,damageEnforcer);
      soundArray[4].rewind();
      soundArray[4].play();
    }
  }
}

void spawnBullet(float type, float damage){
  // Spawns a bullet
  // type = type of bullet (changes bullet appearance)
  // damage = damage inflicted
  
  bulletObject.add(new Float[] {
    float(bulletID),
    bulletLocation.x,
    bulletLocation.y,
    bulletSize,
    (bulletSpeed * cos(bulletRotation)),
    (bulletSpeed * sin(bulletRotation)),
    bulletRotation,
    type,
    damage});
}


void drawAndMoveBullets() {
  // Iterate through all bullet objects, Render them and update their positions

  noStroke();
  for (int i = 0; i < bulletObject.size(); i++) {
    Float[] obj = bulletObject.get(i);
    PVector bulletCoords = new PVector(obj[1], obj[2]);
    PVector bulletVelocity = new PVector(obj[4], obj[5]);
    int bulletType = round(obj[7]);
    translate(bulletCoords.x, bulletCoords.y);
    rotate(obj[6]);
    // Render bullet (appearance based on bullet type)
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
    // Update location of bullet (enforcer moves slower)
    if (obj[7] != 4.0) {
      obj[1] = obj[1] + (int)(bulletSpeed * cos(obj[6])); 
      obj[2] = obj[2] + (int)(bulletSpeed * sin(obj[6])); 
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

/*
  Asteroids are stored as an array list, with each object as follows:
  0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity,
  5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = enemyDamage
  object ID = enemyGraphics PNG: 0-2 = large asteroids, 3-5 = small asteroids
*/

ArrayList<int[]> enemyObject = new ArrayList<int[]>(); 

// Asteroid graphic images (large and small)
PImage[] enemyGraphics = new PImage[6]; //index corresponds to enemyObject ID

void createAsteroid(int x, int y, String size) {
  // Create an asteroid at the given x, y coords, with size = "large" or "small"
  
  int ID;
  PVector initialVelocity = new PVector(0, 0);    
  switch (size) {
    case "large":
      // Add a large asteroid to array list
      // Use random ID (PNG image) and random velocity      
      ID = randomInt(0, 2);
      initialVelocity = new PVector(
        random(-gameLevel + -2, gameLevel + 2),
        random(-gameLevel + -2, gameLevel + 2)
      );
      initialVelocity = preventStationaryVelocity(initialVelocity);
      enemyObject.add(new int[] {
        ID,
        x,
        y, 
        enemyGraphics[ID].width, 
        (int)initialVelocity.x, 
        (int)initialVelocity.y, 
        1, 
        5}
      );
      break;  
    case "small":
      // Add a small asteroid to array list
      // Use random ID (PNG image) and random velocity
      ID = randomInt(3, 5);
      initialVelocity = new PVector(
        random(-gameLevel + -2, gameLevel + 2) * 2, 
        random(-gameLevel + -2, gameLevel + 2) * 2
      );
      initialVelocity = preventStationaryVelocity(initialVelocity);
      enemyObject.add(new int[] {
        ID, 
        x, 
        y, 
        enemyGraphics[ID].width * 2, 
        (int)initialVelocity.x, 
        (int)initialVelocity.y, 
        1, 
        1
      });
      break;
    default:
      // Catch errors if function not called properly
      println("createAsteroid called with " + size + " (needs large or small)");
  }
}

PVector preventStationaryVelocity(PVector initialVelocity) {
  // Gives objects velocity if they have 0 velocity.
  
  if (
    (initialVelocity.x < 1 && initialVelocity.x > 0) || 
    (initialVelocity.x < 0 && initialVelocity.x > -1)
    ) 
    initialVelocity = new PVector(random(1, 3), random(1, 3));
  else if (
    (initialVelocity.y < 1 && initialVelocity.y > 0) ||
    (initialVelocity.y < 0 && initialVelocity.y > -1)
    )
    initialVelocity = new PVector(random(1, 3), random(1, 3));
  return initialVelocity;
}


void drawAndMoveEnemies() {
  // Iterate through all enemyObjects. Draw them and update their locations

  for (int i = 0; i < enemyObject.size(); i++) {
    int[] obj = enemyObject.get(i);
    PVector objCoords = new PVector(obj[1], obj[2]);
    PVector objVelocity = new PVector(obj[4], obj[5]);
    // Draw the enemy
    image(enemyGraphics[obj[0]], objCoords.x, objCoords.y);
    // Update their positions
    obj[1] = obj[1] + (int)objVelocity.x;
    obj[2] = obj[2] + (int)objVelocity.y;
    // If enemy has left the screen, wrap it around the other side
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
  final int bossNewGameStrength = 250; // new game strength
  int bossInitialStrength = bossNewGameStrength; // new level strength
  int bossStrength = bossInitialStrength; // initial strength
  final float bossDamage = 0.01;
  
  // Indicator rotation
  float indicatorRotation;
  
  // State tracking
  boolean bossDefeated = false;
  boolean bossThisLevel = false;
  boolean deathAnimationFinished = false;
  boolean bossLaughed = false;

void bossSequence() {
  // Start the boss sequence
  
  // Play boss spawn sound
  thread("attentionLifeformSoundSequence");  
  // Play boss music, alternating each time we encounter the boss
  if (gameLevel % 2 == 0) fadeInSongCoroutine("boss1");
  else fadeInSongCoroutine("boss2");    
  delay(2000);  
  while (!bossDefeated) delay(100);  
}

void handleBoss(){
  // Handles boss related functionality

  // Get vector pointing from ship to Boss
  PVector target = PVector.sub (shipLocation,bossLocation);
  // Normalize to a unit vector in which each component is [0..1]
  target.normalize();
  // Multiply target vector by speed to get vector from [0..speed]
  target.mult (bossSpeed);
  // Move the boss vector towards the ship
  bossLocation.add (target); 
  // Render the boss graphics
  renderBoss();
  // When boss reaches half strenth, it gets mad and plunges towards player
  if (bossStrength < bossInitialStrength/2){
    // Animate blinking light
    if (bossGraphicIndex == 0){
      bossGraphicIndex = 3;
      if (!bossLaughed) {
        // The boss will laugh once when he's mad
        soundArray[21].rewind();
        soundArray[21].play();
        bossLaughed = true;
      }
    }
    // Movement speed of the boss is based on game level and whether it is mad
    bossSpeed = bossInitialSpeed * gameLevel * 1.6;
  }
  else {
    bossSpeed = bossInitialSpeed * gameLevel;
  }
  if(bossStrength < 1){
   // Boss is dead so stop it following player and play explosion animations
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

void renderBoss(){
  // Render the boss graphics (body, blade, health indicator)
  
  // Spin and render the blade
  bossBladeAngle = bossBladeAngle + 4;
  translate(bossLocation.x, bossLocation.y + bossBladeOffsetY);
  rotate( radians(bossBladeAngle) );
  image(bossBladeGraphic[bossBladeGraphicIndex], 0, 0);
  rotate(- radians(bossBladeAngle));
  translate(- bossLocation.x, - bossLocation.y - bossBladeOffsetY);
  // Render the body
  image(bossGraphic[bossGraphicIndex], bossLocation.x, bossLocation.y);
  bossGraphicIndex = 0;
  // Render the health indicator (dial on the nose)
  indicatorRotation = norm(bossStrength, 0, bossInitialStrength);
  indicatorRotation *= 4.5;
  translate(bossLocation.x, bossLocation.y + bossIndicatorOffsetY);
  rotate( + indicatorRotation );
  image(bossGraphic[2], 0, 0);
  rotate( - indicatorRotation );
  translate( - bossLocation.x, - bossLocation.y - bossIndicatorOffsetY);
}
