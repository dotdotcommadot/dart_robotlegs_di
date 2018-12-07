import 'package:robotlegs_di/robotlegs_di.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
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

injectionTestCase() {
  IInjector injector;

  setUp(() {
    injector = new Injector();
  });

  tearDown(() {
    injector = null;
  });

  test('Unmap removes mapping', () {
    injector.map(InjectedClazz);

    expect(injector.satisfies(InjectedClazz), isTrue);

    injector.unmap(InjectedClazz);

    expect(injector.satisfies(InjectedClazz), isFalse);
  });

  test('Injector injects bound value into all injectees', () {
    ValueHolderInjectee injectee = new ValueHolderInjectee();
    ValueHolderInjectee injectee2 = new ValueHolderInjectee();
    const valueHolder = const ValueHolder("abcABC-123");
    injector.map(ValueHolder).toValue(valueHolder);

    injector.injectInto(injectee);
    expect(identical(valueHolder, injectee.valueHolder), isTrue);

    injector.injectInto(injectee2);
    expect(identical(valueHolder, injectee2.valueHolder), isTrue);
  });

  test('map value by interface', () {
    var injectee = new InterfaceInjectee();
    Interface value = new ImplementationOfInterface();

    injector.map(Interface).toValue(value);
    injector.injectInto(injectee);

    expect(identical(value, injectee.interface), isTrue);
  });

  test('Injecting ValueHolder', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(InjectedClazz);
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedValueHolder.value, equals("abcABC-123"));
  });

  test('Injecting Class', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(InjectedClazz);
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedClazz, isNotNull);
    expect(myClazz.firstMethodWithParametersValue, isNotNull);
  });

  test('Named Injection', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector
        .map(ValueHolder, "hello")
        .toValue(const ValueHolder("hello world"));
    injector.map(InjectedClazz);
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedValueHolder.value, equals("abcABC-123"));
    expect(myClazz.myInjectedHelloValueHolder.value, equals("hello world"));
  });

  test('Named Injection by Interface', () {
    var injectee = new NamedInterfaceInjectee();
    Interface value = new ImplementationOfInterface();

    injector.map(Interface, "name").toValue(value);
    injector.injectInto(injectee);

    expect(identical(value, injectee.interface), isTrue);
  });

  test('mapped value is not injected into', () {
    var injectee = new RecursiveInterfaceInjectee();
    InterfaceInjectee value = new InterfaceInjectee();

    injector.map(InterfaceInjectee).toValue(value);
    injector.injectInto(injectee);

    expect(value.interface, isNull);
  });

  test('map multiple interface to one singleton class', () {
    var injectee = new MultipleSingletonsOfSameClassInjectee();

    injector.map(Interface).toSingleton(ImplementationOfInterface);
    injector.map(Interface2).toSingleton(ImplementationOfInterface);
    injector.injectInto(injectee);

    expect(injectee.interface, isNotNull);
    expect(injectee.interface2, isNotNull);
    expect(identical(injectee.interface, injectee.interface2), isFalse);
  });

  test('map class to type creates new instances', () {
    var injectee = new RandomNumberInjectee();
    var injectee2 = new RandomNumberInjectee();

    injector.map(RandomNumberHolder).toType(RandomNumberHolder);

    injector.injectInto(injectee);
    expect(injectee.randomNumberHolder.randomNumber, isNotNull);
    injector.injectInto(injectee2);
    expect(injectee2.randomNumberHolder.randomNumber, isNotNull);

    expect(
        identical(injectee.randomNumberHolder.randomNumber,
            injectee2.randomNumberHolder.randomNumber),
        isFalse);
  });

  test('map class to type creates new instances', () {
    var injectee = new ComplexClassInjectee();
    var value = new InjectedClazz();

    injector.map(InjectedClazz).toValue(value);
    injector.map(ComplexClass).toType(ComplexClass);

    injector.injectInto(injectee);

    expect(injectee.complexClass, isNotNull);
    expect(identical(injectee.complexClass.injectedClazz, value), isTrue);
  });

  test('Optional Injection', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(InjectedClazz);
    injector.map(Clazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedHelloValueHolder, isNull);
  });

  test('Constructor Injection', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(ClazzTwo);

    ClazzTwo myClazzTwo = injector.getInstance(ClazzTwo);
    expect(myClazzTwo.valueHolder.value, equals("abcABC-123"));
  });

  test('Setter Injection', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(Clazz);
    injector.map(InjectedClazz);

    Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.mySetterInjectedValueHolder.value, equals("abcABC-123"));
  });

  test('Method Injection', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(Clazz);
    injector.map(InjectedClazz);

    Clazz myClazz = injector.getInstance(Clazz);

    expect(myClazz.hasRunFirstMethod, equals(true));
  });

  test('Method Injection with Parameters', () {
    injector.map(ValueHolder).toValue(const ValueHolder("abcABC-123"));
    injector.map(Clazz);
    injector.map(InjectedClazz);

    Clazz myClazz = injector.getInstance(Clazz);

    expect(myClazz.firstMethodWithParametersValue, isNotNull);
    expect(myClazz.firstMethodWithParametersValue.runtimeType,
        equals(InjectedClazz));
  });
}
