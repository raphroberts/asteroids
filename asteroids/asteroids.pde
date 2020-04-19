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


// GLOBALS
int gameLevel = 1; //auto-increment upon level up
int screenPadding = 40; // padding allowance for objects to float off screen

//shield
int maxShieldHP = 500;
int shieldHP = maxShieldHP;
int shieldRechargeDelay = 50; //recharge 1 point this number of frames
int shieldRechargeTick = 0; //current recharge tick

int weaponDamage = 2;
boolean isBeingDamaged = false; //is ship currently undergoing damage?

// LIBRARIES

import processing.sound.*; //import sound library, results in console warning

// MUSIC

SoundFile[] musicArray = new SoundFile[3];
int playingIndex = 0;
String nowPlaying = "None";

void loadMusic() { // load asynchronously only, due to potentially large file sizes 
  musicArray[1] = new SoundFile(this, "music/s2.mp3");
  musicArray[2] = new SoundFile(this, "music/ThrustSequence.mp3");
}

// SOUNDS

SoundFile[] soundArray = new SoundFile[4];
int shieldSoundIndex;

int shieldSoundEndDelay = 10;
int shieldSoundTick = 0;
boolean endingShieldSound = false;

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
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(230, 230);

  initialiseShip(); // set/reset ship properties
  shipGraphic[0] = requestImage("images/ship_float.png");
  shipGraphic[1] = requestImage("images/ship_thrust.png");
  shipGraphic[2] = requestImage("images/ship_shield.png");

  //Bullet setup
  bulletLocation = new PVector(230, 230);
  
  //Asteroid setup
  enemyGraphics[0] = requestImage("images/asteroid_lg_1.png");
  enemyGraphics[1] = requestImage("images/asteroid_lg_2.png");
  enemyGraphics[2] = requestImage("images/asteroid_lg_3.png");
  enemyGraphics[3] = requestImage("images/asteroid_sm_1.png");
  enemyGraphics[4] = requestImage("images/asteroid_sm_2.png");
  enemyGraphics[5] = requestImage("images/asteroid_sm_3.png");
 
  
  //Sound setup
  soundArray[0] = new SoundFile(this, "sounds/laserfire01.mp3"); //bullet 1
  soundArray[1] = new SoundFile(this, "sounds/shield.mp3"); //shield activation
  soundArray[1].loop();
  soundArray[1].pause();
  shieldSoundIndex = 1;
  
  //Screen setup
  backgroundImage[0] = loadImage("images/title_screen.png");
  backgroundImage[1] = requestImage("images/game_screen.png");
  
  thread("loadMusic"); //start an async thread to load music file sizes in the background
  musicArray[0] = new SoundFile(this, "music/title.mp3"); //force load the title theme first, make it a short loop
  musicManager("title");
  
  // Font and text defaults
  textSize(32);
  
  // generate smoke animation image array
  generateSmoke();

  //temp
  createAsteroid(450, 450, "large");
  createAsteroid(750, 350, "large");
  createAsteroid(750, 350, "small");
}

void generateSmoke(){
    // Generates smokeAnimFrames array used for smoke animation
       
    for (int i = 0; i < numSmokeFrames; i++){
      smokeAnimFrameArray[i] = loadImage("images/smoke_frames/smoke_" + i + ".png");
    }

}


// GAME LOOP

void draw() {

  // handle game screen to display 
  // (located in ReusableFunctions.PDE)
  screenHandler(); 

}
