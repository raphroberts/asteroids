// FUNCTIONS AND GLOBALS THAT RELATE TO THE MAIN GAME SCREEN

// Basic non-specific globals
int score = 0;
int screenPadding = 40; // padding allowance for objects to float off screen

// Temp

boolean continueLevel = false; //delete this when upgrade screen is implemented
String centralScreenText = "";


/*
  ___  __  __        _      
 | __|/ _|/ _|___ __| |_ ___
 | _||  _|  _/ -_) _|  _(_-<
 |___|_| |_| \___\__|\__/__/
 
 */

// Explosion effect
int explosionFrame;
PImage[] smokeAnimFrameArray = new PImage[15];
final int numSmokeFrames = 14;
boolean asteroidDead = false;
PVector lastCollisionLocation = new PVector();

// Starfield
ArrayList<int[]> starObject = new ArrayList<int[]>(); 
int numberOfStars = 120;

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

void generateSmoke() {
  // Generates smokeAnimFrames array used for explosion effect

  for (int i = 0; i < numSmokeFrames; i++) {
    smokeAnimFrameArray[i] = loadImage("images/smoke_frames/smoke_" + i + ".png");
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
      if ((starLocation.y - shipLocation.y) < height / 2) {
        point(starLocation.x, (starLocation.y - shipLocation.y) * 2);
        point(starLocation.x, ((starLocation.y - shipLocation.y) * 2) - (height*2)+ (screenPadding*4));
        point(starLocation.x, ((starLocation.y - shipLocation.y) * 2) + (height*2)+ (screenPadding*4));
      }
    }
  }
}

/*

 ___              _           
 / _ \__ _____ _ _| |__ _ _  _ 
 | (_) \ V / -_) '_| / _` | || |
 \___/ \_/\___|_| |_\__,_|\_, |
 |__/ 
 
 */

// UI icons images
PImage[] iconsUI = new PImage[10];

// Positioning of UI elements
final int basicPadding = 20;
final int weaponUIdist = 65;
final int highlightSize = 50;
final int iconVerticalPadding = 20;
final int iconHorizontalPadding = 100;
final int shieldBarX = 100;
final int shieldTextX = 130;
final int shieldPaddingX = 70;
final int barSize = 10;
final int startingY = 40;
final int textPaddingY = 100;
final int shieldXPadding = 50;
final int weaponBarPaddingY = 75;

// Icon highlights colours
final color weaponFill = color(255, 155, 155, 80);
final color weaponBlankFill = color(255, 255, 255, 30);

void UIManager() {
  // Handle game overlay/UI

  // Render score
  textAlign(LEFT, TOP);
  text ("Score: " + score, basicPadding, basicPadding); // render score

  // Render current level
  textAlign(CENTER, TOP);
  text("Level: " + gameLevel, width/2, basicPadding);

  // Render shield
  drawShieldUI();

  // Render status graphics

  if (levelComplete) {
    // animate level complete graphics
    LevelUpBanner =  pulseImage(806, 780, 0.9, 3, false);
    image(levelStatusImage[1], width/2, height/2, LevelUpBanner, 114); 
    levelUpStar =  pulseImage(108, 100, 0.7, 4, false);
    image(levelStatusImage[0], width/2, height/3, levelUpStar, levelUpStar);
  }

  if (bossActivated) {
    // animate alertBanner
    alertBanner =  pulseImage(263, 243, 0.3, 2, false);
    image(levelStatusImage[2], width/2, height - height/5, alertBanner, alertBanner/2); 
    handleBoss();
  }

  noFill();
  strokeWeight(5);
  int rechargePerc = 0;

  // Calculate percentage of weapon recharge
  if (weaponCooldown <= 10)
    //weapon recharge is too fast, don't bother drawing
    rechargePerc = 50;
  else {
    // Get normal & percentage of recharge
    float rechargeNorm = 50.0 / weaponCooldown;
    rechargePerc = (int)min((weaponCooldownTick * rechargeNorm), 50);
  }

  // Draw recharge bar to UI
  noStroke();
  fill(255 - (2.55 * rechargePerc), 2.2 * rechargePerc, 0, 255); //color shield based upon HP
  rect(170, height - weaponBarPaddingY, rechargePerc, barSize);
  fill(255);

  drawWeaponIcons();

  //Shield icon and info text
  fill(weaponFill);
  image(iconsUI[4], width - shieldXPadding, height - iconVerticalPadding - basicPadding);

  fill(mainFontColour);
  textAlign(CENTER, TOP);
  textLeading(gameTextSizeMain);
  text("Shield:\n" + shieldName, width - shieldXPadding, height - textPaddingY);

  // Thruster icon and info text
  fill(weaponFill);
  image(iconsUI[6], width - weaponUIdist * 2, height - iconVerticalPadding - basicPadding);

  fill(mainFontColour);
  textAlign(CENTER, TOP);
  textLeading(gameTextSizeMain);
  text("Thrust:\n" + thrusterName, width - weaponUIdist * 2, height - textPaddingY);
}

