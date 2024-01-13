import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'hello.g.dart';

@riverpod
String hello(HelloRef ref) {
  return 'Hello World!';
}
