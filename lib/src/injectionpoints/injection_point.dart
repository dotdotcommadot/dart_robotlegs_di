import 'package:robotlegs_di/src/errors/injector_error.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
import 'package:robotlegs_di/src/providers/provider.dart';
import 'package:robotlegs_di/src/reflection/reflector.dart';

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

class InjectionPoint {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  InjectionPoint next;
  InjectionPoint last;
  Map injectParameters;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  InjectionPoint();

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  void applyInjection(IInjector injector, dynamic target, Type type) {}
}

class ConstructorInjectionPoint extends MethodInjectionPoint {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  ConstructorInjectionPoint(String method, List<dynamic> positionalArguments,
      int numRequiredPositionalArguments, Map<String, dynamic> namedArguments)
      : super(method, positionalArguments, numRequiredPositionalArguments,
            namedArguments, false);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic createInstance(Type type, IInjector injector) {
    return reflect
        .getClassMirror(type)
        .newInstance(method, _getPositionalValues(injector, type, type));
    ;
  }
}

class MethodInjectionPoint extends InjectionPoint {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  final String method;

  final bool isOptional;

  final List<Type> positionalArguments;

  final int numRequiredPositionalArguments;

  final Map<String, Type> namedArguments;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  MethodInjectionPoint(
      this.method,
      this.positionalArguments,
      this.numRequiredPositionalArguments,
      this.namedArguments,
      this.isOptional);

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  @override
  void applyInjection(Injector injector, Object target, Type targetType) {
    reflect
        .reflect(target)
        .invoke(method, _getPositionalValues(injector, target, targetType));
  }

  List<dynamic> _getPositionalValues(
      Injector injector, Object target, Type targetType) {
    if (positionalArguments == null || positionalArguments.length == 0)
      return [];

    IProvider provider;
    List<dynamic> positionalValues = new List<dynamic>();

    int nunmProcessedPositionalArguments = 0;

    positionalArguments.forEach((Type type) {
      provider = injector.getProvider(Injector.getMappingId(type));

      if (provider == null) {
        if (isOptional ||
            nunmProcessedPositionalArguments >= numRequiredPositionalArguments)
          return;

        throw (new InjectorMissingMappingError(
            'Injector is missing a mapping to handle injection into target ' +
                target.toString() +
                ' of type "' +
                type.toString() +
                '"'));
      }

      positionalValues.add(provider.apply(injector, type, null));
      nunmProcessedPositionalArguments++;
    });

    return positionalValues;
  }
}

class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  NoParamsConstructorInjectionPoint(String method) : super(method, [], 0, null);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  @override
  dynamic createInstance(Type type, IInjector injector) =>
      reflect.getClassMirror(type).newInstance(method, []);
}

class OrderedInjectionPoint extends MethodInjectionPoint {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  int order;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  OrderedInjectionPoint(
      String method,
      List<dynamic> positionalArguments,
      int numRequiredPositionalArguments,
      Map<String, dynamic> namedArguments,
      this.order)
      : super(method, positionalArguments, numRequiredPositionalArguments,
            namedArguments, false);
}

class PostConstructInjectionPoint extends OrderedInjectionPoint {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  PostConstructInjectionPoint(
      String method,
      List<dynamic> positionalArguments,
      int numRequiredPositionalArguments,
      Map<String, dynamic> namedArguments,
      int order)
      : super(method, positionalArguments, numRequiredPositionalArguments,
            namedArguments, order);
}

class PreDestroyInjectionPoint extends OrderedInjectionPoint {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  PreDestroyInjectionPoint(
      String method,
      List<dynamic> positionalArguments,
      int numRequiredPositionalArguments,
      Map<String, dynamic> namedArguments,
      int order)
      : super(method, positionalArguments, numRequiredPositionalArguments,
            namedArguments, order);
}

class PropertyInjectionPoint extends InjectionPoint {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  String _mappingId;

  String _property;

  bool _optional;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  PropertyInjectionPoint(this._mappingId, this._property, this._optional);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  @override
  void applyInjection(Injector injector, dynamic target, Type type) {
    IProvider provider = injector.getProvider(_mappingId);

    if (provider == null) {
      if (_optional) return;

      throw (new InjectorMissingMappingError(
          'Injector is missing a mapping to handle injection into property "' +
              _property.toString() +
              '" of object "' +
              target.runtimeType.toString() +
              '" with type "' +
              type.toString() +
              '". \nTarget dependency: "' +
              _mappingId +
              '"'));
    }

    // TODO: figure out injectParameters;
    var instance = provider.apply(injector, type, null);

    reflect.reflect(target).invokeSetter(_property, instance);
  }
}
