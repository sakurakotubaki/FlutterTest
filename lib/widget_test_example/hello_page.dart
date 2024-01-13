import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_example/widget_test_example/hello.dart';

// class HelloPage extends StatelessWidget {
//   const HelloPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Hello Page!'),
//       ),
//       body: const Center(
//         child: Text('Hello World!', style: TextStyle(fontSize: 25)),
//       ),
//     );
//   }
// }


class HelloPage extends ConsumerWidget {
  const HelloPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hello = ref.watch(helloProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Page!'),
      ),
      body: Center(
        child: Text(hello, style: const TextStyle(fontSize: 25)),
      ),
    );
  }
}
