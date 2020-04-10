void IPlayerShipController() {
  /*Encapsulated Function with dependency on: 
  Global Functions:
    keyPressed(), keyReleased(),
    
  Global Vars:
    keyDown, rotation, maxSpeed, accelerationThrust, location, velocity, acceleration
 */
  if (acceleration.x >= 0.001) {
    acceleration.sub(0.001, 0);
  } else if (acceleration.x <= -0.001) {
    acceleration.add(0.001, 0);
  } else {
    acceleration = new PVector(0, acceleration.y);
  }
  if (acceleration.y >= 0.001) {
    acceleration.sub(0, 0.001);
  } else if (acceleration.y <= -0.001) {
    acceleration.add(0, 0.001);
  } else {
    acceleration = new PVector(acceleration.x, 0);
  }

  if (abs(velocity.x + acceleration.x) <= maxSpeed) {
    velocity.x = velocity.x + acceleration.x;
  }
  if (abs(velocity.y + acceleration.y) <= maxSpeed) {
    velocity.y = velocity.y + acceleration.y;
  }

  location.add(velocity);
  if (location.x > width)
    location.x = 0;
  else if (location.x < 0) 
    location.x = width;
  if (location.y > height)
    location.y = 0;
  else if (location.y < 0) 
    location.y = height;

  println(velocity);

  fill(130);
  translate(location.x + rotation, location.y + rotation);
  rotate(rotation);
  square(0, 0, 20);
  stroke(190);
  line(0, 0, 10, 0);

  if (keyDown[0]) 
    rotation = rotation - 0.1;
  if (keyDown[1]) 
    rotation = rotation + 0.1;
  if (keyDown[2])
    acceleration = new PVector(accelerationThrust * cos(rotation), accelerationThrust * sin(rotation));
  if (keyDown[3])
    acceleration = new PVector(-accelerationThrust * cos(rotation), -accelerationThrust * sin(rotation));
}