void drawWeaponIcons() {
  // Draw weapon icons and highlighting
  int startingX = 40;

  for (int i = 1; i <= 3; i++) {
    if (i == weaponIndex) {
      fill(weaponFill);
      stroke(255);
      strokeWeight(1);
    } else {
      noFill();
      noStroke();
    }
    rect(startingX, height - startingY, highlightSize, highlightSize);
    image(iconsUI[i-1], startingX, height - startingY);
    fill(mainFontColour);
    text(i, startingX, height - startingY + 5 - weaponUIdist);
    startingX += weaponUIdist;
  }
}

void changeWeapon(int index) {
  // Handle weapon changes

  weaponIndex = index;
  if (index == 1 || index == 2)
    weaponCooldown = 5;
  else if (index == 3)
    weaponCooldown = 120;
  else if (index == 4)
    weaponCooldown = 90;
}

void changeShield(int index) {
  // Handle shield changes

  shieldIndex = index;
  if (index == 1) {
    maxShieldHP = 500;
    shieldHP = maxShieldHP;
    shieldRechargeDelay = 50; //recharge 1 point this number of frames
    shieldRechargeTick = 0;
    shieldName = "Basic";
  } else if (index == 2) {
    maxShieldHP = 1500;
    shieldHP = maxShieldHP;
    shieldRechargeDelay = 20; //recharge 1 point this number of frames
    shieldRechargeTick = 0;
    shieldName = "Barrier MK2";
  }
}

void changeThruster(int index) {
  // Handle thruster changes

  thrusterIndex = index;
  if (index == 1) {
    shipThrust = 0.1;
    shipRotationSpeed = 0.1;
    maxSpeed = 4;
    thrusterName = "Standard";
  } else if (index == 2) {
    shipThrust = 0.2;
    shipRotationSpeed = 0.15;
    maxSpeed = 6;
    thrusterName = "MK2 Emitter";
  }
}

void drawShieldUI() {
  // Render shield status to the UI/overlay

  float shieldNorm = 100.0 / maxShieldHP; // get Normal of shield
  int shieldPerc = (int)(shieldHP * shieldNorm); // get % of shield

  noStroke();
  fill(weaponBlankFill); //color shield based upon HP
  rect(width - shieldPaddingX, basicPadding * 1.5, shieldBarX, barSize);

  fill(200 - (2.55 * shieldPerc), 2.2 * shieldPerc, 0); //color shield based upon HP
  rect(width - shieldPaddingX, basicPadding * 1.5, shieldPerc, barSize);

  fill(mainFontColour);
  textAlign(RIGHT, TOP);
  text("Shield:", width - shieldTextX, basicPadding);
}

/*

 ___     _ _ _    _             
 / __|___| | (_)__(_)___ _ _  ___
 | (__/ _ \ | | (_-< / _ \ ' \(_-<
 \___\___/_|_|_/__/_\___/_||_/__/
 
 */

//Shields & Damage
int maxShieldHP = 500;
int shieldHP = maxShieldHP;
int shieldRechargeDelay = 50; //recharge 1 point this number of frames
int shieldRechargeTick = 0; //current recharge tick
int weaponDamage = 2;
boolean isBeingDamaged = false; //is ship currently undergoing damage?

