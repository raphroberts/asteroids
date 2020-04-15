
void gameScreen() {

  //drawBackground(index); // draw level background image
  //enemyHandler(); // render all enemies at their current PVectors
  //bulletHandler(); // render bullets, add new bullets if shooting
  //shipHandler(); // render ship and PVectors calculations
  //collisionDetection(); // check if enemies hit, if enemies=0 level up
  // check if ship has been hit, if yes game over
  //renderOverlay(); // render score and level to the game screen
}

void checkCollision() {
  // check if ship has hit the square
  if (dist(shipLocation.x, shipLocation.y, collisionObjectX, collisionObjectY) < 50) {
    println("ship collision");
    currentScreen = "game over";
  }
  // check if bullet has hit asteroid
  // code later

}

void renderOverlay() {
  // Print current score and level to the screen
}

void collisionDetection() {
  // Iterate through enemy array and check for collision with ship
  // If yes, change currentScreen (to game over screen)
  // also check if current enemy has collided with bullet
  // if yes, remove current enemy
  // if enemyArray.length=0, cursor(arrow); and change currentScreen (level up)
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
    shipShooting = true;
    shotFinished = false;
    soundArray[0].play();
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
}
