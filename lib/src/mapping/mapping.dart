import 'package:robotlegs_di/src/errors/injector_error.dart';
import 'package:robotlegs_di/src/injection/injector.dart';
import 'package:robotlegs_di/src/providers/provider.dart';


 // Copyright (c) 2014 the original author or authors
 //
 // Permission is hereby granted, free of charge, to any person obtaining a copy
 // of this software and associated documentation files (the "Software"), to deal
 // in the Software without restriction, including without limitation the rights
 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 // copies of the Software, and to permit persons to whom the Software is
 // furnished to do so, subject to the following conditions:
 //
 // The above copyright notice and this permission notice shall be included in
 // all copies or substantial portions of the Software.
 //
 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 // THE SOFTWARE.
 

abstract class IUnsealedMapping {
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
  ///see [InjectionMapping.seal]
  dynamic seal();
}

abstract class IProviderlessMapping {
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  /// Makes the mapping return a newly created instance of the given [type] for
  /// each consecutive request.
  ///
  /// Syntactic sugar method wholly equivalent to using
  /// `toProvider(new ClassProvider(type))`.
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  ///
  /// See [toProvider]
  /// 
  /// Example:
  ///
  ///  injector.map(AbstractProduct).toType(Product);
  ///  injector.map(IProduct).toType(Product);
  ///
  /// where
  ///   `class Product extends AbstractProduct implements IProduct{}`
  IUnsealedMapping toType(Type type, [String constructorName = '']);

  /// Makes the mapping return the given value for each consecutive request.
  ///
  /// Syntactic sugar method wholly equivalent to using
  /// `toProvider(new ValueProvider(value))`.
  ///
  /// [value]  The instance to return upon each request
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  ///
  /// See [toProvider]
  ///
  /// Example:
  ///
  ///   var value = new Product();
  ///   injector.map(Product).toValue(value);
  ///
  /// injector will always return the same instance of Product
  ///
  IUnsealedMapping toValue(dynamic value);

  /// Makes the mapping return a lazily constructed singleton instance of the mapped type for
  /// each consecutive request.
  ///
  /// Syntactic sugar method wholly equivalent to using
  /// `toProvider(new SingletonProvider(type, injector))`, where
  /// injector denotes the Injector that should manage the singleton.
  ///
  /// [type]  The [class] to instantiate upon each request
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError Sealed mappings can't be changed in any way
  ///
  /// See [toProvider]
  ///
  /// Example:
  ///
  ///   injector.map(AbstractProduct).toSingleton(Product);
  ///
  /// This will always return the same instance of `Product` for requests of `AbstractProduct`
  ///
  IUnsealedMapping toSingleton(Type type);

  /// Syntactic sugar method wholly equivalent to using [toSingleton(type)].
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  ///
  /// See [toSingleton]
  ///
  /// Example:
  ///   injector.map(Product).asSingleton();
  ///
  /// this will always return the same instance of `Product`
  IUnsealedMapping asSingleton();

  /// Makes the mapping apply the given [provider] and return the
  /// resulting value for each consecutive request.
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  IUnsealedMapping toProvider(IProvider provider);

  ///see [InjectionMapping.seal]
  dynamic seal();
}

class InjectionMapping implements IProviderlessMapping, IUnsealedMapping {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  bool get isSealed => _sealed;

  bool get hasProvider =>
      _creatingInjector.providerMappings[_mappingId] != null;

  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  Type _type;

  String _name;

  String _mappingId;

  Injector _creatingInjector;

  Injector _overridingInjector;

  bool _defaultProviderSet = false;

  IProvider provider;

  bool _soft = false;

  bool _local = false;

  bool _sealed = false;

  Symbol _sealKey;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  InjectionMapping(
      this._mappingId, this._creatingInjector, this._type, this._name) {
    _defaultProviderSet = true;
    _mapProvider(new TypeProvider(_type));
  }

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  IUnsealedMapping asSingleton() {
    toSingleton(_type);
    return this;
  }

  IUnsealedMapping toType(Type type, [String constructor = '']) {
    toProvider(new TypeProvider(type, constructor));
    return this;
  }

  IUnsealedMapping toSingleton(Type type) {
    toProvider(new SingletonProvider(_creatingInjector, type));
    return this;
  }

  IUnsealedMapping toValue(dynamic value) {
    toProvider(new ValueProvider(value));
    return this;
  }

  IUnsealedMapping toProvider(IProvider provider) {
    if (_sealed) throw new InjectorError('Can\'t change a sealed mapping');

    if (hasProvider && provider != null && !_defaultProviderSet) {
      print('Warning: Injector already has a mapping for ' +
          _mappingId +
          '.\n ' +
          'If you have overridden this mapping intentionally you can use ' +
          '"injector.unmap()" prior to your replacement mapping in order to ' +
          'avoid seeing this message.');
    }

    //TODO add name and "this" to event
    _creatingInjector.onMappingOverrideController.add(_type);
    _creatingInjector.onPreMappingChangedController.add('');
    _defaultProviderSet = false;
    _mapProvider(provider);
    _creatingInjector.onPostMappingChangedController.add('');
    return this;
  }

