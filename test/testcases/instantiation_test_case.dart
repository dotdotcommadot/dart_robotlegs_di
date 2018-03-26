import 'package:robotlegs_di/robotlegs_di.dart';
import 'package:test/test.dart';

import '../objects/objects.dart';

/*
* Copyright (c) 2014 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

instantiationTestCase() {
  IInjector injector;

  setUp(() {
    injector = new Injector();
    injector.map(ValueHolder).toValue(const ValueHolder(''));
    injector.map(InjectedClazz);
    injector
        .map(ValueHolder, 'setterInjectedValueHolder')
        .toValue(const ValueHolder('setter'));
  });

  tearDown(() {
    injector = null;
  });

  test('Instantiating Class', () {
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz, isNotNull);
  });

  test('Instantiating Class From Interface', () {
    injector.map(InterfaceClazz).toType(Clazz);

    Clazz myClazz = injector.getInstance(InterfaceClazz);
    expect(myClazz, isNotNull);
  });

  test('Instantiating Class From Abstract Class', () {
    injector.map(AbstractClazz).toType(Clazz);

    Clazz myClazz = injector.getInstance(AbstractClazz);
    expect(myClazz, isNotNull);
  });

  test('Instantiating Class From Mixin', () {
    injector.map(MixinClazz).toType(Clazz);

    Clazz myClazz = injector.getInstance(MixinClazz);
    expect(myClazz, isNotNull);
  });

  test('Instantiating Class with Named Constructor', () {
    injector.map(ClazzTwo, "clazzTwo_named").toType(ClazzTwo, 'named');

    ClazzTwo myClazzTwo = injector.getInstance(ClazzTwo, "clazzTwo_named");
    expect(myClazzTwo.valueHolder.value, equals("named"));
  });
}
