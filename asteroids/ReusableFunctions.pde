void screenHandler() {
  // Function to manage screen changes

  switch(currentScreen) {

  case "title": 
    // display title screen
    titleScreen();
    break;

  case "game": 
    // display game screen
    background(backgroundImage[1]);

    // Render the starfield
    // (located in GameScreen.PDE)
    renderStars();

    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveBullets();
    
        // Move the ship
    moveShip();
    
    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveEnemies();
    
    // Check for collisions
    // (located in GameScreen.PDE)
    checkCollision();
    rechargeShield();
    
    // render explosion if asteroid was hit
    renderExplosion();
    
    UIManager();
    break;

  case "level up": 
    // display level up screen
    
    background(backgroundImage[2]);
    //DELETE THIS, TEMP ONLY
    text("Press Y to continue", width/2, height/2); //temp, delete and replace with level up screen
    if (continueLevel) {
      continueLevel = false;
      gameLevel = gameLevel + 1;
      thread("levelSequence");
      currentScreen = "game";
    //END DELETE THIS, TEMP ONLY
    }
    break;

  case "game over": 
    // display game overscreen
    gameOverScreen();
    break;
  }
}

void rechargeShield() {
  // Recharge shield slowly over time
  
  if (shieldRechargeTick++ > shieldRechargeDelay && shieldHP < maxShieldHP) {
    shieldRechargeTick = 0;
    shieldHP = shieldHP + 1;
  }
}

void populateEnemiesArray() {
  // This function fetches the current number of enemies (increases per level)
  // then builds the enemyArray with random enemy PVectors.
  // Note: ensure location is not too close to player’s spawn point
}

String renderButton(String buttonText, float x, float y) {
  // Renders an interactive button with provided buttonText at X,Y coords
  // Used on title screen, upgrade screens, game over screen

  return null; //delete this, temp to prevent error
}


int randomInt(int low, int high) {
  // Returns a random integer
  
  return (int)round(random(low, high));
}

void UIManager() {
  text ("Score: " + score, 20,40); // render score
  //text ("Shield: " + shieldHP, width-200, 40);
  drawShieldUI();
  //text ("Now Playing: " + nowPlaying + ". Press 'N' for next song", 40, height-40);
  text("Level: " + gameLevel, width/2, 40);
  
  textSize(20);
  text("Weapon Slot: ", 40, height - 40);
  noFill();
  strokeWeight(5);
  
  int rechargePerc = 0;
  
  //draw weapon recharge time
  if (weaponCooldown <= 10) //weapon recharge is too fast, don't bother drawing
    rechargePerc = 100;
  else {
    float rechargeNorm = 100.0 / weaponCooldown; // get Normal of recharge
    rechargePerc = (int)min((weaponCooldownTick * rechargeNorm), 100); // get % of recharge
  }
  
  
  noStroke();
  fill(255 - (2.55 * rechargePerc) , 2.2 * rechargePerc, 0, 150); //color shield based upon HP
  rect(100, height-10, rechargePerc, 30);
  fill(255);
  
  //Weapon equipment
  if (weaponIndex == 1)
    fill(weaponFill);
  else 
    fill(weaponBlankFill);
  rect(190, height - 50, 40, 40);
  image(iconsUI[0], 190, height - 50);
  fill(255);
  text("1", 185, height - 10);
  
  if (weaponIndex == 2)
    fill(weaponFill);
  else
    fill(weaponBlankFill);
  rect(190 + weaponUIdist, height - 50, 40, 40);
  image(iconsUI[0], 190 + weaponUIdist, height - 50);
  fill(255);
  text("2", 185 + weaponUIdist, height - 10);
  
  if (weaponIndex == 3)
    fill(weaponFill);
  else
    fill(weaponBlankFill);
  rect(190 + weaponUIdist*2, height - 50, 40, 40);
  image(iconsUI[0], 190 + weaponUIdist*2, height - 50);
  fill(255);
  text("3", 185 + weaponUIdist*2, height - 10);
  
  //Shield equipment
  text("Shield: ", 130 + weaponUIdist*5, height - 40);
  
  fill(weaponFill);
  rect(180 + weaponUIdist*6, height - 50, 40, 40);
  image(iconsUI[0], 180 + weaponUIdist*6, height - 50);
  fill(255);
  text(shieldName, 155 + weaponUIdist*6, height - 10);
  
  //Thruster equipment
  text("Thruster: ", 130 + weaponUIdist*9, height - 40);
  
  fill(weaponFill);
  rect(200 + weaponUIdist*10, height - 50, 40, 40);
  image(iconsUI[0], 200 + weaponUIdist*10, height - 50);
  fill(255);
  text(thrusterName, 175 + weaponUIdist*10, height - 10);
  
  textSize(26);
}

