void screenHandler(){
  // Function to manage screen changes

  switch(currentScreen) {
    
    case "title": 
      // display title screen
      background(backgroundImage[0]);
      break;
      
    case "game": 
      // display game screen
      background(backgroundImage[1]);
      
      // Game screen sprite functions
      // (Located in Sprites.PDE)
      asteroidHandler(); 
      bulletHandler();
      moveShip();
      
      // check for collisions
      // (located in GameScreen.PDE)
      checkCollision();
      
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

void populateEnemiesArray() {
  // This function fetches the current number of enemies (increases per level)
  // then builds the enemyArray with random enemy PVectors.
  // Note: ensure location is not too close to player’s spawn point 
}

String renderButton(String buttonText, float x, float y){
  // Renders an interactive button with provided buttonText at X,Y coords
  // Used on title screen, upgrade screens, game over screen
  
  return null; //delete this, temp to prevent error
}
