int upgradeScreenIndex = 0;
int upgradeScreenIndexLimit = 2;
boolean leftArrowTintActive = false;
boolean rightArrowTintActive = false;
boolean upgradeTintActive = false;
boolean mouseDown = true; //a disgusting hack, but Processing has no mouseReleased boolean, only a function

boolean tripleLaserUpgradeEnabled = false;
boolean magnusEnforcedUpgradeEnabled = false;
boolean MK2ShieldUpgradeEnabled = false;

void upgradeScreen() {
  background(backgroundImage[1]);
  //background(backgroundImage[2]);
  //LevelUpBanner =  pulseImage(806, 780, 0.9, 3, false);
  image(levelStatusImage[1], width/2, height/2 - 100, LevelUpBanner,114); 
  //levelUpStar =  pulseImage(108, 100, 0.7, 4, false);
  image(levelStatusImage[0], width/2, height/3 - 100, levelUpStar, levelUpStar); 
  
  fill(#FF6F57);
  textSize(26);
  text("Select Upgrade: ", width/2, height/2 - 20);
  if (leftArrowTintActive) {
    tint(#FFA295);
    image(upgradeScreenImage[0], width/2 - 150, height - 160);
    tint(255);
  }
  else {
    image(upgradeScreenImage[0], width/2 - 150, height - 160);
  }
  
  if (rightArrowTintActive) {
    tint(#FFA295);
    image(upgradeScreenImage[1], width/2 + 150, height - 160);
    tint(255);
  }
  else {
    image(upgradeScreenImage[1], width/2 + 150, height - 160);
  }
  
  
  
  
  if (upgradeScreenIndex == 0) {
    if (upgradeTintActive) {
      tint(#FFA295);
      image(shipGraphic[0], width/2, height - 160);  
      tint(255);
    }
    else {
      image(shipGraphic[0], width/2, height - 160);  
    }
    // Triple pulse laser upgrade
    //text("Triple Pulse Laser", width/2, height - 100);
    textSize(gameTextSizeMain);
    image(upgradeScreenImage[2], width/2, height - 20);
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
        changeShield(2);  
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

void mouseReleased() { //generic function for all mouseReleased throughout the game. Refactor somewhere central. Can be used for other things, just ensure mouseDown = false is kept
  mouseDown = false;
}
