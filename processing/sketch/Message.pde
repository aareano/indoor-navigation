class Message {

  String raw;
  float distance;
  
  Message(String raw_) {
    raw = raw_;
    distance = extract_distance(raw_);
  }
  
  float extract_distance(String raw) {
    String[] m = match(raw, "[|][-+]?([0-9]*[\\.][0-9]+|[0-9]+)[|]");
    if (m == null) return -1;
    return Float.parseFloat(m[1]);
  }
}