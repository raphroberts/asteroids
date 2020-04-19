void gameOverScreen(){
  // Triggers when ship is hit by enemy
  // drawBackground(index);
  // Display score / level reached
  // Place “return to menu” button
  // if return to menu selected, change currentScreen (to title screen)
  
  background(50);
  text("GAME OVER!!", width/2, height/2); 
  
  if (soundArray[shieldSoundIndex].isPlaying())
    soundArray[shieldSoundIndex].stop();
}
