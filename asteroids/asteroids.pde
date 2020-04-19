/* 
    _   ___ _____ ___ ___  ___ ___ ___  ___ 
   /_\ / __|_   _| __| _ \/ _ \_ _|   \/ __|
  / _ \\__ \ | | | _||   / (_) | || |) \__ \
 /_/ \_\___/ |_| |___|_|_\\___/___|___/|___/
 
 An implementation of the traditional Asteroids game
 Note: Requires processing sound library to be installed
 
 DEV NOTES:
 Currently globals are stored inside separate PDE files to reflect what they relate to
 Hopefully this works for everyone?
 
 KNOWN ISSUES:
 Ship fires when game screen loads
 
*/




// LIBRARIES

import processing.sound.*; //import sound library, results in console warning

// SOUNDS

SoundFile[] soundArray = new SoundFile[3]; //index = currentWeapon index

// SCREENS

String currentScreen = "title";
PImage[] backgroundImage = new PImage[3]; // background image array

// DEBUG

boolean debug = false; //print stats to console for debugging purposes

// SETTINGS

void settings() {
  size(800, 500);
}

// SETUP

void setup() {

  //General
  frameRate(60);  
  rectMode(CENTER); 
  imageMode(CENTER); 

  //Ship setup
  shipAcceleration = new PVector(0, 0);
  shipAcceleration.limit(0.1);
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(230, 230);

  initialiseShip(); // set/reset ship properties
  shipGraphic[0] = loadImage("images/ship_float.png");
  shipGraphic[1] = loadImage("images/ship_thrust.png");

  //Bullet setup
  bulletLocation = new PVector(230, 230);
  
  //Asteroid setup
  enemyGraphics[0] = loadImage("images/asteroid_lg_1.png");
  enemyGraphics[1] = loadImage("images/asteroid_lg_2.png");
  enemyGraphics[2] = loadImage("images/asteroid_lg_3.png");
  enemyGraphics[3] = loadImage("images/asteroid_sm_1.png");
  enemyGraphics[4] = loadImage("images/asteroid_sm_2.png");
  enemyGraphics[5] = loadImage("images/asteroid_sm_3.png");

  //Sound setup
  soundArray[0] = new SoundFile(this, "sounds/laserfire01.mp3");

  //Screen setup
  backgroundImage[0] = loadImage("images/title_screen.png");
  backgroundImage[1] = loadImage("images/game_screen.png");
  
  // Font and text defaults
  textSize(32);

  //temp
  createAsteroid(450, 450, "large");
  createAsteroid(750, 350, "large");
}


// GAME LOOP

void draw() {

  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  screenHandler(); 

}
