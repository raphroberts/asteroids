void screenHandler() {
  // Function to manage screen changes

  switch(currentScreen) {

  case "title": 
    // display title screen
    background(backgroundImage[0]);
    break;

  case "game": 
    // display game screen
    background(backgroundImage[1]);

    // Move the ship
    moveShip();
    
    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveBullets();
    
    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveEnemies();
    
    // Check for collisions
    // (located in GameScreen.PDE)
    checkCollision();
    rechargeShield();
    
    // render score
    
    text ("Score: " + score, 20,20);
    text ("Shield: " + shieldHP, width-200, 40);

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
  // returns a random integer
  return (int)round(random(low, high));
}
