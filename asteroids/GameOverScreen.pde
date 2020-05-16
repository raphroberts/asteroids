// FUNCTIONS AND GLOBALS THAT RELATE TO THE GAME OVER SCREEN

// State tracking (are we ready to start a new game)
boolean resetReady = false;

void gameOverScreen(){  
  // Main handler for game over screen
  // Plays game over animation, prints score
  // then returns the player to the title screen
  
  background(backgroundImage[1]);   
  stopAllSounds();
  gameStarted = false;  
  
  // Set game state back to defaults
  resetGame();  
  
  // Render dead ship
  translate(shipLocation.x, shipLocation.y);
  rotate(shipRotation);
  image(shipGraphic[shipImageIndex], 0, 0);
  rotate(-shipRotation);
  translate(-shipLocation.x, -shipLocation.y);  
  
  // Render explosions on dead ship
  renderExplosion();
  if(explosionFrame == 15){
     explosionFrame = 0;
     lastCollisionLocation.x = shipLocation.x + random(-35,35);
     lastCollisionLocation.y = shipLocation.y + random(-35,35);
  }  
  
  // Render player's score
  fill(0,100);
  rect(width/2, height/2, width/2,height/8);
  fill(mainFontColour);
  textSize(gameTextSizeMain * 1.5);
  text("GAME OVER!! Your score is " + score, width/2, height/2 - 15);
  textSize(gameTextSizeMain);  
  
  // Allow 4 seconds for player to read score and threaded functions to finish
  if (resetReady == false){ 
    thread("backToMain");
  } 
}

void resetGame() {
  // Sets game back to initial state so it can be played again
  
  stopAllSounds();  
  
  // Empty enemy asteroid array
  enemyObject = new ArrayList<int[]>(); 
  
  // Reset game states
  levelComplete = true;
  bossActivated = false;
  continueLevel = false;
  levelComplete = false; 
  gameStarted = false;
  gameLevel = 1;  
  
  // Rebuild icon image array
  populateImageArray(iconsUI, "images/icons/icon_", 10); 
  
  // Reset shield and thruster
  changeThruster(1);
  changeShield(1);  
  
  // Reset upgrades
  tripleLaserUpgradeEnabled = false;
  magnusEnforcedUpgradeEnabled = false;
  MK2ShieldUpgradeEnabled = false;
  thrusterUpgradeEnabled = false;
  rapidFireUpgradeEnabled = false;
  upGradeActive = new boolean[]{ false, false, false, false, false };  
  
  // Empty star field and reset title screen
  starObject = new ArrayList<int[]>(); 
  titleSetup(); 
  
  // Reset boss strength
  bossInitialStrength = bossNewGameStrength;
  bossStrength = bossInitialStrength;
}

void backToMain(){
  // Delay 4 seconds then return the game to the title screen]
  // (best used as a threaded function)
  
  resetReady = true; 
  delay(4000);
  currentScreen = "title";
}
