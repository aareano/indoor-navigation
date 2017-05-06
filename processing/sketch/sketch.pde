import processing.opengl.*;
import processing.serial.*;
  
//
// Data simulation vars
//
ArrayList<Anchor> anchors = new ArrayList<Anchor>();
 
//
// Plotting vars
//

// pixels
int DIM_X = 600;
int DIM_Y = 600;
int DIM_Z = 600;

// meters
int MAX_X = 2;
int MAX_Y = 2;
int MAX_Z = 2;

// movement in feet
float STEP_X = 0.1;
float STEP_Y = 0.1;
float STEP_Z = 0.1;

boolean rotateX = false;
boolean rotateY = false;
boolean rotateZ = false;

int lastFrameX = 0;
int lastFrameY = 0;
int lastFrameZ = 0;

boolean showXEllipse = false;
boolean showYEllipse = false;
boolean showZEllipse = false;

PFont f;

//
// Serial vars
//

void setup() {
  size(800, 800, P3D);
  
  f = createFont("Arial", 74, true);
  
  // serial

  // comment the following to use data from the serial port
  Serial port = null;

  // uncomment the following to use data from the serial port
  //Serial port = new Serial(this, Serial.list()[Serial.list().length - 1], 115200);
  //println("Using port:", Serial.list()[Serial.list().length - 1]);

  anchors.add(new Anchor(false, 1, 0.3, 1.7, "Green", null));           // simulated anchor
  anchors.add(new Anchor(false, MAX_X / 2.0, 1.1, 0.2, "Red", null));   // simulated anchor
  anchors.add(new Anchor(false, 1.8, MAX_Y/2, MAX_Z/2, "Pink", port));  // either simulated or serial anchor
}
 
void draw() {
  background(0);
  translate(width/2, height/2);

  scale(1, -1, 1); // so Y is up, which makes more sense in plotting
  
  rotate_box();

  noFill();
  strokeWeight(1);
  stroke(255, 255, 255);
  box(DIM_X, DIM_Y, DIM_Z);

  translate(-DIM_X/2, -DIM_Y/2, -DIM_Y/2);
  
  print_axes();

  get_distances();
  plot_anchors();
  plot_location();
}

void get_distances() {
  for (int i = 0; i < anchors.size(); i++) {
    anchors.get(i).get_distance();
  }
}

void plot_anchors() {
  for (int i = 0; i < anchors.size(); i++) {
    anchors.get(i).plot();
  }
}

void plot_location() {
  for (int i = 0; i < anchors.size(); i++) {
      anchors.get(i).plot_distance();
  }
  
  // triangulate distance from anchors

  Anchor a1 = anchors.get(0);
  Anchor a2 = anchors.get(1);
  Anchor a3 = anchors.get(2);

  // put a1 at the origin
  pushMatrix();
  translate(scale_x(a1.x), scale_y(a1.y), scale_z(a1.z));
  
  strokeWeight(15);

  // this algorithm doesn't work. I don't know how to fix it.
  // the issues that arise are dealt with on line 123.

  float d = hypotenuse(a2); // distance from a1 to a2
  float x = (sq(a1.d()) - sq(a2.d()) + sq(d)) / (2 * d);
  float y = ((sq(a1.d()) - sq(a3.d()) + sq(a3.x) + sq(a3.y)) / (2 * a3.x)) - ((a3.x / a3.y) * x);
  float z = sqrt(sq(a1.d()) - sq(x) - sq(y)) * -1; // -1 because the plotting matrix is flipped
  if (Float.isNaN(z)) { z = 0; }

  stroke(255);
  strokeWeight(15);
  point(scale_x(x), scale_y(y), scale_z(z));
  
  stroke(155);
  strokeWeight(2);
  line(scale_x(a1.x - a1.x), scale_x(a1.y - a1.y), scale_z(a1.z - a1.z), scale_x(x), scale_y(y), scale_z(z));
  line(scale_x(a2.x - a1.x), scale_x(a2.y - a1.y), scale_z(a2.z - a1.z), scale_x(x), scale_y(y), scale_z(z));
  line(scale_x(a3.x - a1.x), scale_x(a3.y - a1.y), scale_z(a3.z - a1.z), scale_x(x), scale_y(y), scale_z(z));
  
  popMatrix();
}

float hypotenuse(Anchor a) {
  float s_sq = sq(0 - a.x) + sq(0 - a.y) + sq(0 - a.z);
  return sqrt(s_sq);
}

void print_axes() {
  textFont(f, 64);
  
  strokeWeight(5);
  stroke(250, 25, 216);
  line(0, 0, 0, scale_x(MAX_X / 3.0), 0, 0);
  text("X", scale_x(MAX_X / 3.0), 25);
  
  line(0, 0, 0, 0, scale_y(MAX_Y / 3.0), 0);
  pushMatrix();
  rotateX(radians(180));
  text("Y", -20, -scale_y(MAX_Y / 3.0) - 10);
  popMatrix();
  
  pushMatrix();
  rotateX(radians(90));
  line(0, 0, 0, 0, scale_y(MAX_Y / 3.0), 0);
  popMatrix();
}

float scale_x(float x) {
  return map(x, 0, MAX_X, 0, DIM_X);
}

float scale_y(float y) {
  return map(y, 0, MAX_Y, 0, DIM_Y);
}

float scale_z(float z) {
  return map(z, 0, MAX_Z, 0, DIM_Z);
}

float rgb_scale_x(float x) {
  return map(x, 0, MAX_X, 0, 255);
}

float rgb_scale_y(float y) {
  return map(y, 0, MAX_Y, 0, 255);
}

float rgb_scale_z(float z) {
  return map(z, 0, MAX_Z, 0, 255);
}

void rotate_box() {
  if (rotateX) lastFrameX++;
  if (rotateY) lastFrameY++;
  if (rotateZ) lastFrameZ++;
  rotateX(radians(lastFrameX));
  rotateY(radians(lastFrameY));
  rotateZ(radians(lastFrameZ));

}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      rotateX = true;
    } else if (keyCode == RIGHT) {
      rotateZ = true;
    } else if (keyCode == LEFT) {
      rotateY = true;
    }
  } else {
    if (key == 'x') {
      showXEllipse = !showXEllipse;
    } else if (key == 'y') {
      showYEllipse = !showYEllipse;
    } else if (key == 'z') {
      showZEllipse = !showZEllipse;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP || keyCode == RIGHT || keyCode == LEFT) {
      rotateY = false;
      rotateX = false;
      rotateZ = false;
    }
  }
}

//void mousePressed() {
//  if (mouseX > height - (height * 0.33)) {
//    rotateY = true;
//  } else if (mouseX > height - (height * 0.66)) {
//    rotateX = true;
//  } else {
//    rotateZ = true;
//  }
//}

//void mouseReleased() {
//  rotateY = false;
//  rotateX = false;
//  rotateZ = false;
//}