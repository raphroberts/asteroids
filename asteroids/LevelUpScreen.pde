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
boolean rapidFireUpgradeEnabled = true;

void upgradeScreen() {
  // Handles selection of ship upgrades
  
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

  
  fill(#FF6F57);
  textSize(26);

  if (leftArrowTintActive) {
    tint(#FFA295);
    image(upgradeScreenImage[0], width/4, height / 2);
    tint(255);
  }
  else {
    image(upgradeScreenImage[0], width/4, height / 2);
  }
  
  if (rightArrowTintActive) {
    tint(#FFA295);
    image(upgradeScreenImage[1], width - width/4, height /2);
    tint(255);
  }
  else {
    image(upgradeScreenImage[1], width - width/4, height /2);
  }
  
  
  if (upgradeScreenIndex == 0) {
    if (upgradeTintActive) {
      tint(#FFA295);
      image(shipGraphic[1], width/2, height/2);  
      tint(255);
    }
    else {
      image(shipGraphic[1], width/2, height/2);  
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
  
  if (mouseX >= width/2 - upgradeScreenImage[2].width/2 && mouseX <= width/2 - upgradeScreenImage[2].width/3.5 &&
      mouseY >= height - 20 - upgradeScreenImage[2].height && mouseY <= height - upgradeScreenImage[2].height/2) { // Raph.. please forgive me. I'm a lost soul when it comes to this sort of thing!
    leftArrowTintActive = true;
  }
  else {
    leftArrowTintActive = false;
  }
  if (mouseX >= width/2 - upgradeScreenImage[2].width/2 + 300 && mouseX <= width/2 - upgradeScreenImage[2].width/3.5 + 300 &&
      mouseY >= height - 20 - upgradeScreenImage[2].height && mouseY <= height - upgradeScreenImage[2].height/2) {
      rightArrowTintActive = true;
      }
  else {
    rightArrowTintActive = false;
  }
  if (mouseX >= width/2 - upgradeScreenImage[2].width/2 + 150 && mouseX <= width/2 - upgradeScreenImage[2].width/3.5 + 150 &&
      mouseY >= height - 20 - upgradeScreenImage[2].height && mouseY <= height - upgradeScreenImage[2].height/2) {
    upgradeTintActive = true;
      }
  else {
    upgradeTintActive = false;
  }
  
  if (mousePressed && !mouseDown) {
    mouseDown = true;
    if (upgradeTintActive) {
      //upgrade selected. Enable upgrade, continue game;
      if (upgradeScreenIndex == 0)
        tripleLaserUpgradeEnabled = true;
      else if (upgradeScreenIndex == 1)
        magnusEnforcedUpgradeEnabled = true;
      else if (upgradeScreenIndex == 2) {
        MK2ShieldUpgradeEnabled = true;
        shieldImageIndex = 2;
        changeShield(2);  
      }
      else if (upgradeScreenIndex == 3) {
        thrusterUpgradeEnabled = true;
        thrusterImageIndex = 2;
        changeThruster(2);
      }
      else if (upgradeScreenIndex == 4) {
        rapidFireUpgradeEnabled = true;
        gunReloaded = false;
        iconsUI[0] = requestImage("images/icons/icon_single2.png");
      }
      continueLevel = true;  
    }
    else if (leftArrowTintActive) {
      if (--upgradeScreenIndex < 0)
        upgradeScreenIndex = upgradeScreenIndexLimit;
    }
    else if (rightArrowTintActive) {
      if (++upgradeScreenIndex > upgradeScreenIndexLimit)
        upgradeScreenIndex = 0;
    }
  }
}

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

void cycleUpgradeUI() {
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
