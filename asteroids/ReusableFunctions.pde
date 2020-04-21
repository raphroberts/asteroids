// FUNCTIONS AND GLOBALS THAT DON'T RELATE ONLY TO ONE SCREEN

// Game font globals
PFont gameFont;
final int gameTextSizeMain = 16;
final int mainFontColour = 255;

/*
  ___                    _                 _ _ _           
 / __| __ ___ ___ _ _   | |_  __ _ _ _  __| | (_)_ _  __ _ 
 \__ \/ _/ -_) -_) ' \  | ' \/ _` | ' \/ _` | | | ' \/ _` |
 |___/\__\___\___|_||_| |_||_\__,_|_||_\__,_|_|_|_||_\__, |
   
*/
 
String currentScreen = "title";
PImage[] backgroundImage = new PImage[4]; // background image array

void screenHandler() {
  // Function to manage screen changes

  switch(currentScreen) {

  case "title": 
    // display title screen
    titleScreen();
    break;

  case "game": 
    // display game screen
    background(backgroundImage[1]);

    // Render the starfield
    // (located in GameScreen.PDE)
    renderStars();

    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveBullets();
    
    // Move the ship
    moveShip();
    
    // Update bullet locations
    // (located in Sprites.PDE)
    drawAndMoveEnemies();
    
    // Check for collisions
    // (located in GameScreen.PDE)
    checkCollision();
    rechargeShield();
    
    // render explosion if asteroid was hit
    renderExplosion();
    
    UIManager();
    break;

  case "level up": 
    // display level up screen
    
    background(backgroundImage[2]);
    //DELETE THIS, TEMP ONLY
    text("Press Y to continue", width/2, height/2); //temp, delete and replace with level up screen
    if (continueLevel) {
      continueLevel = false;
      gameLevel = gameLevel + 1;
      thread("levelSequence");
      currentScreen = "game";
    //END DELETE THIS, TEMP ONLY
    }
    break;

  case "game over": 
    // display game overscreen
    gameOverScreen();
    break;
  }
}

/*

  ___          _       __              _   _             
 | _ ) __ _ __(_)__   / _|_  _ _ _  __| |_(_)___ _ _  ___
 | _ \/ _` (_-< / _| |  _| || | ' \/ _|  _| / _ \ ' \(_-<
 |___/\__,_/__/_\__| |_|  \_,_|_||_\__|\__|_\___/_||_/__/
 
*/
    
    
String renderButton(String buttonText, float x, float y) {
  // Renders an interactive button with provided buttonText at X,Y coords
  // Used on title screen, upgrade screens, game over screen

  return null; //delete this, temp to prevent error
}


int randomInt(int low, int high) {
  // Returns a random integer
  
  return (int)round(random(low, high));
}

/*
  __  __         _      ___ _____  __
 |  \/  |_  _ __(_)__  / __| __\ \/ /
 | |\/| | || (_-< / _| \__ \ _| >  < 
 |_|  |_|\_,_/__/_\__| |___/_| /_/\_\
     
*/

// LIBRARIES

// Music/SFX Globals
import ddf.minim.*;
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

void musicManager(String song) {
  // Handles and plays game music
  
  stopAllSongs(); //prevent song overlap, ensure any currently playing song is first stopped
  
  switch (song) {
    case "none":
      // Stop any song that is currently playing
      break;
    case "title":
      // Play title theme
      try {
        musicArray[0].loop();
        playingIndex = 0;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "epic":
      try {
        musicArray[1].setGain(-5);
        musicArray[1].loop();
        playingIndex = 1;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "thrust":
      try {
       musicArray[2].setGain(-5);
       musicArray[2].loop();
       playingIndex = 2;
     }
     catch (NullPointerException e) {
       println("Song not yet loaded..");
     }
     break;
  }
}

void stopAllSongs() {
  // Stops music tracks from playing
  
  for (int i = 0; i < musicArray.length; i++) {
    try {
      if (musicArray[i].isPlaying()) {
        musicArray[i].pause();  
      }
    }
    catch (NullPointerException e) {
      //We can catch a NullPointerException here since it will only occur for an unloaded async sound file
    }
  }
}

void shieldCriticalSoundSequence() {
  //Only call this function asynchronously
  soundArray[6].setGain(-5);
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[7].rewind();
  soundArray[7].play();
}

void attentionLifeformSoundSequence() {
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[6].rewind();
  soundArray[6].play();
  delay(1000);
  soundArray[8].rewind();
  soundArray[8].play();
}


/*

   ___         _           _    
  / __|___ _ _| |_ _ _ ___| |___
 | (__/ _ \ ' \  _| '_/ _ \ (_-<
  \___\___/_||_\__|_| \___/_/__/
                             
*/


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
    // render thruster
  }
  if (key == ' ') {
    createBullet();
    gunReloaded = false;
  }
  
  //Change weapon
  if (key == '1') {
    changeWeapon(1);
    shipImageIndex = 0;
  }
  if (key == '2') {
    changeWeapon(2);
    shipImageIndex = 1;
  }
  if (key == '3') {
    changeWeapon(3);
    shipImageIndex = 2;
  }
  
  if (key == 'p') {
    if (!gameStarted) {
      gameStarted = true;
      // note: replace this with mouse interaction with button
      while (!preloadingFinished) //wait for preloading to finish before starting game
        delay(100);
      currentScreen = "game";
      musicManager("none");
      generateStars();
      thread("levelSequence");
    }
  }

  // debug keys
  if (key == 'c' && debug) {
    createAsteroid(0, 0, "large");
  }
  if (key == 'n' && debug) { //temp for testing songs, delete in production
    if (playingIndex == 0)
      musicManager("thrust");
    else if (playingIndex == 1)
      musicManager("thrust");
    else if (playingIndex == 2)
      musicManager("epic");
  }
  if (key == 'b' && debug) { //temp, cycle and equip through diff shields, weapons. Normally this should only be possible at level up screen
    if (shieldIndex == 1)
      changeShield(2);
    else if (shieldIndex == 2 && thrusterIndex == 1)
      changeThruster(2);
    else
      {
        changeShield(1);
        changeThruster(1);
      }
  }
  if (key == 'y' && debug) { //temp, delete after upgrade screen implemented
    continueLevel = true;
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
    accelerate = false;
  }
  if (key == ' ') {
    gunReloaded = true;
  }
}
