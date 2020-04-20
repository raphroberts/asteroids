// Game screen globals

//Scoring
int score = 0;

//Levels
int gameLevel = 1; //auto-increment upon level up
int screenPadding = 40; // padding allowance for objects to float off screen

// Explosion effect
int explosionFrame;
PImage[] smokeAnimFrameArray = new PImage[15];
final int numSmokeFrames = 14;
boolean asteroidDead = false;
PVector lastCollisionLocation = new PVector();

// Starfield
ArrayList<int[]> starObject = new ArrayList<int[]>(); 
int numberOfStars = 120;

//Shields & Damage
int maxShieldHP = 500;
int shieldHP = maxShieldHP;
int shieldRechargeDelay = 50; //recharge 1 point this number of frames
int shieldRechargeTick = 0; //current recharge tick
int weaponDamage = 2;
boolean isBeingDamaged = false; //is ship currently undergoing damage?

/*
  ___  __  __        _      
 | __|/ _|/ _|___ __| |_ ___
 | _||  _|  _/ -_) _|  _(_-<
 |___|_| |_| \___\__|\__/__/
             
*/

void renderExplosion() {
  // Calculates current frame of asteroid exploding animation

  if (explosionFrame < 14) {
    image(smokeAnimFrameArray[explosionFrame], lastCollisionLocation.x, lastCollisionLocation.y);
    if (frameCount % 2 > 0) {
      explosionFrame += 1;
    }
  } else {
    explosionFrame = 15;
  }
}

void generateStars() {
  // create random starfield data

  for (int i = 1; i <= numberOfStars; i++) {
    //index 0 = x coord, 1 = y coord, 2 = size
    starObject.add(new int[] {randomInt(0, width + screenPadding * 2), randomInt(0, height + screenPadding * 2), randomInt(3, 4)});
    //starObject.add(new int[] {100, 400, 4});
  }
}

void renderStars() {
  // Render starfield to screen

  for (int i = 0; i < starObject.size(); i++) {
    //Retrieve the X,Y coordinates of the current star
    int[] obj = starObject.get(i);
    PVector starLocation = new PVector(obj[0], obj[1]); 

    strokeWeight(obj[2]);
    if (obj[2] < 4) {
      stroke(randomInt(70, 120));
      point(starLocation.x, starLocation.y - shipLocation.y);
      point(starLocation.x, starLocation.y - shipLocation.y - (height + (screenPadding*2)));
      point(starLocation.x, starLocation.y - shipLocation.y + (height + (screenPadding*2)));
    } else {
      stroke(randomInt(100, 190));
      if ((starLocation.y - shipLocation.y) < height / 2){
      point(starLocation.x,(starLocation.y - shipLocation.y) * 2);
      point(starLocation.x,((starLocation.y - shipLocation.y) * 2) - (height*2)+ (screenPadding*4));
      point(starLocation.x,((starLocation.y - shipLocation.y) * 2) + (height*2)+ (screenPadding*4));
      }
    }
  }
}

/*

   ___     _ _ _    _             
  / __|___| | (_)__(_)___ _ _  ___
 | (__/ _ \ | | (_-< / _ \ ' \(_-<
  \___\___/_|_|_/__/_\___/_||_/__/
                               
*/

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
          break; //this enemyObject is destroyed, go back to outer loop
        }
        //TODO: Tint on enemy object if HP above 0 but still hit
      }
    }
  }

  //shield sequence
  if (collisionDetected) {
    if (!isBeingDamaged) {
      if (!endingShieldSound)
        soundArray[shieldSoundIndex].loop(); //begin sound of shield damage
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
      if (accelerate)
        shipImageIndex = 1;
      else 
        shipImageIndex = 0;
      //accelerate = false;
    }
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
    
  //trigger warning when shields are low, but only once per threshold
  if (!shieldWarningTriggered && shieldHP*1.0/maxShieldHP <= 0.3) {
    shieldWarningTriggered = true;
    thread("shieldCriticalSoundSequence");
  }
  if (shieldHP*1.0/maxShieldHP >= 0.5)
    shieldWarningTriggered = false;
}