  /// Makes the mapping apply the [DependencyProvider] mapped to [type]
  /// and (optionally) [name] and return the resulting value for each consecutive
  /// request.
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorMissingMappingError] when no mapping was found
  /// for the specified dependency
  IUnsealedMapping toProviderOf(Type type, [String name = '']) {
    final IProvider provider = _creatingInjector.getMapping(type).getProvider();
    toProvider(provider);
    return this;
  }

  /// Causes the Injector the mapping is defined in to look further up in its inheritance
  /// chain for other mappings for the requested dependency. The Injector will use the
  /// inner-most strong mapping if one exists or the outer-most soft mapping otherwise.
  ///
  /// Soft mappings enable modules to be set up in such a way that some of their settings
  /// can optionally be configured from the outside without them failing to run in standalone
  /// mode.
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  IProviderlessMapping softly() {
    if (_sealed) throw new InjectorError('Can\'t change a sealed mapping');

    if (!_soft) {
      final IProvider provider = getProvider();
      _creatingInjector.onPreMappingChangedController.add('');
      _soft = true;
      _mapProvider(provider);
      _creatingInjector.onPostMappingChangedController.add('');
    }
    return this;
  }

  /// Disables sharing the mapping with child Injectors of the Injector it is defined in.
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Sealed mappings can't be changed in any way
  IProviderlessMapping locally() {
    if (_sealed) throw new InjectorError('Can\'t change a sealed mapping');

    if (_local) return this;

    final IProvider provider = getProvider();
    _creatingInjector.onPreMappingChangedController.add('');
    _local = true;
    _mapProvider(provider);
    _creatingInjector.onPostMappingChangedController.add('');
    return this;
  }

  /// Prevents all subsequent changes to the mapping, including removal. Trying to change it
  /// in any way at all will throw an [InjectorError].
  ///
  /// To enable unsealing of the mapping at a later time, [seal] returns a
  /// unique object that can be used as the argument to [unseal]. As long as that
  /// key object is kept secret, there's no way to tamper with or remove the mapping.
  ///
  /// Returns an internally created object that can be used as the key for unseal
  ///
  /// Throws [InjectorError] Can't be invoked on a mapping that's already sealed
  ///
  /// See [unseal]
  Symbol seal() {
    if (_sealed) {
      throw new InjectorError('Mapping is already sealed.');
    }
    _sealed = true;
    _sealKey = new Symbol("sealed");
    return _sealKey;
  }

  /// Reverts the effect of [seal], makes the mapping changeable again.
  ///
  ///   The [key] used to unseal the mapping. Has to be the instance returned by
  /// [seal]
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  ///
  /// Throws [InjectorError] Has to be invoked with the unique key object returned by an earlier call to [seal]
  /// Throws [InjectorError] Can't unseal a mapping that's not sealed
  ///
  /// See [seal]
  InjectionMapping unseal(Symbol key) {
    if (!_sealed) {
      throw new InjectorError('Can\'t unseal a non-sealed mapping.');
    }
    if (key != _sealKey) {
      throw new InjectorError('Can\'t unseal mapping without the correct key.');
    }

    _sealed = false;
    _sealKey = null;
    return this;
  }

  IProvider getProvider() {
    IProvider provider = _creatingInjector.providerMappings[_mappingId];
    while (provider is ForwardingProvider) {
      provider = (provider as ForwardingProvider).provider;
    }
    return provider;
  }

  /// Sets the [injector] to supply to the mapped [DependencyProvider] or to query for ancestor
  /// mappings.
  ///
  /// An Injector is always provided when calling apply, but if one is also set using
  /// setInjector, it takes precedence. This is used to implement forks in a dependency graph,
  /// allowing the use of a different Injector from a certain point in the constructed object
  /// graph on.
  ///
  /// Set to [null] to reset
  ///
  /// Returns The [InjectionMapping] the method is invoked on
  InjectionMapping setInjector(IInjector injector) {
    if (_sealed) throw new InjectorError('Can\'t change a sealed mapping');

    if (injector == _overridingInjector) {
      return this;
    }
    IProvider provider = getProvider();
    _overridingInjector = injector;
    _mapProvider(provider);
    return this;
  }

  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------

  void _mapProvider(IProvider provider) {
    if (_soft) {
      provider = new SoftProvider(provider);
    }

    if (_local) {
      provider = new LocalOnlyProvider(provider);
    }

    if (_overridingInjector != null) {
      provider = new InjectorUsingProvider(_overridingInjector, provider);
    }
    _creatingInjector.providerMappings[_mappingId] = provider;
  }
}
