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

part of robotlegs_di;

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
      provider = injector._getProvider(Injector._getMappingId(type));

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