boolean damageEnemyObject(int[] obj) {
  // Handles damage to enemies
  // index 0 = object ID, 1 = x coord, 2 = y coord, 3 = hitbox size, 4 = x velocity, 5 = y velocity, 6 = HP (>=0 if relevant, else -1)
  
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
  // Destroy large asteroid and break into smaller asteroids
  
  score = score + 50;

  //randomly create between 2 or 3 small asteroids
  int smallAsteroids = randomInt(2, 5);
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
  // Destroy smaller asteroid
  
  //trigger explosion
  lastCollisionLocation.x = xcoord;
  lastCollisionLocation.y = ycoord;
  explosionFrame = 0;
  asteroidDead = true;
  score = score + 100;
}

int levelSequence() { // the main level manager, instantiator, and controller
  int asteroidsToSpawnPerCycle = (int)pow(gameLevel, 2);
  int numberOfCycles = gameLevel + 1;
  if (gameLevel < 3) {
    numberOfCycles = numberOfCycles * 2;
  }
  int spawnDelay = (int)(1 / (gameLevel * 0.5) * 3000);
  if (debug)
    println("Starting level " + gameLevel + " with " + asteroidsToSpawnPerCycle + " asteroids spawning per cycle over " + " number of cycles: " + numberOfCycles + ". Spawn delay: " + spawnDelay); // delete this 
  for (int cycle = 1; cycle <= numberOfCycles; cycle++) {
    if (debug)
      println("Spawning cycle: " + cycle + " of " + numberOfCycles);
    for (int asteroidCounter = 1; asteroidCounter <= asteroidsToSpawnPerCycle; asteroidCounter++) {
      if (!gameStarted)
        return 1;
      float rand = random(1);
      if (rand < 0.8)
          createAsteroid(0, 0, "large");
      else
          createAsteroid(0, 0, "small");
      float randDelay = random(spawnDelay);
      println("Spawn Delay is under: " + min((int)randDelay * numberOfCycles/cycle, (int(10000 / (gameLevel * cycle * 0.5)))));
      if (enemyObject.size() < 2) { //early spawn if asteroids left are small in numer
        delay(1000);
        continue;
      }
      delay(min((int)randDelay * numberOfCycles/cycle, (int(10000 / (gameLevel * cycle * 0.5))))); //lower spawning cycles spawn with a greater delay 
    }
    for (int delay = 0; delay < 10; delay++) {
      if (enemyObject.size() < 5) { //early spawn if asteroids left are small in numer
        if (gameLevel <3) {
          delay(5000);
        }
        else {
          delay(2000);
        }
        break;
      }
      delay(1000);
    }
   
  }
  
  delay(2000);
  thread("attentionLifeformSoundSequence");
  delay(2000);
  bossSequence();
  
  return 1;
}

/*

   ___         _           _    
  / __|___ _ _| |_ _ _ ___| |___
 | (__/ _ \ ' \  _| '_/ _ \ (_-<
  \___\___/_||_\__|_| \___/_/__/
                             
*/


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
  
  //Change weapon
  if (key == '1') {
    changeWeapon(1);
  }
  if (key == '2') {
    changeWeapon(2);
  }
  if (key == '3') {
    changeWeapon(3);
  }
  
  if (key == 'p') {
    if (!gameStarted) {
      gameStarted = true;
      // note: replace this with mouse interaction with button
      while (!preloadingFinished) //wait for preloading to finish before starting game
        delay(100);
      currentScreen = "game";
      musicManager("none");
      generateStars();
      thread("levelSequence");
    }
  }

  // debug keys
  if (key == 'c' && debug) {
    createAsteroid(0, 0, "large");
  }
  if (key == 'n' && debug) { //temp for testing songs, delete in production
    if (playingIndex == 0)
      musicManager("thrust");
    else if (playingIndex == 1)
      musicManager("thrust");
    else if (playingIndex == 2)
      musicManager("epic");
  }
  if (key == 'b' && debug) { //temp, cycle and equip through diff shields, weapons. Normally this should only be possible at level up screen
    if (shieldIndex == 1)
      changeShield(2);
    else if (shieldIndex == 2 && thrusterIndex == 1)
      changeThruster(2);
    else
      {
        changeShield(1);
        changeThruster(1);
      }
  }
  if (key == 'y' && debug) { //temp, delete after upgrade screen implemented
    continueLevel = true;
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
