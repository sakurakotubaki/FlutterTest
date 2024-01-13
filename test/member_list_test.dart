import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:testing_example/member_list.dart';


void main() {
  testWidgets('member list ...', (tester) async {
  // MemberListPageをレンダリングします
  await tester.pumpWidget(const MaterialApp(home: MemberListPage()));

  // メンバーリストを定義します
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

  // ListViewが完全にロードされるまで待ちます
  await tester.pumpAndSettle();

  // 各メンバーの名前が正しく表示されていることを確認します
  for (var member in lists) {
    while (find.text(member).evaluate().isEmpty) {
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    expect(find.text(member), findsOneWidget);
  }
});
}
