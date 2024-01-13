import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_example/user_model.dart';
import 'package:testing_example/user_repository.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;

  setUp(() {
    mockHTTPClient = MockHTTPClient();
    userRepository = UserRepository(mockHTTPClient);
  });

  group('UserRepository - ', () {
    group('getUser function', () {
      test(
        'getUser 関数が呼び出され、ステータス コードが 200 の場合、指定された UserRepository クラスでは ユーザーモデル が返される必要があります。',
        () async {
          // Arrange
          when(
            () => mockHTTPClient.get(
              Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            ),
          ).thenAnswer((invocation) async {
            return Response('''
            {
              "id": 1,
              "name": "Leanne Graham",
              "username": "Bret",
              "email": "Sincere@april.biz",
              "website": "hildegard.org"
            }
            ''', 200);
          });
          // Act
          final user = await userRepository.getUser();
          // Assert
          expect(user, isA<User>());
        },
      );

      test(
        '指定された UserRepository クラスで getUser 関数が呼び出され、ステータス コードが 200 でない場合は、例外がスローされる必要があります。',
        () async {
          // arrange
          when(
            () => mockHTTPClient.get(
              Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
            ),
          ).thenAnswer((invocation) async => Response('{}', 500));
          // act
          final user = userRepository.getUser();
          // assert
          expect(user, throwsException);
        },
      );
    });
  });
}
