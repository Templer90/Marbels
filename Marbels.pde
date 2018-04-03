import java.util.*;  //<>// //<>//

StateMap states;
Pathfinder pathfinder;

String ALPHABET="012";
int RED_MARBELS=2;
int BLUE_MARBELS=3;
int NUM_MARBLES=RED_MARBELS+BLUE_MARBELS;

String START="21212";
String END="22211";
boolean MIRRORING=false;




boolean untagle=true;
boolean mouseMode=false;
boolean setup5=true;

void setUp5() {
  START="21212";
  END="22211";

  RED_MARBELS=2;
  BLUE_MARBELS=3;
  NUM_MARBLES=RED_MARBELS+BLUE_MARBELS;

  float w=100;
  float h=100;
  states = new StateMap(100); 
  states.insert(new State(START, w/2, height/2));
  states.insert(new State(END, width-w, height/2-25));
  states.insert(new State("11222", width-w, height/2+25));
  states.insert(new State("22112", width/2, h));
  states.insert(new State("21122", width/2, height-h ));
}

void setUp6() {
  START="212121";
  END="222111";

  RED_MARBELS=3;
  BLUE_MARBELS=3;
  NUM_MARBLES=RED_MARBELS+BLUE_MARBELS;

  float w=100;
  float h=100;
  states = new StateMap(100); 
  states.insert(new State(START, w/2, height/2));
  states.insert(new State(END, width-w, height/2-25));
  states.insert(new State("111222", width-w, height/2+25));
  states.insert(new State("2220111", width/2, h));
  states.insert(new State("1110222", width/2, height-h ));
}

void setup() {
  background(0);
  size(800, 700);

  if (setup5) {
    setUp5();
  } else {
    setUp6();
  }

  permutation(new char[(NUM_MARBLES+4)], 0, ALPHABET);
  neighburs();

  pathfinder=new Pathfinder(states);

  pathfinder.find(states.get(START), states.get(END));
}



void keyPressed() {
  if (key==' ') {
    untagle=!untagle;
  }

  if (key=='n') {
    setup5=!setup5;
    setup();
  }
  if (key=='m') {
    MIRRORING=!MIRRORING;
    setup();
  }
    if (key=='j') {
    mouseMode=!mouseMode;
  }
}

void checkAndInsert(String a, State s) {
  if (check(a)) {
    State p = states.get(a);
    s.addNeighbour(p);
  }
}

void neighburs() {
  String n;
  String a="";
  String b="";
  String c="";
  String d="";
  for (State s : states.states.values() ) {
    n = s.marbels;

    //Split Off
    for (int i=0; i<n.length(); i++) {
      a=insert(n, "0", i);
      checkAndInsert(a, s);
    }

    //Split and rotate
    for (int i=0; i<n.length(); i++) {
      if (n.charAt(i)=='0') {
        a=n.substring(0, i);
        b=n.substring(i+1);

        checkAndInsert(b+"0"+a, s);
      }
    }

    //Join
    for (int i=0; i<n.length(); i++) {
      if (n.charAt(i)=='0') {
        a=n.substring(0, i);
        b=n.substring(i+1);

        checkAndInsert(a+b, s);
      }
    }

    String[] split=n.split("0");
    for (int i=0; i<split.length; i++) {
      if (split[i].length()>2) {
        c=split[i].substring(0, 2);
        d=split[i].substring(2);
        checkAndInsert(glue(i, split, d+c), s);
        checkAndInsert(glue(i, split, d+"0"+c), s);


        c=split[i].substring(split[i].length()-2);
        d=split[i].substring(0, split[i].length()-2);
        checkAndInsert(glue(i, split, c+d), s);
        checkAndInsert(glue(i, split, c+"0"+d), s);
      }
    }
  }
}

String glue(int l, String[] arr, String val) {
  String s="";
  for (int i=0; i<l; i++) {
    s=s+arr[i]+"0";
  }
  s=s+val;
  for (int i=l+1; i<arr.length; i++) {
    s=s+"0"+arr[i];
  }

  return s;
}

String insert(String bag, String marble, int index) {
  String bagBegin = bag.substring(0, index);
  String bagEnd = bag.substring(index);
  return bagBegin + marble + bagEnd;
}

void draw() {
  fill(0);
  background(0);
  stroke(255);
  strokeWeight(1);

  State h=null;
  State[] all=states.getAll();
  
  
  for (State s : all ) {
    if (untagle) {
      s.attract(all);
      s.vel.set(0, 0);
    }

    if (s.overCircle())h=s;

    strokeWeight(1);
    int op=255;
    for (State p : s.neighbours ) {
      if (pathfinder.inPath(s, p)) {
        strokeWeight(3);
        op=255;
      } else {
        strokeWeight(1);
        op=128;
      }

      if (p.neighbour(s)) {
        stroke(255, 0, 255, op);
        line(p.pos.x, p.pos.y, s.pos.x, s.pos.y);
      } else {
        stroke(255, op);
        line(p.pos.x, p.pos.y, s.pos.x, s.pos.y);
      }
    }

    s.draw();
  }

  if (h!=null)h.displayInfo();

  pathfinder.find(states.get(START), (h!=null)?h:states.get(END));

  drawSteps(states.get(START), (h!=null)?h:states.get(END) );
}

void drawSteps(State start, State end) {
  float sx=height-(pathfinder.getPath().keySet().size()+1)*10;
  float x=sx;
  float h=10;
  int step=1;
  HashMap<State, State> path=pathfinder.getPath();

  State s = states.get(start);

  while ((s!=null)&&!s.equals(end)) {
    drawMarbles(s.marbels, 20, x );
    s=path.get(s);
    if (s!=null) {
      drawMarbles(s.marbels, 20+( NUM_MARBLES+2)*10, x );
    }

    fill(255);
    text(step++, 9, x+(h/2));
    x+=h;
  }
  if (s!=null) {
    fill(255);
    text(step, 9, x+(h/2));
    drawMarbles(s.marbels, 20, x );
  }
}


void permutation(char[] perm, int pos, String str) {
  if (pos == perm.length) {
    if (check(perm)) {
      states.insert(new String(perm) );
    }
  } else {
    for (int i = 0; i < str.length(); i++) {
      perm[pos] = str.charAt(i);
      permutation(perm, pos+1, str);
    }
  }
}

boolean check(String input) {
  return check(input.toCharArray());
}
boolean check(char[] input) {
  int e=0;
  int s=0;
  for (int i=0; i<input.length; i++) {
    if (input[i]!='0') {
      s=i;
      break;
    }
  }
  for (int i=input.length-1; i>0; i--) {
    if (input[i]!='0') {
      e=i;
      break;
    }
  }

  if (s>=e)return false;
  if ((e-s+1)<NUM_MARBLES)return false;
  if ((input[s]!='0')&&(input[s+1]=='0'))return false;
  if ((input[e]!='0')&&(input[e-1]=='0'))return false;


  int rcount=0;
  int bcount=0;
  for (int i=s; i<=e; i++) {
    if (input[i]=='1') {
      rcount++;
    }
    if (input[i]=='2') {
      bcount++;
    }
    if (i>0&&i<e) {
      if ((input[i-1]=='0')&&(input[i]!='0')&&(input[i+1]=='0')) {
        return false;
      }

      //kein 00
      if ((input[i]=='0')&&((input[i+1]=='0')||(input[i-1]=='0'))) {
        return false;
      }
    }
  }
  if (rcount!=RED_MARBELS)return false;
  if (bcount!=BLUE_MARBELS)return false;
  if (rcount+bcount!=NUM_MARBLES)return false;
  return true;
}
