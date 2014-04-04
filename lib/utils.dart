library utils;

import 'dart:async';
import 'dart:io';

void format (File file, [int limit = 80, String delimiter = '\n']) {
  file.readAsString().then((content) {
    //Creating buffer to hold content
    StringBuffer buf = new StringBuffer();
    //Splitting by
    content.split(delimiter).forEach((line) {
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
        //writing remaining runes
        buf.write('$line\n');
      }
    });
    file.writeAsStringSync(buf.toString(), mode: FileMode.WRITE);
  });
}