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

boolean debug = true; //print stats to console for debugging purposes

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
  initialiseShip(); // set/reset ship properties
  shipGraphic[0] = loadImage("images/ship_float.png");
  shipGraphic[1] = loadImage("images/ship_thrust.png");
  
  //Sound setup
  soundArray[0] = new SoundFile(this, "sounds/laserfire01.mp3");
  
  //Screen setup
  backgroundImage[0] = loadImage("images/title_screen.png");
  backgroundImage[1] = loadImage("images/game_screen.png");
  
  //temp
  steveSetupTemp();
  
}


// GAME LOOP

void draw() {
  
  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  screenHandler(); 
  
  //temp
  steveDrawTemp(); //temporary testing before pulling changes to appropriate locations
  
}
