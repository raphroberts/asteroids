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

// minim library used for sounds, found here: http://code.compartmental.net/tools/minim/ 
// - alternatively install directly via Sketch > Imporant Library > Add Library > Minim
// This library approved for assignment according to COSC 101 stack Unit Coordinator
import ddf.minim.*;


// ASYNC PRE LOADING (post-title screen async loading)

boolean preloadingFinished = false;

void preloading() { //call asynchronously
  //load title screen music
  
  musicArray[0] = minim.loadFile("music/title.mp3");
  
  //musicArray[0] = new SoundFile(this, "music/title.mp3"); //force load the title theme first, make it a short loop
  if (currentScreen == "title")
    musicManager("title");
    
  //preload game sfx
  soundArray[0] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[1] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[2] = minim.loadFile("sounds/laserfire01.mp3"); //bullet 1
  soundArray[3] = minim.loadFile("sounds/burstfire.mp3"); //bullet 2
  soundArray[4] = minim.loadFile("sounds/laserfire02.mp3"); //bullet 3
  soundArray[5] = minim.loadFile("sounds/shield.mp3"); //shield activation
  soundArray[5].loop();
  soundArray[5].pause();
  shieldSoundIndex = 5;
  soundArray[6] = minim.loadFile("sounds/alarm.mp3");
  soundArray[7] = minim.loadFile("sounds/warningShield.mp3");
  soundArray[8] = minim.loadFile("sounds/attentionLifeform.mp3");
  preloadingFinished = true;
 
  // Create array of music tracks
  musicArray[1] = minim.loadFile("music/s2.mp3");
  musicArray[1].loop();
  musicArray[1].pause();
  musicArray[2] = minim.loadFile("music/ThrustSequence.mp3");
  musicArray[2].loop();
  musicArray[2].pause();
}

// MUSIC

//SoundFile[] musicArray = new SoundFile[3];
int playingIndex = 0;

// SFX

Minim minim;
AudioPlayer[] musicArray = new AudioPlayer[10];


AudioPlayer[] soundArray = new AudioPlayer[10];
int shieldSoundIndex;
boolean shieldWarningTriggered = false;
int bulletshotIndex = 0;

int shieldSoundEndDelay = 10;
int shieldSoundTick = 0;
boolean endingShieldSound = false;

// SCREENS

String currentScreen = "title";
PImage[] backgroundImage = new PImage[4]; // background image array

// DEBUG

boolean debug = true; //print stats to console for debugging purposes

// SETTINGS

void settings() {
  size(800, 500);
}

// SETUP

void setup() {
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
     
  // Title screen setup
  titleSetup();
  
  //General
  frameRate(60);  
  rectMode(CENTER); 
  imageMode(CENTER); 
  
  //Ship setup
  shipAcceleration = new PVector(0, 0);
  shipAcceleration.limit(0.1);
  shipVelocity = new PVector(0, 0);
  shipLocation = new PVector(width/2, height/2);

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
  
  iconsUI[0] = requestImage("images/dummygun.png");
 
  //preload assets async
  thread("preloading");
  
  //Screen setup
  backgroundImage[0] = loadImage("images/title_screen.png");
  backgroundImage[1] = requestImage("images/game_screen.png");
  backgroundImage[2] = requestImage("images/upgrade_screen.png");
  
  // Font and text defaults
  textSize(26);
  
  // generate smoke animation image array
  generateSmoke();
  
  // Initialize stats
  changeWeapon(1);

  //temp
  //createAsteroid(450, 450, "large");
  //createAsteroid(750, 350, "large");
  //createAsteroid(750, 350, "small");
  
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
