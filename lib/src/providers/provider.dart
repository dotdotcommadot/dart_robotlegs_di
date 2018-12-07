import 'package:robotlegs_di/src/descriptors/descriptor.dart';
import 'package:robotlegs_di/src/errors/injector_error.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
import 'package:robotlegs_di/src/injectionpoints/injection_point.dart';
import 'package:robotlegs_di/src/mapping/mapping.dart';

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

abstract class IProvider {
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters);

  void destroy();
}

abstract class IFallbackProvider extends IProvider {
  bool prepareNextRequest(String mappingId);
}

class FactoryProvider implements IProvider {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  Type _factoryType;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  FactoryProvider(this._factoryType);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    return (injector.getInstance(_factoryType) as IProvider)
        .apply(injector, type, injectParameters);
  }

  void destroy() {}
}

class ForwardingProvider implements IProvider {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  IProvider provider;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  ForwardingProvider(this.provider);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    return provider.apply(injector, type, injectParameters);
  }

  void destroy() {
    provider.destroy();
  }
}

class InjectorUsingProvider extends ForwardingProvider {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  IInjector injector;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  InjectorUsingProvider(this.injector, IProvider provider) : super(provider);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  @override
  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    return provider.apply(injector, type, injectParameters);
  }
}

class LocalOnlyProvider extends ForwardingProvider {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  LocalOnlyProvider(IProvider provider) : super(provider);
}

class OtherMappingProvider implements IProvider {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  InjectionMapping _mapping;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  OtherMappingProvider(this._mapping);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    return _mapping.getProvider().apply(injector, type, injectParameters);
  }

  void destroy() {}
}

class SingletonProvider implements IProvider {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  IInjector _creatingInjector;
  Type _responseType;

  dynamic _response;
  bool _destroyed = false;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  SingletonProvider(this._creatingInjector, this._responseType);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    if (_response == null) _response = _createResponse(_creatingInjector);

    return _response;
  }

  void destroy() {
    _destroyed = true;
    if (_response == null) return;

    TypeDescriptor descriptor =
        _creatingInjector.getTypeDescriptor(_responseType);
    PreDestroyInjectionPoint preDestroyInjectionPoint =
        descriptor.preDestroyMethods;
    while (preDestroyInjectionPoint != null) {
      preDestroyInjectionPoint.applyInjection(
          _creatingInjector, _response, _responseType);
      preDestroyInjectionPoint = preDestroyInjectionPoint.next;
    }
    _response = null;
  }

  dynamic _createResponse(Injector injector) {
    if (_destroyed) {
      throw new InjectorError(
          "Forbidden usage of unmapped singleton provider for type " +
              _responseType.runtimeType.toString());
    }

    return injector.instantiateUnmapped(_responseType);
  }
}

class SoftProvider extends ForwardingProvider {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  SoftProvider(IProvider provider) : super(provider);
}

class TypeProvider implements IProvider {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  final String constructor;

  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  final Type _responseType;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  TypeProvider(this._responseType, [this.constructor = '']);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type targetType, Map injectParameters) {
    return injector.instantiateUnmapped(_responseType, constructor);
  }

  void destroy() {}
}

class ValueProvider implements IProvider {
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  dynamic _value;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  ValueProvider(this._value);

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  dynamic apply(IInjector injector, Type type, Map injectParameters) {
    return _value;
  }

  void destroy() {}
}
