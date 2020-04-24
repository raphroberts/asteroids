// FUNCTIONS AND GLOBALS THAT RELATE TO THE TITLE SCREEN

// Title screen ship graphic
PImage[] titleShip = new PImage[2];

// Location of title screen ship
int titleShipX;
float titleShipY;

// Speed of title screen ship
float titleShipSpeed = 0.3;

// Padding for title screen ship screen overlap
int titleShipPadding = 140;

// Ship shrink factor when it loops around
final int titleShipShrink = 100;
// Thruster animation on title ship
int thrusterCount = 0;


void titleSetup() {
  // set up title screen values
  
  titleShipX = width / 2;
  titleShipY = height + titleShipPadding;
  
  titleShip[0] = loadImage("images/title_screen_ship.png");
  titleShip[1] = loadImage("images/title_screen_ship_thruster.png");
  
  // initialise starfield
  generateStars();
    
}

void titleScreen() {
  // Display and handle title screen

  // Render background
  background(backgroundImage[0]);

  // Render stars
  renderStars();

  // Render ship
  image(titleShip[0], titleShipX, titleShipY);
  if (thrusterCount < 5){
    image(titleShip[1], titleShipX, titleShipY);
  }
  else if (thrusterCount > 10){
    thrusterCount = 0;
  }
  thrusterCount ++;
  
  titleShipY -= titleShipSpeed;
  
  if (titleShipY < 0 - titleShipPadding){
    titleShipY = height + titleShipPadding;
    titleShipX = randomInt(0, width);
    titleShip[0].resize(titleShipShrink, 0);
    titleShip[1].resize(titleShipShrink, 0);
  } 


}
