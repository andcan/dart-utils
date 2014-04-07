/**
 * Copyright (C) 2014  Andrea Cantafio kk4r.1m@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
library utils;

part 'utils/is.dart';
part 'utils/license.dart';
part 'utils/optional.dart';

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
/**
 * Value used from [hashCode] function
 */
const int PRIME = 31;

/**
 * Default hashCode implementation
 */
int hashCode (List values) {
  int hash = 1;
  values.forEach((value) {
    hash = PRIME * hash + value.hashCode;
  });
  return hash;
}