import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mockito_cat.dart';
@GenerateNiceMocks([MockSpec<Cat>()])
import 'mockito_test.mocks.dart';

final fails = throwsA(const TypeMatcher<TestFailure>());

class FakeCat extends Fake implements Cat {
  //
}

void main() {
  group('verify the amount of interactions', () {
    test('never called', () {
      var cat = MockCat();
      verifyZeroInteractions(cat);

      cat.lives;
      expect(() => verifyZeroInteractions(cat), fails);
    });

    test('a method never called', () {
      var cat = MockCat();
      cat.go('places');
      verifyNever(cat.eat(any));
    });

    test('a method called once', () {
      var cat = MockCat();
      cat.eat('some food');
      verify(cat.eat(any));
      // second verification fails
      expect(() => verify(cat.eat(any)), fails);
    });

    test('a method called more than once: use count matcher', () {
      var cat = MockCat();
      cat.eat('carrot');
      cat.eat('grass');
      verify(cat.eat(any)).called(2);

      cat.eat('carrot');
      cat.eat('grass');
      verify(cat.eat(any)).called(inExclusiveRange(1, 3));
    });

    test('order of calls', () {
      var cat = MockCat();
      cat.eat('carrot');
      cat.eat('grass');
      cat.go('places');
      verifyInOrder([
        cat.eat(any),
        cat.eat(argThat(endsWith('ass'))),
        cat.go('places'),
      ]);
    });
  });

  group("let's stub!", () {
    test('stub getter', () {
      var cat = MockCat();
      when(cat.lives).thenReturn(42);
      expect(cat.lives, 42);
    });

    test('stub sync method', () {
      var cat = MockCat();
      when(cat.go('get some sleep')).thenReturn(true);
      expect(cat.go('get some sleep'), true);
    });

    test('stub throw', () {
      var cat = MockCat();
      when(cat.go(any)).thenThrow('no!');
      expect(() => cat.go('to work'), throwsA('no!'));
    });

    test('stub multiple values', () {
      var cat = MockCat();
      when(cat.lives).thenReturnInOrder([3, 2, 1]);
      expect(cat.lives, 3);
      expect(cat.lives, 2);
      expect(cat.lives, 1);
    });

    test('stub the future', () async {
      var cat = MockCat();
      when(cat.eat(any)).thenAnswer((_) async => true);
      expect(await cat.eat('mouse'), true);
    });

    test('stub a stream', () async {
      var cat = MockCat();
      when(cat.talk()).thenAnswer((_) => Stream.fromIterable(['guau']));
      expect(cat.talk(), emitsInOrder(['guau', emitsDone]));
    });

    test('stub a named parameter', () async {
      var cat = MockCat();
      when(cat.eat('carrot', hungry: argThat(isTrue, named: 'hungry')))
          .thenAnswer((_) async => true);
      when(cat.eat(any)).thenAnswer((_) async => false);
      expect(await cat.eat('carrot'), false);
      expect(await cat.eat('carrot', hungry: true), true);
    });
  });
}
