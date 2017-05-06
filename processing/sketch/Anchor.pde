import processing.serial.*;

class Anchor extends PVector {

  boolean real;
  
  String name;
  ArrayList<Message> history = new ArrayList<Message>();
  
  Serial port;

  Anchor(boolean real_, float x_, float y_, float z_, String name_, Serial port_) {
    real = real_;
    x = x_;
    y = y_;
    z = z_;
    name = name_;
    port = port_;
    
    get_distance();
  }
  
  float d() {
    if (history.size() == 0) { return -1; }
    return history.get(history.size() - 1).distance;
  }
  
  void plot() {    
    stroke(rgb_scale_x(x), rgb_scale_y(y), rgb_scale_z(z));
    strokeWeight(15);
    point(scale_x(x), scale_y(y), scale_z(z)); 
    
    pushMatrix();
    translate(scale_x(x), scale_y(y), scale_z(z));

    if (showYEllipse) {
      strokeWeight(10);
      ellipse(x, y, scale_x(d()) * 2, scale_x(d()) * 2);
    }
    
    strokeWeight(1);
    
    if (showXEllipse) {
      pushMatrix();
      rotateX(PI / 2);
      ellipse(x, y, scale_x(d()) * 2, scale_x(d()) * 2);
      popMatrix();
    }
    
    if (showZEllipse) {
      pushMatrix();
      rotateY(PI / 2);
      ellipse(x, y, scale_x(d()) * 2, scale_x(d()) * 2);
      popMatrix();
    }

    popMatrix();
  }
  
  void plot_distance() {
    if (history.size() == 0) return;
    Message m = history.get(history.size() - 1);
  
    stroke(rgb_scale_x(x), rgb_scale_y(y), rgb_scale_z(z));
   
    strokeWeight(15);
    point(scale_x(x), scale_y(y + m.distance), scale_z(z));
    
    strokeWeight(2);
    line(scale_x(x), scale_x(y), scale_z(z), scale_x(x), scale_y(y + m.distance), scale_z(z)); 
  }
  
  float get_distance() {
    Message m = null;
    if (real) {
      if (0 >= port.available()) return -1;
      m = read_message();
    } else {
      m = read_fake_message();
    }
      
    if (m.distance > 0) {
      history.add(m);
      if (history.size() > 100) {
        history.remove(0);
      }
    }
    
     //println(name, "distance:", m.distance);
    
    return m.distance;
  }
  
  Message read_message() {
    String raw = port.readString();
    if (raw == null) raw = "|-1|"; // have a default ready to go
    else print(raw);
    return new Message(raw);
  }
  
  Message read_fake_message() {
    float offset = 0.35;
    Float n = noise(frameCount * 0.002 + name.length()) * 2 + offset;
    return new Message("|" + n + "|");
  }
}