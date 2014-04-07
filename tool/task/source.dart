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
part of hop_runner;

const String ENV_DART = '#!/usr/bin/env dart';

Task addHeaderTask () {
  ArgParser parser = new ArgParser();
  parser.addOption('author', abbr: 'a', help: 'Author', allowMultiple: false);
  parser.addOption('description', abbr: 'd', defaultsTo: '', help: 'Description', 
      allowMultiple: false);
  parser.addOption('email', abbr: 'e', defaultsTo: '', help: 'Email', 
      allowMultiple: false);
  parser.addOption('header', abbr: 'h', help: 'Header', allowMultiple: false);
  parser.addOption('year', abbr: 'y', help: 'Year', allowMultiple: false);
  return new Task ((TaskContext ctx) {
    ArgResults results = ctx.arguments;
    String author = results['author'];
    if (null == author) {
      print('"author" is required');
      return;
    }
    String description = results['description'];
    String email = results['email'];
    String header = results['header'];
    if (null == header) {
      print('"header" is required');
      return;
    }
    String y = results['year'];
    int year;
    if (null == y) {
      year = -1;
    } else {
      year = int.parse(y, radix: 10, onError: (value) => -1);
    }
    if (-1 == year) {
      print('Invalid "year"');
      return;
    }
    switch (FileSystemEntity.typeSync(header, followLinks: false)) {
      case FileSystemEntityType.FILE:
        header = new File(header).readAsStringSync();
        break;
    }
    //Replacing author, description and year placeholders
    header = header.replaceFirst('\$description\n', null == description ? ''
      : description).replaceFirst(r'$author', author)
      .replaceFirst(r'$email', email).replaceFirst(r'$year', year.toString());
    StringBuffer buf = new StringBuffer('/**\n');
    header.split('\n').forEach((line) {
      buf.write(' * $line\n');
    });
    header = '${buf.toString()} */';
    results.rest.forEach((f) {
      StringBuffer buf;
      File file = new File(f);
      String content = file.readAsStringSync();
      if (content.startsWith(ENV_DART)) {
        String line = '$ENV_DART\n';
        buf = new StringBuffer(line);
        content = content.substring(line.length);
      } else {
        buf = new StringBuffer();
      }
      if (!content.startsWith(header)) {
        buf.write('$header\n');
      }
      buf.write(content);
      file.writeAsStringSync(buf.toString(), mode: FileMode.WRITE);
    });
  }, argParser: parser, description: 'Adds header to files');
}

Task formatTask () {
  ArgParser parser = new ArgParser();
  parser.addOption('file', abbr: 'f', help: 'File to format', allowMultiple: false);
  parser.addOption('limit', abbr: 'l', help: 'Max length of line', defaultsTo: '80', allowMultiple: false);
  return new Task ((TaskContext ctx) {
    ArgResults results = ctx.arguments;
    String f = results['file'];
    File file;
    if (null == f){
      print('"file" option is required');
      return;
    } else {
      switch(FileSystemEntity.typeSync(f, followLinks: false)) {
        case FileSystemEntityType.DIRECTORY:
          print ('"file" is a directory. Nothing to do.');
          return;break;
        case FileSystemEntityType.FILE:
          file = new File(f);
          break;
        case FileSystemEntityType.LINK:
          print ('"file" is a link. Nothing to do.');
          return;break;
        case FileSystemEntityType.NOT_FOUND:
          print ('"file" not found. Nothing to do.');
          return;break;
      }
    }
    String l = results['limit'];
    int limit = int.parse(l, radix: 10, onError: (value) => -1);
    if (-1 == limit) {
      print('"limit" must be a valid integer');
      return;
    }
    file.writeAsStringSync(format(file.readAsStringSync(), limit), mode: FileMode.WRITE);
  }, argParser: parser, description: 'Formats sources');
}