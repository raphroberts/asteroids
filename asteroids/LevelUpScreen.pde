// FUNCTIONS AND GLOBALS THAT RELATE TO THE LEVEL-UP SCREEN

// Index of upgrade to display
int upgradeScreenIndex = 0;
int upgradeScreenIndexLimit = 4;

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

void renderCurrentUpgrade(){
  // Render current upgrade
  
  for (int i = 0; i <= upgradeScreenIndexLimit; i++){
    // if we are at the current upgrade index
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
    } 
  } 
  
}

String[] upGradeTitles = { "Continuous Fire", "Triple shot", "Enforcer", "Shield MK 2", "Thruster MK 2" };
String[] upGradeDescriptions = { "The single shot weapon can fire continuously by holding down the fire button", "Shoot three streams of bullets", "Charges a high power laser beam", "Increase shield capacity", "Increases ship speed" };
boolean[] upGradeActive = { false, false, false, false, false };

void upgradeScreen() {
  // Handles selection of ship upgrades
  
 // Set cursor to crosshair image
  cursor(cursor);
  
  // Not sure what this is for steve?
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
    
  //temp upgrade fix, remove taken upgrades  
  activeUpgradeOnlyFix();
  
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

renderCurrentUpgrade();

/*  
  // Triple pulse laser upgrade
  if (upgradeScreenIndex == 0) {
    if (upgradeTintActive) {
      pulseUpgrade(1);
    }
    else {
      stopPulseUpgrade(1); 
    }
    // Triple pulse laser upgrade
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height/2);
    //strokeWeight(1);
    //text("Through unique engineering, three standard lasers are combined together to fire at once, offering a three times greater combined rpm, with the same damage per bullet.", width/2, height - 50);
    fill(255);
    text("Stats\nMax firerate: 36rps\nDamage per shot: 6", width - 100, height / 2);
  }
  
  else if (upgradeScreenIndex == 1) {
    // Blue billy upgrade
   if (upgradeTintActive) {
      tint(#FFA295);
      image(shipGraphic[2], width/2, height - 160);  
      tint(255);
    }
    else {
      image(shipGraphic[2], width/2, height - 160);  
    }
    //text("Triple Pulse Laser", width/2, height - 100);
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height - 20);
    //strokeWeight(1);
    //text("Through unique engineering, three standard lasers are combined together to fire at once, offering a three times greater combined rpm, with the same damage per bullet.", width/2, height - 50);
    fill(255);
    text("Stats\nMax firerate: 0.5rps\nDamage per shot: 250\nCooldown: 1 second", width - 100, height / 2);
  }
  
  else if (upgradeScreenIndex == 2) {
    // MK2 Shield upgrade
     if (upgradeTintActive) {
        tint(#FFA295);
        image(shieldGraphic[2], width/2, height - 160);  
        tint(255);
      }
      else {
        image(shieldGraphic[2], width/2, height - 160);  
      }
    //text("Triple Pulse Laser", width/2, height - 100);
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height - 20);
    //strokeWeight(1);
    //text("Through unique engineering, three standard lasers are combined together to fire at once, offering a three times greater combined rpm, with the same damage per bullet.", width/2, height - 50);
    fill(255);
    text("Stats\nHitpoints: 1500\nRecharge rate: x2.5 Standard", width - 100, height / 2);
  }
  
  else if (upgradeScreenIndex == 3) {
    // Thruster upgrade
     if (upgradeTintActive) {
        tint(#FFA295);
        image(iconsUI[8], width/2, height - 160);  
        tint(255);
      }
      else {
        image(iconsUI[8], width/2, height - 160);  
      }
    //text("Triple Pulse Laser", width/2, height - 100);
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height - 20);
    //strokeWeight(1);
    //text("Through unique engineering, three standard lasers are combined together to fire at once, offering a three times greater combined rpm, with the same damage per bullet.", width/2, height - 50);
    fill(255);
    text("Stats\nMax Speed: 4\nManvouerability: 7", width - 100, height / 2);
  }

  else if (upgradeScreenIndex == 4) {
    // Rapid fire upgrade
     if (upgradeTintActive) {
        tint(#FFA295);
        image(iconsUI[9], width/2, height - 160);  
        tint(255);
      }
      else {
        image(iconsUI[9], width/2, height - 160);  
      }
    //text("Triple Pulse Laser", width/2, height - 100);
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height - 20);
    //strokeWeight(1);
    //text("Through unique engineering, three standard lasers are combined together to fire at once, offering a three times greater combined rpm, with the same damage per bullet.", width/2, height - 50);
    fill(255);
    text("Rapid fire upgrade", width - 100, height / 2);
  }
 */
 
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
  
  if (mousePressed && !mouseDown) {
    mouseDown = true;
    if (upgradeTintActive) {
      //upgrade selected. Enable upgrade, continue game;
      if (upgradeScreenIndex == 0) {
        rapidFireUpgradeEnabled = true;
        gunReloaded = false;
        iconsUI[0] = requestImage("images/icons/icon_single2.png");
      }
      else if (upgradeScreenIndex == 1)
        tripleLaserUpgradeEnabled = true;
      else if (upgradeScreenIndex == 2)
        magnusEnforcedUpgradeEnabled = true;
      else if (upgradeScreenIndex == 3) {
        MK2ShieldUpgradeEnabled = true;
        shieldImageIndex = 2;
        changeShield(2);  
      }
      else if (upgradeScreenIndex == 4) {
        thrusterUpgradeEnabled = true;
        thrusterImageIndex = 2;
        changeThruster(2);
      }
      noCursor();
      continueLevel = true;  
    }
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

/*
void activeUpgradeOnlyFix() {
  boolean found = false;
  int currentIndex = upgradeScreenIndex;
  int iterations = 0;
  while (!found && iterations < 2) {
    if (upgradeScreenIndex == 0 && tripleLaserUpgradeEnabled)
      cycleUpgradeUI();
    if (upgradeScreenIndex == 1 && magnusEnforcedUpgradeEnabled)
      cycleUpgradeUI();
    if (upgradeScreenIndex == 2 && MK2ShieldUpgradeEnabled)
      cycleUpgradeUI();
    if (upgradeScreenIndex == 3 && thrusterUpgradeEnabled)
      cycleUpgradeUI();
    if (upgradeScreenIndex == 4 && rapidFireUpgradeEnabled)
      cycleUpgradeUI();
    else {
      found = true;
    }
    iterations++;
  }
}
*/

void cycleUpgradeUI() {
  
  // Cycle through weapon upgrades
  if (leftArrowTintActive) 
    upgradeScreenIndex--;
  else if (rightArrowTintActive)
    upgradeScreenIndex++;
  else
    upgradeScreenIndex++; 
  if (upgradeScreenIndex < 0)
    upgradeScreenIndex = upgradeScreenIndexLimit;
  else if (upgradeScreenIndex > upgradeScreenIndexLimit)
    upgradeScreenIndex = 0;
}

boolean areAllUpgradesEnabled() {
  //check whether all upgrades are already enabled
  if (tripleLaserUpgradeEnabled && magnusEnforcedUpgradeEnabled && MK2ShieldUpgradeEnabled
    && thrusterUpgradeEnabled) {
    return true;
    }
   
   return false; 
}

void mouseReleased() { //generic function for all mouseReleased throughout the game. Refactor somewhere central. Can be used for other things, just ensure mouseDown = false is kept
  mouseDown = false;
}
