import 'package:flutter/material.dart';

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lists = [
      '山田太郎',
      '田中花子',
      '佐藤次郎',
      '鈴木三郎',
      '高橋四郎',
      '伊藤五郎',
      '渡辺六郎',
      '山本七郎',
      '中村八郎',
      '小林九郎',
      '加藤十郎',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('メンバー一覧'),
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lists[index]),
          );
        },
      ),
    );
  }
}
