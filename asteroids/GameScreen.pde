// Game screen globals

int score = 0;

// Dead asteroid explosion vars
int explosionFrame;
PImage[] smokeAnimFrameArray = new PImage[15];
final int numSmokeFrames = 14;
boolean asteroidDead = false;
PVector lastCollisionLocation = new PVector();

// stars
ArrayList<int[]> starObject = new ArrayList<int[]>(); 
int numberOfStars = 50;

void generateStars() {
  // create random starfield data

  for (int i = 1; i <= numberOfStars; i++) {
    //index 0 = x coord, 1 = y coord, 2 = size
    starObject.add(new int[] {randomInt(0, width), randomInt(0, height), randomInt(2, 4)});
    //starObject.add(new int[] {100, 400, 4});
  }
}

void renderStars() {
  // Render starfield to screen

  for (int i = 0; i < starObject.size(); i++) {
    //Retrieve the X,Y coordinates of the current star
    int[] obj = starObject.get(i);
    PVector starLocation = new PVector(obj[0], obj[1]); 
    stroke(randomInt(100, 190));
    strokeWeight(obj[2]);
    if (obj[2] < 3) {
      point(starLocation.x, starLocation.y - shipLocation.y);
      point(starLocation.x, starLocation.y - shipLocation.y - (height + (screenPadding*2)));
      point(starLocation.x, starLocation.y - shipLocation.y + (height + (screenPadding*2)));
    } else {
      if ((starLocation.y - shipLocation.y) < height / 2){
      point(starLocation.x,(starLocation.y - shipLocation.y) * 2);
      point(starLocation.x,((starLocation.y - shipLocation.y) * 2) - (height*2)+ (screenPadding*4));
      point(starLocation.x,((starLocation.y - shipLocation.y) * 2) + (height*2)+ (screenPadding*4));
    }
    }
  }
}

/*
void initialiseEnemyObjects() {
 enemyObject.add(new int[] {0, 100, 100, 50});
 }*/

void checkCollision() {
  // Check for collisions between asteroid / ship and bullet / asteroid
  boolean collisionDetected = false; //is there a collision this frame?

  // check if ship has hit an asteroid
  for (int i = 0; i < enemyObject.size(); i++) {
    //Retrieve the values from the enemyObject
    //index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1), 7 = enemy damage
    int[] obj = enemyObject.get(i);
    PVector hitbox = new PVector(obj[1], obj[2]); //hitbox for this enemyObject
    int hitboxSize = obj[3];
    int enemyDamage = obj[7];
    if (dist(shipLocation.x, shipLocation.y, hitbox.x, hitbox.y) < hitboxSize) {
      damageShip(enemyDamage);
      collisionDetected = true;
    }

    // check if asteroid and a bullet collide
    for (int j = 0; j < bulletObject.size(); j++) {
      PVector bulletHitbox = new PVector(bulletObject.get(j)[1], bulletObject.get(j)[2]); // location of this bullet 
      if (dist(bulletHitbox.x, bulletHitbox.y, hitbox.x, hitbox.y) < hitboxSize) {
        bulletObject.remove(j);
        boolean destroyed = damageEnemyObject(enemyObject.get(i)); //returns true if object destroyed, false if only damaged
        if (destroyed) { 
          // Remove asteroid
          enemyObject.remove(i);
        }
        //TODO: Tint on enemy object if HP above 0 but still hit
      }
    }
  }

  //shield sequence
  if (collisionDetected) {
    if (!isBeingDamaged) {
      if (!endingShieldSound)
        soundArray[shieldSoundIndex].play(); //begin sound of shield damage
      isBeingDamaged = true; //ship is currently being damaged
    }
  } else {
    if (isBeingDamaged)
      endingShieldSound = true;  //stop sound of shield if damage is active
    isBeingDamaged = false; //ship is not currently being damaged
  }

  //a delay in ending shield sound and image to prevent instant "clicking" of shield sound, and to allow shield to power down
  if (endingShieldSound) {
    if (shieldSoundTick++ > shieldSoundEndDelay) {
      soundArray[shieldSoundIndex].pause();
      shieldSoundTick = 0;
      endingShieldSound = false;
      // Ship reset
      shipImageIndex = 0;
      accelerate = false;
    }
  }
}


void renderExplosion() {
  // Render smoke animation at asteroid location

  if (explosionFrame < 14) {
    image(smokeAnimFrameArray[explosionFrame], lastCollisionLocation.x, lastCollisionLocation.y);
    if (frameCount % 2 > 0) {
      explosionFrame += 1;
    }
  } else {
    explosionFrame = 15;
  }
}

void damageShip(int amount) {
  //Whenever the ship receives some damage "amount", it is handled via this function
  shieldHP = shieldHP - amount;
  if (shieldHP < 0) {
    println("ship collision");
    currentScreen = "game over";
  }
  shipImageIndex = 2;
}

boolean damageEnemyObject(int[] obj) {
  //index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1)
  obj[6] = obj[6] - weaponDamage;

  if (obj[6] <= 0) { // enemy object is 0 HP or lower, destroy
    switch (obj[0]) { // retrieve object ID
    case 0: 
    case 1: 
    case 2: //large asteroid is destroyed
      destroyLargeAsteroidSequence(obj[1], obj[2]); //pass in coords
      return true;
    case 3: 
    case 4: 
    case 5: //small asteroid is destroyed
      destroySmallAsteroidSequence(obj[1], obj[2]);
      return true;
    }
  }

  return false;
}

void destroyLargeAsteroidSequence(int xcoord, int ycoord) {
  score = score + 50;

  //randomly create between 2 or 3 small asteroids
  int smallAsteroids = randomInt(2, 3);
  for (int i = 1; i <= smallAsteroids; i++) {
    createAsteroid(xcoord, ycoord, "small");
  }
  //trigger explosion
  lastCollisionLocation.x = xcoord;
  lastCollisionLocation.y = ycoord;
  explosionFrame = 0;
  asteroidDead = true;
}

void destroySmallAsteroidSequence(int xcoord, int ycoord) {
  //trigger explosion
  lastCollisionLocation.x = xcoord;
  lastCollisionLocation.y = ycoord;
  explosionFrame = 0;
  asteroidDead = true;
  score = score + 100;
}


void renderOverlay() {
  // Print current score and level to the screen
}


// KEYBOARD INPUT

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
    createBullet();
    gunReloaded = false;
  }
  if (key == 'p') {
    // note: replace this with mouse interaction with button
    currentScreen = "game";
    generateStars();
  }

  if (key == 'c' && debug) {
    createAsteroid(0, 0, "large");
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
  if (key == ' ') {
    gunReloaded = true;
  }
}
