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
    if (debug && frameCount % 3 > 1 && !levelComplete){
      gunReloaded = true;
      if (shieldHP < 50){
        shieldHP = 500;
      }
      createBullet();
    }

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
  soundArray[9] = minim.loadFile("sounds/eliminated.mp3");
  preloadingFinished = true;
 
  // Create array of music tracks
  musicArray[1] = minim.loadFile("music/s2.mp3");
  musicArray[2] = minim.loadFile("music/ThrustSequence.mp3");
  musicArray[3] = minim.loadFile("music/victorytheme.mp3");
  musicArray[4] = minim.loadFile("music/upgradeTheme.mp3");
  musicArray[5] = minim.loadFile("music/level1.mp3");
  musicArray[6] = minim.loadFile("music/trueepic.mp3");
  musicArray[7] = minim.loadFile("music/modulo4.mp3");
  musicArray[8] = minim.loadFile("music/boss1.mp3");
  musicArray[9] = minim.loadFile("music/boss2.mp3");
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

void fadeInSongCoroutine(String startSongString) { //WARNING: START ONLY VIA a thread() method
  //fade out current song, then fade in the given song.
  //Must be started as a coroutine/async only
  musicArray[playingIndex].shiftGain(musicArray[playingIndex].getGain(),-80, 5000);
  delay(2500);
  musicManager("none");
  musicManager(startSongString);
}

void musicManager(String song) {
  // Handles and plays game music
  
  stopAllSongs(); //prevent song overlap, ensure any currently playing song is first stopped
  
  //fade out, fade in, switch (cross over) ?
  
  switch (song) {
    case "none":
      // Stop any song that is currently playing
      if (musicArray[playingIndex].isPlaying()) {
        musicArray[playingIndex].pause();
      }
      break;
    case "title":
      // Play title theme
      try {
        musicArray[0].rewind();
        musicArray[0].loop();
        playingIndex = 0;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "epic":
      try {
        musicArray[1].rewind();
        musicArray[1].loop();
        musicArray[1].shiftGain(-50,-5, 5000);
        playingIndex = 1;
      }
      catch (NullPointerException e) {
        println("Song not yet loaded..");
      }
      break;
    case "thrust":
      try {
       musicArray[2].rewind(); 
       musicArray[2].loop();
       musicArray[2].shiftGain(-50,-10, 5000);
       playingIndex = 2;
     }
     catch (NullPointerException e) {
       println("Song not yet loaded..");
     }
     break;
     case "victory":
       try {
         musicArray[3].rewind();
         musicArray[3].loop();
         musicArray[3].shiftGain(-50,-10, 5000);
         playingIndex = 3;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
    case "upgrade":
     try {
         musicArray[4].rewind();
         musicArray[4].loop();
         musicArray[4].shiftGain(-50,-10, 5000);
         playingIndex = 4;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
   case "level1":
     try {
         musicArray[5].rewind();
         musicArray[5].play();
         musicArray[5].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 5;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
  case "trueepic": 
     try {
         musicArray[6].rewind();
         musicArray[6].loop();
         musicArray[6].shiftGain(-50, -10, 5000); //out gain is -50, in gain is -1
         playingIndex = 6;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
   case "modulo4": 
     try {
         musicArray[7].rewind();
         musicArray[7].loop();
         musicArray[7].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 7;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
    case "boss1": 
     try {
         musicArray[8].rewind();
         musicArray[8].loop();
         musicArray[8].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 8;
       }
       catch (NullPointerException e) {
         println("Song not yet loaded..");
       } 
     break;
     case "boss2": //short teaser song for level 1
     try {
         musicArray[9].rewind();
         musicArray[9].loop();
         musicArray[9].shiftGain(-50, -3, 5000); //out gain is -50, in gain is -1
         playingIndex = 9;
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
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
  soundArray[6].play();
  delay(1000);
  soundArray[7].rewind();
  soundArray[7].play();
}

void attentionLifeformSoundSequence() {
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
  soundArray[6].play();
  delay(1000);
  soundArray[6].rewind();
  soundArray[6].setGain(-5);
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
