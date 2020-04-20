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
  
  textSize(26);
}

void changeWeapon(int index) {
  weaponIndex = index;
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
        musicArray[0].amp(0.3);
        musicArray[0].rate(0.7);
        musicArray[0].play();
        musicArray[0].loop();
        playingIndex = 0;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "epic":
      try {
        musicArray[1].amp(0.4);
        musicArray[1].play();
        playingIndex = 1;
        nowPlaying = "epic - s2.mp3";
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "thrust":
      try {
       musicArray[2].amp(0.4);
       musicArray[2].play();
       playingIndex = 2;
       nowPlaying = "ThrustSequence.mp3";
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
        musicArray[i].stop();  
      }
    }
    catch (NullPointerException e) {
      //We can catch a NullPointerException here since it will only occur for an unloaded async sound file
    }
  }
}