void changeWeapon(int index) {
  weaponIndex = index;
  if (index == 1 || index == 2)
    weaponCooldown = 5;
  else if (index == 3)
    weaponCooldown = 120;
}

void changeShield(int index) {
  shieldIndex = index;
  if (index == 1) {
    maxShieldHP = 500;
    shieldHP = maxShieldHP;
    shieldRechargeDelay = 50; //recharge 1 point this number of frames
    shieldRechargeTick = 0;
    shieldName = "Basic"; 
  }
  else if (index == 2) {
    maxShieldHP = 1500;
    shieldHP = maxShieldHP;
    shieldRechargeDelay = 20; //recharge 1 point this number of frames
    shieldRechargeTick = 0;
    shieldName = "Barrier MK2"; 
  }
}

void changeThruster(int index) {
  thrusterIndex = index;
  if (index == 1) {
    shipThrust = 0.1;
    shipRotationSpeed = 0.1;
    maxSpeed = 4;
    thrusterName = "Standard";
  }
  else if (index == 2) {
    shipThrust = 0.2;
    shipRotationSpeed = 0.15;
    maxSpeed = 6;
    thrusterName = "MK2 Emitter";
  }
}

void drawShieldUI() {
  float shieldNorm = 100.0 / maxShieldHP; // get Normal of shield
  int shieldPerc = (int)(shieldHP * shieldNorm); // get % of shield
  
  noStroke();
  fill(255 - (2.55 * shieldPerc) , 2.2 * shieldPerc, 0); //color shield based upon HP
  rect(width - 100, 30, shieldPerc, 30);
  fill(255);
  
  text("Shield: ", width - 250, 40);
  text(shieldHP, width - 120, 40);
}

void musicManager(String song) {
  // Handles and plays game music
  
  stopAllSongs(); //prevent song overlap, ensure any currently playing song is first stopped
  
  switch (song) {
    case "none":
      // Stop any song that is currently playing
      break;
    case "title":
      // Play title theme
      try {
        musicArray[0].loop();
        playingIndex = 0;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "epic":
      try {
        musicArray[1].setGain(-5);
        musicArray[1].loop();
        playingIndex = 1;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "thrust":
      try {
       musicArray[2].setGain(-5);
       musicArray[2].loop();
       playingIndex = 2;
     }
     catch (NullPointerException e) {
       println("Song not yet loaded..");
     }
     break;
  }
}

void stopAllSongs() {
  // Stops music tracks from playing
  
  for (int i = 0; i < musicArray.length; i++) {
    try {
      if (musicArray[i].isPlaying()) {
        musicArray[i].pause();  
      }
    }
    catch (NullPointerException e) {
      //We can catch a NullPointerException here since it will only occur for an unloaded async sound file
    }
  }
}

void shieldCriticalSoundSequence() {
  //Only call this function asynchronously
  soundArray[6].setGain(-5);
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[7].rewind();
  soundArray[7].play();
}

void attentionLifeformSoundSequence() {
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[8].rewind();
  soundArray[8].play();
}

void bossSequence() {
  text("Boss sequence, level: " + gameLevel, width/2, height/2);
  delay(2000);
  currentScreen = "level up";
  
}

void upgradeScreen() {
  
}
