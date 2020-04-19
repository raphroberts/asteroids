// Game screen globals

int score = 0;
/*
void initialiseEnemyObjects() {
  enemyObject.add(new int[] {0, 100, 100, 50});
}*/

void checkCollision() {
  // Check for collisions between asteroid / ship and bullet / asteroid
  
  // check if ship has hit an asteroid
  for (int i = 0; i < enemyObject.size(); i++) {
    //Retrieve the values from the enemyObject
    PVector hitbox = new PVector(enemyObject.get(i)[1], enemyObject.get(i)[2]); //hitbox for this enemyObject
    int hitboxSize = enemyObject.get(i)[3];
    if (dist(shipLocation.x, shipLocation.y, hitbox.x, hitbox.y) <hitboxSize) {
      println("ship collision");
      currentScreen = "game over";
    }
  }

  // check if bullet has hit an asteroid
  // for every bullet, itterate through asteroid list and check for a collision
  for (int i = 0; i < bulletObject.size(); i++) {
    PVector bulletHitbox = new PVector(bulletObject.get(i)[1], bulletObject.get(i)[2]); // location of this bullet

    for (int j = 0; j < enemyObject.size(); j++) {
      //Retrieve the values from the enemyObject
      PVector hitbox = new PVector(enemyObject.get(j)[1], enemyObject.get(j)[2]); //hitbox for this enemyObject
      int hitboxSize = enemyObject.get(j)[3];
      if (dist(bulletHitbox.x, bulletHitbox.y, hitbox.x, hitbox.y) <hitboxSize) {
        bulletObject.remove(i);
        score ++;
      }
    }
    
  }
}


void renderOverlay() {
  // Print current score and level to the screen
}


// KEYBOARD INPUT

void keyPressed() {
  if (key == 'a') {
    rotateLeft = true;
  }
  if (key == 'd') {
    rotateRight = true;
  }
  if (key == 'w') {
    accelerate = true;
    shipImageIndex = 1;
  }
  if (key == ' ') {
    createBullet();
    gunReloaded = false;
  }
  if (key == 'p') {
    // note: replace this with mouse interaction with button
    currentScreen = "game";
  }
}

void keyReleased() {

  if (key == 'a') {
    rotateLeft = false;
  }
  if (key == 'd') {
    rotateRight = false;
  }
  if (key == 'w') {
    shipImageIndex = 0;
    accelerate = false;
  }
  if (key == ' ') {
    gunReloaded = true;
    shipImageIndex = 0;
    accelerate = false;
  }
}
