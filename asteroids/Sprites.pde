// FUNCTIONS RELATING TO SPRITES: Ship, Asteroids, Bullets

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

// Ship movement
float maxSpeed = 4;
boolean accelerate = false;
boolean rotateLeft = false;
boolean rotateRight = false;
float shipRotationSpeed = 0.1;
float shipRotation = -1.5; // radians
float shipThrust = 0.1;
PVector shipAcceleration;
PVector shipVelocity;
PVector shipLocation;

void initialiseShip() {
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(230, 230);
}

void moveShip() {
  weaponCooldownTick++; //increase cooldown tick
  
  // Handle ship movement
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
  image(shipGraphic[shipImageIndex], 0, 0);
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
  ___ _   _ _    _    ___ _____ ___ 
 | _ ) | | | |  | |  | __|_   _/ __|
 | _ \ |_| | |__| |__| _|  | | \__ \
 |___/\___/|____|____|___| |_| |___/
 
 */


// BULLET GLOBALS

boolean gunReloaded = true;
PVector bulletVelocity;
PVector bulletLocation;
float bulletRotation = 0; // radians

int bulletSpeed = 18;
int bulletID = 1; // can be used later for different bullet types
float bulletSize = 1;

// Array list for storing bullet data
//index 0 = bullet ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity
/*
object ID can be used for bullet type, e.g:
 0 = green lazer
 1 = triple fire
 2 = rapid fire
 3 = high speed (etc.)
 */
ArrayList<Float[]> bulletObject = new ArrayList<Float[]>(); 

void createBullet() {
  // Create a new bullet when the ship fires the gun
  // shoot bullet as long as gun is reloaded
  if (gunReloaded && weaponCooldownTick > weaponCooldown) {
    weaponCooldownTick = 0;
    //create an asteroid at the given x, y coords, with size = "large" or "small"
    bulletLocation.x = shipLocation.x;
    bulletLocation.y = shipLocation.y;

    //PVector initialVelocity = new PVector(randomInt(-4, 4), randomInt(-4, 4));
    bulletRotation = shipRotation;
    //index 0 = bullet ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = initial rotation, 7 = bulletType, 8 = bullet damage
    if (weaponIndex == 1) { //standard laser gun
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation, 1.0, 2.0});
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      if (bulletshotIndex > 2) //allow mulitple sound channels for this bullet
        bulletshotIndex = 0;
    }
    else if (weaponIndex == 2) { //triple shot
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation, 2.0, 6.0});
      //bulletObject.add(new Float[] {float(bulletID), bulletLocation.x-20, bulletLocation.y-20, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation});
      //bulletObject.add(new Float[] {float(bulletID), bulletLocation.x+20, bulletLocation.y+20, bulletSize, (bulletSpeed * cos(bulletRotation)), (bulletSpeed * sin(bulletRotation)), bulletRotation});
      soundArray[bulletshotIndex].rewind();
      soundArray[bulletshotIndex++].play();
      if (bulletshotIndex > 2) //allow mulitple sound channels for this bullet
        bulletshotIndex = 0;
    }
    else if (weaponIndex == 3) { //laser cannon
      bulletObject.add(new Float[] {float(bulletID), bulletLocation.x, bulletLocation.y, bulletSize, (bulletSpeed * 0.1 * cos(bulletRotation)), (bulletSpeed * 0.1 * sin(bulletRotation)), bulletRotation, 3.0, 40.0});
      soundArray[4].rewind();
      soundArray[4].play();
    }
  }
}

void drawAndMoveBullets() {
  //iterate through all enemyObjects and draw them, also move them

  for (int i = 0; i < bulletObject.size(); i++) {
    Float[] obj = bulletObject.get(i);
    PVector bulletCoords = new PVector(obj[1], obj[2]);
    PVector bulletVelocity = new PVector(obj[4], obj[5]);
    int bulletType = round(obj[7]);

    //draw
    //image(enemyGraphics[i], objCoords.x, objCoords.y);
    
    translate(bulletCoords.x, bulletCoords.y);
    rotate(shipRotation);
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
    
    
    rotate(-shipRotation);
    translate(-bulletCoords.x, -bulletCoords.y);
    fill(255);

    //move
    obj[1] = obj[1] + (int)(bulletSpeed * cos(obj[6])); //move in x direction given the object velocity
    obj[2] = obj[2] + (int)(bulletSpeed * sin(obj[6])); //move in y direction given the object velocity
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
  if ((initialVelocity.x < 1 && initialVelocity.x > 0) || (initialVelocity.x < 0 && initialVelocity.x > -1)) {     
    initialVelocity = new PVector(random(1, 3), random(1, 3));
    }
    
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
