// FUNCTIONS AND GLOBALS THAT RELATE TO THE GAME OVER SCREEN


void gameOverScreen(){
  // Triggers when ship is hit by enemy
  // drawBackground(index);
  // Display score / level reached
  // Place “return to menu” button
  // if return to menu selected, change currentScreen (to title screen)
  
  background(50);
  text("GAME OVER!!", width/2, height/2); 

  stopAllSounds();
  gameStarted = false;
  gameLevel = 1;
  restartGame(); // DONT USE THIS. Exit the program now. Too many things don't get reset properly and leads to glitches. This could be a massive time sink, best to avoid I think!
}
