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

const String CMD_INSTALL = 'install';
const String OPTION_ENV_FILE = 'envFile';
const String OPTION_PKG = 'pkg';

final String BashProfile = '${Platform.environment['HOME']}/.bash_profile';
final String CurrentDirectory = Directory.current.absolute.path.toString();
final String CustomLauncher = '''#!/usr/bin/env dart
import 'dart:io';

void main (List<String> args) {
  ProcessResult result = Process.runSync('tool/hop_runner.dart', args, 
    workingDirectory: '$CurrentDirectory');
  print(result.stdout is String ? result.stdout : result.stderr);
}
''';
final String DefaultPackageName = path.basename(CurrentDirectory);

final Function fatal = (Error e) {
  print(e);
  exit(-1);
};
final Function pkgInstallation = (String pkgName) => '#$pkgName installation';


Task installTask () {
  ArgParser parser = new ArgParser();
  parser.addOption(OPTION_ENV_FILE, abbr: 'e', allowMultiple: false,
        defaultsTo: BashProfile, help: 'Package Name');
  parser.addOption(OPTION_PKG, abbr: 'p', allowMultiple: false,
      defaultsTo: DefaultPackageName, help: 'Package Name');
  return new Task((TaskContext ctx) {
    ArgResults result = ctx.arguments;
    String envFile = result[OPTION_ENV_FILE];
    String pkg = result[OPTION_PKG];
    
    switch (FileSystemEntity.typeSync(envFile, followLinks: false)) {
      case FileSystemEntityType.FILE:
        File env = new File (envFile);
        String cmd = 'export PATH=\$PATH:$CurrentDirectory/tool';
        String content = env.readAsStringSync();
        String pkgInst = pkgInstallation(pkg);
        int pos = content.indexOf(pkgInst);
        if (-1 == pos) {
          content = '$content\n$pkgInst\n$cmd';
        } else {
          if (!content.contains(cmd)) {
            content = content.replaceFirst(pkgInst, '$pkgInst\n$cmd');
          }
        }
        env.writeAsStringSync(content, mode: FileMode.WRITE);
        break;
      default:
        print('Invalid or missing file $envFile');
        exit(-1);
        break;
    }
    String runner = '$CurrentDirectory/tool/${pkg}_runner';
    switch (FileSystemEntity.typeSync(runner, followLinks: false)) {
      case FileSystemEntityType.NOT_FOUND:
        new File(runner).writeAsStringSync(CustomLauncher, mode: FileMode.WRITE);
        Process.runSync('chmod', ['u+x', runner], workingDirectory: '$CurrentDirectory/tool');
        break;
    }
  }, description: 'Installs package', argParser: parser);
  
}