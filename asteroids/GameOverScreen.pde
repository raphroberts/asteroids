// FUNCTIONS AND GLOBALS THAT RELATE TO THE GAME OVER SCREEN

// resetReady state allows time for threaded functions to finish and game over screen to display
boolean resetReady = false;

void gameOverScreen(){
  // Triggers when ship is hit by enemy
  // drawBackground(index);
  // Display score / level reached
  // Place “return to menu” button
  // if return to menu selected, change currentScreen (to title screen)
  
  background(50);
  text("GAME OVER!! Your score is " + score, width/2, height/2);
  stopAllSounds();
  gameStarted = false;
  gameLevel = 1;
  resetGame();
  if (resetReady == false){ 
    thread("backToMain");
  }
  
}

void backToMain(){
  resetReady = true; 
  delay(4000);
  currentScreen = "title";
}
