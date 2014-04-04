library utils;

String format (String s, [int limit = 80, String delimiter = '\n']) {
  //Creating buffer to hold content
  StringBuffer buf = new StringBuffer();
  //Splitting by delimiter
  s.split(delimiter).forEach((line) {
    //Removing unnecessary spaces
    line = line.trim();
    if (line.length < limit) {
      //Nothing to do
      buf.write('$line\n');
    } else {
      do {//splitting
        String tmp = line.substring(0, limit);
        int end = tmp.lastIndexOf(' ');
        tmp = line.substring(0, end);
        buf.write('$tmp\n');
        line = line.substring(end).trim();
      } while(line.length > limit);
      //writing remaining
      buf.write('$line\n');
    }
  });
  return buf.toString();
}