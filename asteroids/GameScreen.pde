
void gameScreen() {
  drawBackground(index); // draw level background image
  enemyHandler(); // render all enemies at their current PVectors
  bulletHandler(); // render bullets, add new bullets if shooting
  shipHandler(); // render ship and PVectors calculations
  collisionDetection(); // check if enemies hit, if enemies=0 level up
  // check if ship has been hit, if yes game over
  renderOverlay(); // render score and level to the game screen
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
