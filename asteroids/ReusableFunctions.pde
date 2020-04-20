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
    
    // render score
    
    text ("Score: " + score, 20,20);
    text ("Shield: " + shieldHP, width-200, 40);
    text ("Now Playing: " + nowPlaying + ". Press 'N' for next song", 40, height-40);

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
