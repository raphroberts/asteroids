// WEAPONS
int weaponIndex = 1; //0 = single pulse laser
int shieldIndex = 1;
int thrusterIndex = 1;

int weaponCooldown = -1; //must wait this # of frames per shot 
int weaponCooldownTick = 0; //current ticket of cooldown
String shieldName = "Basic";
String thrusterName = "Standard";

PImage[] iconsUI = new PImage[10];
int weaponUIdist = 45;
color weaponFill = color(255,94,144,80);
color weaponBlankFill = color(255, 255, 255, 50);
