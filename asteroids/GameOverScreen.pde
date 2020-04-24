// FUNCTIONS AND GLOBALS THAT RELATE TO THE GAME OVER SCREEN


void gameOver(){
  // Game over screen is an overlay
  
  
  image(levelStatusImage[3], width/2, height/2); 
  
  if (soundArray[shieldSoundIndex].isPlaying())
    soundArray[shieldSoundIndex].pause();
  musicManager("none");
  boolean gameStarted = false;
  
  
  //delay(2500);
  //currentScreen = "title";
  
}