void checkCollision() {
  // Check for collisions between asteroid / ship and bullet / asteroid

  boolean collisionDetected = false; //is there a collision this frame?

  if (bossActivated) {
    // iterate over every bullet and check if it collided with the boss
    for (int j = 0; j < bulletObject.size(); j++) {
      PVector bulletHitbox = new PVector(bulletObject.get(j)[1], bulletObject.get(j)[2]);
      if (dist(bulletHitbox.x, bulletHitbox.y, bossLocation.x, bossLocation.y) < bossSize) {
        // make boss "flash" to indicate it was hit
        bossGraphicIndex = 1;

        // Boss loses strength equivalent to current bullet's power
        bossStrength -= (bulletObject.get(j)[2]);
        // remove the offending bullet
        bulletObject.remove(j);
        if (bossStrength < 1) {
          bossDefeated = true;
        }
      }
    }
  } else {      
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
      // check if bullet has shot an asteroid
      for (int j = 0; j < bulletObject.size(); j++) {
        hitboxSize = obj[3];
        Float[] bulletObj = bulletObject.get(j); 
        PVector bulletHitbox = new PVector(bulletObject.get(j)[1], bulletObject.get(j)[2]); // location of this bullet 
        if (bulletObj[7] == 4.0)
          hitboxSize = hitboxSize + 100; //increase hitbox size for laser beam
        println("Hit box size is " + hitboxSize);
        if (dist(bulletHitbox.x, bulletHitbox.y, hitbox.x, hitbox.y) < hitboxSize) {
          boolean destroyed = damageEnemyObject(enemyObject.get(i)); //returns true if object destroyed, false if only damaged
          // remove bullet unless its a laser beam, or remove object if its outside bounds (including laser beam)
          if (bulletObj[7] != 4.0 || bulletObj[1] < 0 || bulletObj[1] > width || bulletObj[2] < 0 || bulletObj[2] > height) 
            bulletObject.remove(j);
          if (destroyed) { 
            // Remove asteroid
            enemyObject.remove(i);
            break; //this enemyObject is destroyed, go back to outer loop
          }
          //TODO: Tint on enemy object if HP above 0 but still hit
        }
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

void rechargeShield() {
  // Recharge shield slowly over time

  if (shieldRechargeTick++ > shieldRechargeDelay && shieldHP < maxShieldHP) {
    shieldRechargeTick = 0;
    shieldHP = shieldHP + 1;
  }
}

/*
  _                _   __  __                                       _   
 | |   _____ _____| | |  \/  |__ _ _ _  __ _ __ _ ___ _ __  ___ _ _| |_ 
 | |__/ -_) V / -_) | | |\/| / _` | ' \/ _` / _` / -_) '  \/ -_) ' \  _|
 |____\___|\_/\___|_| |_|  |_\__,_|_||_\__,_\__, \___|_|_|_\___|_||_\__|
 
 */

int gameLevel = 1; //auto-increment upon level up

// Level status tracking
boolean levelComplete = false;
boolean bossActivated = false;

int levelSequence() { 
  // the main level manager, instantiator, and controller

  //music sequence, modulo of the gameLevel, except level 1 which has its own theme
  //these are all the combinations possible from modulo 4, for 4 songs (+1 for the level1 only theme)
  if (gameLevel == 1) 
    fadeInSongCoroutine("level1");
  else if (gameLevel % 4 == 0)
    fadeInSongCoroutine("trueepic");
  else if (gameLevel % 4 == 1)
    fadeInSongCoroutine("modulo4");
  else if (gameLevel % 4 == 2)
    fadeInSongCoroutine("thrust");
  else if (gameLevel % 4 == 3) 
    fadeInSongCoroutine("epic");


  int asteroidsToSpawnPerCycle = (int)pow(gameLevel, 2);
  int numberOfCycles = gameLevel + 1;

  if (gameLevel == 1)
    numberOfCycles = numberOfCycles * 2 + 1;
  else if (gameLevel == 2)
    numberOfCycles = numberOfCycles * 2;

  int spawnDelay = (int)(1 / (gameLevel * 0.5) * 3000);
  if (debug)
    println("Starting level " + gameLevel + " with " + asteroidsToSpawnPerCycle + " asteroids spawning per cycle over " + " number of cycles: " + numberOfCycles + ". Spawn delay: " + spawnDelay); // delete this 
  for (int cycle = 1; cycle <= numberOfCycles; cycle++) {
    if (debug)
      //println("Spawning cycle: " + cycle + " of " + numberOfCycles);
      for (int asteroidCounter = 1; asteroidCounter <= asteroidsToSpawnPerCycle; asteroidCounter++) {
        if (!gameStarted)
          return 1;
        float rand = random(1);
        if (rand < 0.8)
          createAsteroid(0, 0, "large");
        else
          createAsteroid(0, 0, "small");
        float randDelay = random(spawnDelay);
        //println("Spawn Delay is under: " + min((int)randDelay * numberOfCycles/cycle, (int(10000 / (gameLevel * cycle * 0.5)))));
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
        } else {
          delay(2000);
        }
        break;
      }
      delay(1000);
    }
  }

  while (enemyObject.size() != 0)
    delay(100); //wait for all asteroids to be destroyed

  fadeInSongCoroutine("none");

  if (gameLevel %2 == 0) { //boss sequence only on even levels
    bossThisLevel = true;
    bossActivated = true;
    bossSequence();
  } else if (enemyObject.size() == 0 && bossDefeated) {
    //End level sequence
    fadeInSongCoroutine("upgrade");
    soundArray[9].rewind();
    soundArray[9].play();
    levelComplete = true;
    delay(2000);
    currentScreen = "level up";
    // Reset values for next level
    levelComplete = false;
    bossDefeated = false;
  }
  else if (enemyObject.size() == 0 && !bossThisLevel) {
    //End level sequence
    fadeInSongCoroutine("upgrade");
    soundArray[9].rewind();
    soundArray[9].play();
    levelComplete = true;
    delay(2000);
    currentScreen = "level up";
    // Reset values for next level
    levelComplete = false;
    bossDefeated = false;
    bossThisLevel = true;
  }
  return 1;
}
