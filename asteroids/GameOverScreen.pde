// FUNCTIONS AND GLOBALS THAT RELATE TO THE GAME OVER SCREEN

// resetReady state allows time for threaded functions to finish and game over screen to display
boolean resetReady = false;

void gameOverScreen(){
  // Triggers when ship is hit by enemy
  // drawBackground(index);
  // Display score / level reached
  // Place “return to menu” button
  // if return to menu selected, change currentScreen (to title screen)
  
  background(backgroundImage[1]); 
  
  stopAllSounds();
  gameStarted = false;
  gameLevel = 1;
  resetGame();
  
  // Render dead ship
  translate(shipLocation.x, shipLocation.y);
  rotate(shipRotation);
  image(shipGraphic[shipImageIndex], 0, 0);
  rotate(-shipRotation);
  translate(-shipLocation.x, -shipLocation.y);
  
  // Render explosions
  renderExplosion();
  if(explosionFrame == 15){
     explosionFrame = 0;
     lastCollisionLocation.x = shipLocation.x + random(-35,35);
     lastCollisionLocation.y = shipLocation.y + random(-35,35);
  }
  
  fill(0,100);
  rect(width/2, height/2, width/2,height/8);
  fill(mainFontColour);
  textSize(gameTextSizeMain * 1.5);
  text("GAME OVER!! Your score is " + score, width/2, height/2 - 15);
  textSize(gameTextSizeMain);
  
  if (resetReady == false){ 
    thread("backToMain");
  }
  
}

void backToMain(){
  resetReady = true; 
  delay(4000);
  currentScreen = "title";
}
