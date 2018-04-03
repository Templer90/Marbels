class StateMap {

  private HashMap<String, State> states;
  private ArrayList<State> onlyStates;
  

  StateMap(int i) {
    states = new HashMap(i);
    onlyStates=new ArrayList<State>(i);
  }

  void insert(State s) {
    if (!states.containsKey(s.marbels)) {
      states.put(s.marbels, s);
      onlyStates.add(s);
    }
  }

  void insert(String ds) {
    State s=new State(ds);
    this.insert(s);
  }

  State get(String ds) {
    State s=states.get(ds);
    if (s!=null) {
      return s;
    } else {
      return states.get(genHashCode(ds));
    }
  }

  State get(State s) {
    return states.get(s.marbels);
  }

  boolean contains(State s) {
    return states.containsKey(s.marbels);
  }
  boolean contains(String ds) {
    return this.contains(genHashCode(ds));
  }

  State[] getAll() {
    return onlyStates.toArray(new State[onlyStates.size()]);
  }
}
