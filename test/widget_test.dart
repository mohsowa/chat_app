import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/core/errors/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/data/models/friends_model.dart';
import 'package:chat_app/features/home/presentation/cubits/explore/explore_cubit.dart';
import 'package:chat_app/features/home/presentation/cubits/friends/friend_cubit.dart';
import 'package:chat_app/features/home/presentation/pages/home.dart';
import 'package:chat_app/features/profile/presentation/pages/profile.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/features/home/domain/repositories/explore_repo.dart';
import 'package:chat_app/features/home/domain/repositories/friend_repo.dart';
import 'package:mockito/mockito.dart';


class MockFriendRepository extends Mock implements FriendRepository {}

void main() {

  group('HomePage Widget Tests', () {
    testWidgets('HomePage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      expect(find.text('My Chats'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      // Your widget test code here
      await tester.pumpWidget(const MaterialApp(home: HomePage()));
      // Trigger search and verify the result
    });

    testWidgets('Renders ProfilePage widget', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

    });
    testWidgets('Open Image Editor Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ProfilePage()));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(find.text("Edit Image"), findsOneWidget);

    });

    testWidgets('Renders ProfilePage widget', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ProfilePage()));

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });



  });

  group('Friends Unit Tests', () {
    late FriendCubit friendCubit;
    late MockFriendRepository mockFriendRepository;

    setUp(() {
      mockFriendRepository = MockFriendRepository();
      friendCubit = FriendCubit(mockFriendRepository);
    });

    tearDown(() {
      friendCubit.close();
    });

    test('initial state is FriendInitial', () {
      expect(friendCubit.state, FriendInitial());
    });

    blocTest<FriendCubit, FriendState>(
      'emits [FriendLoading, FriendError] when addFriend fails',
      build: () {
        when(mockFriendRepository.addFriend(1))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
        return friendCubit;
      },
      act: (cubit) => cubit.addFriend(1),
      expect: () => [FriendLoading(), FriendError(message: 'Error')],
    );

    blocTest<FriendCubit, FriendState>(
      'emits [FriendLoading, FriendLoaded] when addFriend is successful',
      build: () {
        when(mockFriendRepository.addFriend(2))
            .thenAnswer((_) async => Right(FriendsModel(id: 1, user_id: 1, friend_id: 2, status: 'pending')));
        return friendCubit;
      },
      act: (cubit) => cubit.addFriend(1),
      expect: () => [FriendLoading(), FriendLoaded(friends: FriendsModel(id: 1, user_id: 1, friend_id: 2, status: 'pending'))],
    );

  });

  group('ExploreCubit Integration Test', () {
    late ExploreCubit exploreCubit;
    late ExploreRepository mockRepository;

    setUp(() {
      mockRepository = MockExploreRepository();
      exploreCubit = ExploreCubit(mockRepository);
    });

    blocTest<ExploreCubit, ExploreState>(
      'emits [ExploreLoading, ExploreEmpty] when searchExplore is called',
      build: () => exploreCubit,
      act: (cubit) => cubit.searchExplore('test_query'),
      expect: () => [ExploreLoading(), ExploreEmpty()],
    );
  });

}
class MockExploreRepository extends Mock implements ExploreRepository {
  @override
  Future<Either<Failure, List<UserModel>>> searchExplore(String query) async {
    return Right(List<UserModel>.empty());
  }
}