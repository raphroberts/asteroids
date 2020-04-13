// GLOBAL VARS

String currentScreen = "title screen"; // current screen (title, game, level up, game over)
int gameScore; // current game score
int currentLevel; // current game level

// Ship attributes

PVector location;
PVector velocity;
PVector acceleration;
float shipRotation; // current rotation of ship, (also used for bullet direction when saved to bulletArray)
int shipMaxSpeed; // stores current maximum speed of ship (upgradeable in-game)
int shipTurnSpeed; // (optional) stores current turn speed of ship, which could be upgradeable
PImage shipGraphic; // the current graphic of the ship (upgrades can change the graphic)

// Bullet attributes

float[] bulletArray; // a 2D array storing all bullets currently on screen, their rotation and distance travelled.
int bulletSpeed; //  stores current speed (as applied to all bullets)
PImage bulletGraphic; // the current graphic of the bullet (upgrades can change the graphic)
int bulletStyle; // the shooting style (e.g rapid fire / dual bullet streams)

// Enemy attributes

float[] enemyArray; //  a 2D array storing all enemy locations on screen, and movement direction. Enemies can thus be added and removed on the fly.
float enemySpeed; // speed that enemies move (increases each level)
int numberOfEnemies; // number of enemies to place (increases each level)

// Background images

final String[] backgroundImageArray = { "title.jpg", "game.jpg", "level_up.jpg", "game_over.jpg" }; // an array of background images used in the game
PImage backgroundImage; // current background image

void setup() {
  // window size etc
  }

void draw() {
  screenHandler();
}

void screenHandler() {
  // This function handles which game screen to render based off
  // the currentScreen value which triggers one of the following
  // functions to be called:
  // titleScreen(); (default)
  // gameScreen();
  // levelUpScreen();
  // gameOverScreen();
}
