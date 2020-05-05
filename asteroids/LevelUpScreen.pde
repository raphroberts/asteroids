// FUNCTIONS AND GLOBALS THAT RELATE TO THE LEVEL-UP SCREEN

// Index of upgrade to display
int upgradeScreenIndex = 0;
int upgradeScreenIndexLimit = 4;

// Graphics
PImage cursor;

// Navigation arrows
boolean leftArrowTintActive = false;
boolean rightArrowTintActive = false;
boolean upgradeTintActive = false;
boolean mouseDown = true; //a disgusting hack, but Processing has no mouseReleased boolean, only a function

// State of upgrades
boolean tripleLaserUpgradeEnabled = false;
boolean magnusEnforcedUpgradeEnabled = false;
boolean MK2ShieldUpgradeEnabled = false;
boolean thrusterUpgradeEnabled = false;
boolean rapidFireUpgradeEnabled = false;

// Button animation data
float upgradeArrow = 47;
float upgradeButtonIcon = 50;
color tintValue = color(255, 0, 255);

// Positioning data
int upGradeOffset = 40;

void pulseUpgrade(int pulseIndex){
  // Make upgrade icon pulse
  
  tint(tintValue);
  upgradeButtonIcon =  pulseImage(50, 40, 0.9, 5, false);
  image(iconsUI[pulseIndex], width/2, height/4 + upGradeOffset, upgradeButtonIcon, upgradeButtonIcon); 
  tint(255);
}

void stopPulseUpgrade(int pulseIndex){
  // Stop upgrade icon from pulsing
  
  image(iconsUI[pulseIndex], width/2, height/4 + upGradeOffset);  
}

void renderUpgradeScreen(){
  // Draws the upgrade screen and handles mouseover effect on elements
  
  background(backgroundImage[2]);

  if (leftArrowTintActive) {
    tint(tintValue);
    upgradeArrow =  pulseImage(48, 37, 0.9, 5, false);
    image(upgradeScreenImage[0], width/8, height/2, upgradeArrow, upgradeArrow * 2); 
    tint(255);
  }
  else {
    image(upgradeScreenImage[0], width/8, height / 2);
  }
  
  if (rightArrowTintActive) {
    tint(tintValue);
    upgradeArrow =  pulseImage(48, 37, 0.9, 5, false);
    image(upgradeScreenImage[1], width - width/8, height/2, upgradeArrow, upgradeArrow * 2); 
    tint(255);
  }
  else {
    image(upgradeScreenImage[1], width - width/8, height /2);
  }
  
  // Check if mouse is hovering over arrows
  if (mouseX >= width - width/3) { 
    rightArrowTintActive = true;
  }
  else {
    rightArrowTintActive = false;
  }
  if (mouseX <= width/3) { 
    leftArrowTintActive = true;
  }
  else {
    leftArrowTintActive = false;
  }
  
  // Check if mouse is hovering over upgrade
  if (mouseX >= width/3 && mouseX <= width - width/3) {
    upgradeTintActive = true;
      }
  else {
    upgradeTintActive = false;
  }  

}

void renderCurrentUpgrade(){
  // Render the upgrade that has been browsed to
  
  for (int i = 0; i <= upgradeScreenIndexLimit; i++){
    // Render the upgrade unless it has already been activated
    if (i == upgradeScreenIndex){
      // pulse the upgrade if the mouse is hovering over it
      if (upgradeTintActive) {
        pulseUpgrade(i);
      }
      else {
        stopPulseUpgrade(i); 
      }
      textSize(26);
      text(upGradeTitles[i], width/2, 300);
      textSize(16);
      text(upGradeDescriptions[i], width/2, 270, width/2, 100);
      if (upGradeActive[i]){
        image(upgradeScreenImage[2], width/2, height/2);
      }
    } 
  } 
}

void checkForSelection(){
  // Handles UI clicks on upgrade screen
  
  if (mousePressed && !mouseDown) {
    mouseDown = true;
    
    // If an upgrade was selected, activate it and continue the game
    if (upgradeTintActive) {
      if (upgradeScreenIndex == 0 && !rapidFireUpgradeEnabled) {
        rapidFireUpgradeEnabled = true;
        gunReloaded = false;
        iconsUI[0] = iconsUI[10];
        upGradeActive[upgradeScreenIndex] = true;
        continueLevel = true;  
      }
      else if (upgradeScreenIndex == 1 && !tripleLaserUpgradeEnabled) {
        tripleLaserUpgradeEnabled = true;
        upGradeActive[upgradeScreenIndex] = true;
        continueLevel = true;  
      }
      else if (upgradeScreenIndex == 2 && !magnusEnforcedUpgradeEnabled) {
        magnusEnforcedUpgradeEnabled = true;
        upGradeActive[upgradeScreenIndex] = true;
        continueLevel = true;  
      }
      else if (upgradeScreenIndex == 3 && !MK2ShieldUpgradeEnabled) {
        MK2ShieldUpgradeEnabled = true;
        shieldImageIndex = 2;
        changeShield(2);  
        upGradeActive[upgradeScreenIndex] = true;
        continueLevel = true;  
      }
      else if (upgradeScreenIndex == 4) {
        thrusterUpgradeEnabled = true;
        thrusterImageIndex = 2;
        changeThruster(2);
        upGradeActive[upgradeScreenIndex] = true;
        continueLevel = true;  
      }
      noCursor();
    }
    
    // If a navigation arrow was pressed, scroll to the next/previous upgrade
    else if (leftArrowTintActive) {
      upgradeScreenIndex --;
      if (upgradeScreenIndex < 0)
        upgradeScreenIndex = upgradeScreenIndexLimit;
    }
    else if (rightArrowTintActive) {
      upgradeScreenIndex ++;
      if (upgradeScreenIndex > upgradeScreenIndexLimit)
        upgradeScreenIndex = 0;
    }
  }
  
}

String[] upGradeTitles = { "Continuous Fire", "Triple shot", "Enforcer", "Shield MK 2", "Thruster MK 2" };
String[] upGradeDescriptions = { "Upgrades single shot cannon to fire continuously when holding down the fire button", "Shoot three streams of bullets", "Charges a high power laser beam", "Increase shield capacity", "Increases ship speed" };
boolean[] upGradeActive = { false, false, false, false, false };

void upgradeScreen() {
  // Handles selection of ship upgrades
  
 // Set cursor to crosshair image
  cursor(cursor);
  
  // Stop ship from accelerating
  accelerate = false;
  
  // Skip upgrade screen if all upgrades already taken
  if (areAllUpgradesEnabled()) { 
    continueLevel = true;    
    return;
  }
  
  // Stop thruster sound if it is playing
  if (soundArray[13].isPlaying()) {
    soundArray[13].pause(); // stop thruster sound
  }
  
  // Render the upgrade screen
  renderUpgradeScreen();
  
  // Render the current upgrade
  renderCurrentUpgrade();
 
  // Check if an upgrade has been selected
  checkForSelection();
  
}


boolean areAllUpgradesEnabled() {
  //check whether all upgrades are already enabled
  
  if (tripleLaserUpgradeEnabled && magnusEnforcedUpgradeEnabled && MK2ShieldUpgradeEnabled
    && thrusterUpgradeEnabled) {
    return true;
    }
   
   return false; 
}
