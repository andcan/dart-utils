#!/usr/bin/env dart

import '../lib/utils/utils.dart' as u;
import 'dart:io';
import 'package:args/args.dart';

const String FORMAT = 'format';

void main (List<String> args) {
  //Main parser
  ArgParser parser = new ArgParser();
  //Format command parser
  ArgParser format = parser.addCommand(FORMAT);
  format.addOption('file', abbr: 'f', help: 'File to format', allowMultiple: false);
  format.addOption('limit', abbr: 'l', help: 'Max length of line', defaultsTo: '80', allowMultiple: false);
  
  //Getting results
  ArgResults results = parser.parse(args, allowTrailingOptions: true);
  ArgResults cmd = results.command;
  if (null == cmd) {
    var buf = new StringBuffer ('Available commands:\n');
    parser.commands.keys.forEach((name) {
      buf.write('  $name');
    });
    print (buf.toString());
    return;
  }
  switch (results.command.name) {
    case FORMAT:
      String f = cmd['file'];
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
      String l = cmd['limit'];
      int limit = int.parse(l, radix: 10, onError: (value) => -1);
      if (-1 == limit) {
        print('"limit" must be a valid integer');
        return;
      }
      file.writeAsStringSync(u.format(file.readAsStringSync(), limit), mode: FileMode.WRITE);
      break;
    default:
      print ('Invalid command.');
      break;
  }
}