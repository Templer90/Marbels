import java.util.*;
class Pathfinder {
  private class entry implements Comparable {
    int dist=0;
    State state;

    entry(int d, State s) {
      dist=d;
      state=s;
    }

    int compareTo(Object o) {
      if (o instanceof entry) {
        return this.dist-((entry)o).dist;
      } else {
        return -1;
      }
    }
  }

  private StateMap map;
  private HashMap<State, State> path;
  private HashMap<State, State> prev;

  private State prev_start; 
  private State prev_end;


  Pathfinder(StateMap m) {
    map=m;
  }

  void find(State start, State end) {
    State u;

    //Same start as before? If Not: rebuild Mesh
    if (!start.equals(prev_start)) {
      prev=new HashMap<State, State>();
      HashMap<State, Integer> dist=new HashMap<State, Integer>();
      PriorityQueue<entry> Q=new PriorityQueue<entry>();

      for (State s : map.getAll()) {
        if (s.equals(start))continue;
        Q.add(new entry(1000, s));
        dist.put(s, 1000);
      }

      dist.put(start, 0);
      Q.add(new entry(0, start));

      entry e;
      while (Q.size()>0) {
        e=Q.poll();
        u=e.state;

        for (State v : u.neighbours) {
          int alt=dist.get(u)+1;
          if (alt<dist.get(v)) {
            dist.put(v, alt);
            Q.offer(new entry(alt, v));
            prev.put(v, u);
          }
        }
      }
    }
    prev_start=start; 
    
    //Same END as before? If Yes: Nothing to do
    if (end.equals(prev_end)) {
      return;
    }
    prev_end=end;

    //reconstruct
    ArrayList<State> S=new ArrayList<State>();
    u=end;
    while (prev.get(u)!=null) {                  
      S.add(u);      
      u=prev.get(u);
    }                          
    S.add(u);

    path=new HashMap<State, State>();
    State[]reversed=S.toArray(new State[0]);
    if (reversed.length==0)return;

    for (int i=reversed.length-1; i>=1; i--) {
      path.put(reversed[i], reversed[i-1]);
    }
  }


  boolean inPath(State a, State b) {
    State k=path.get(a);
    if (k==null)return false;
    return(path.containsKey(a)&&path.get(a).hashCode()==b.hashCode());
  }
  
  HashMap<State, State> getPath(){
    return path;
  }
}
