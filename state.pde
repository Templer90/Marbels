import java.util.*; //<>// //<>// //<>// //<>// //<>// //<>//
public class State {
  float V_MAX=3.0;
  float SPRING_DISTANCE=50;


  String orginal="";
  String marbels="";
  int hash=0;

  HashSet<State> neighbours;

  PVector pos=new PVector(1, 1);
  PVector vel=new PVector(0, 0);
  boolean movable=true;
  boolean marked=false;
  boolean prevPressed=false;
  boolean active=false;

  State(String s) {
    pos=new PVector(random(width), random(height));
    vel=new PVector(0.0f, 0.0f);
    marbels=s;
    orginal=s;

    marbels=genHashCode(marbels);
    hash = marbels.hashCode();
    neighbours=new HashSet<State>();
  }

  State(String s, float x, float y) {
    pos=new PVector(x, y);
    movable=false;
    vel=new PVector(0.0f, 0.0f);
    marbels=s;
    orginal=s;

    marbels=genHashCode(marbels);
    hash = marbels.hashCode();

    neighbours=new HashSet<State>();
  }

  String toString() {
    return "State@"+marbels;
  }

  boolean neighbour(State s) {
    return neighbours.contains(s);
  }

  void addNeighbour(State s) {
    if ((hashCode()!=s.hashCode())) {
      neighbours.add(s);
    }
  }

  public int hashCode() {
    return hash;
  }

  public boolean overCircle() {
    float disX = pos.x - mouseX;
    float disY = pos.y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < 10/2 ) {
      return true;
    } else {
      return false;
    }
  }

  void mark() {
    marked=true;
  }

  void displayInfo() {
    for (State s : neighbours) {
      s.mark();
    }

    float h=20;  
    if (pos.x+(1+marbels.length())*10>width) {
      h=-(1+marbels.length())*10;
    }
    pushMatrix();
    translate(h, 20);
    fill(0);
    stroke(0);
    rect(pos.x-5, pos.y-5, 50+(1+marbels.length())*10, 50);

    drawMarbles(this.marbels, pos.x, pos.y);

    fill(255);
    text(marbels, pos.x+5, pos.y+20);
    text(hash, pos.x+5, pos.y+30);

    stroke(255);
    strokeWeight(0.8);


    popMatrix();
  } 

  void attract( State[] all) {
    if (active)return;

    float attr=0;
    if (mouseMode) {
      attr=(mouseX-width/2);
    }else {
      attr=50;
    }
    PVector acc=new PVector(0, 0);
    for (int i=0; i<all.length; i++) {
      State s = all[i];
      if (neighbours.contains(s)||(hashCode()==s.hashCode())) {
        continue;
      }
      acc=PVector.sub(s.pos, pos);
      float distance=acc.mag();
      if (distance<1) {
        s.pos.add(PVector.random2D());
        pos.add(PVector.random2D());

        acc=PVector.sub(s.pos, pos);
        distance=acc.mag();
      }


      acc.mult(attr/(distance*distance));
      vel.sub(acc);
    }

    if (mouseMode) {
      attr=(mouseY)/10.0f;
    } else {
      attr=5;
    }
    for (State s : neighbours) {
      if ((hashCode()==s.hashCode())) {
        println("WHAT");
        continue;
      }
      acc=PVector.sub(s.pos, pos);

      float d=(acc.mag()-attr);///acc.mag();
      if (abs(d)>0.01f) {
        acc.mult((1.1-(acc.mag()/d)));
        vel.add(acc);
      }
    }


    if (vel.mag()<0.1) {
      vel.setMag(0);
    }

    if (movable) {
      pos.add(vel);
    }
    pos.x=constrain(pos.x, 0, width);
    pos.y=constrain(pos.y, 0, height);
  }


  void draw() {
    if (movable) {
      pos.add(vel);

      fill(255);
    } else {
      fill(255, 255, 0);
    }

    if (overCircle()&&mousePressed&&prevPressed==false) {
      active=true;
      movable=!movable;
    }
    if (mousePressed==false&&prevPressed) {
      active=false;
    }

    prevPressed=mousePressed;

    if (active) {
      noFill();
      stroke(255);
      strokeWeight(1);
      ellipse(pos.x, pos.y, 20, 20);

      pos.x=constrain(mouseX, 0, width);
      pos.y=constrain(mouseY, 0, height);
    }

    stroke(255);
    strokeWeight(1);
    ellipse(pos.x, pos.y, marked?12:10, marked?12:10);
    marked=false;
  }
}


void drawMarbles(String m, float posx, float posy) {
  fill(0);
  stroke(255);
  strokeWeight(0.8);
  for (int i=0; i<m.length(); i++) {
    if (m.charAt(i)=='0') {
      fill(0);
    } else if (m.charAt(i)=='1') {
      fill(255, 0, 0);
    } else if (m.charAt(i)=='2') {
      fill(0, 0, 255);
    } else {
      print(m.charAt(i));
      fill(255, 255, 0);
    }
    ellipse(posx+ 1+10*i, posy, 10, 10);
  }
}

String genHashCode(String m) {
  int s=0;
  int e=0;

  for (int i=0; i<m.length(); i++) {
    if (m.charAt(i)!='0') {
      s=i;
      break;
    }
  }
  for (int i=m.length()-1; i>0; i--) {
    if (m.charAt(i)!='0') {
      e=i;
      break;
    }
  }

  String ret=m.substring(s, e+1);
  int code=ret.hashCode();

  if (MIRRORING) {
    String r="";
    String p="";
    for (int i=ret.length()-1; i>=0; i--) {
      r+=ret.charAt(i);
      p+=ret.charAt(ret.length()-i-1);
    }
    if (ret.equals(p)) {
      if (r.hashCode()<code) {
        return r;
      }
    }
  }
  return ret;
}
