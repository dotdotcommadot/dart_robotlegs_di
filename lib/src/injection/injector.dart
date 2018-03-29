import 'dart:async';

import 'package:robotlegs_di/src/descriptors/descriptor.dart';
import 'package:robotlegs_di/src/errors/injector_error.dart';
import 'package:robotlegs_di/src/injectionpoints/injection_point.dart';
import 'package:robotlegs_di/src/mapping/mapping.dart';
import 'package:robotlegs_di/src/providers/provider.dart';
import 'package:robotlegs_di/src/reflection/reflector.dart';

////
/// Copyright (c) 2014 the original author or authors
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
////

/// The [IInjector] manages the mappings and acts as the central hub from which all
/// injections are started.

abstract class IInjector {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  //-----------------------------------
  // Streams
  //-----------------------------------

  Stream get onPostInstantiated;

  Stream get onPreMappingCreated;

  Stream get onPreMappingChanged;

  StreamController onPreMappingChangedController;

  Stream get onPostMappingCreated;

  Stream get onPostMappingChanged;

  StreamController onPostMappingChangedController;

  Stream get onPostMappingRemoved;

  Stream get onPreConstruct;

  Stream get onPostConstruct;

  Stream get onMappingOverride;

  StreamController onMappingOverrideController;

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  
   /// Maps a request description, consisting of the [type] and, optionally, the
   /// [name]
   ///
   /// <p>The returned mapping is created if it didn't exist yet or simply returned otherwise.</p>
   ///
   /// <p>Named mappings should be used as sparingly as possible as they increase the likelyhood
   /// of typing errors to cause hard to debug errors at runtime.</p>
   ///
   /// [type]  The [class]describing the mapping
   /// [name]  The name, as a case-sensitive string, to further describe the mapping
   ///
   /// Returns The [InjectionMapping] for the given request description
   ///
   /// See [unmap]
   /// See [InjectionMapping]
  InjectionMapping map(Type type, [String name = '']);

   ///  Removes the mapping described by the given [type]and [name].
   ///
   /// [type]  The [class]describing the mapping
   /// [name]  The name, as a case-sensitive string, to further describe the mapping
   ///
   /// Throws a [InjectorError] Descriptions that are not mapped can't be unmapped
   /// Throws a [InjectorError] Sealed mappings have to be unsealed before unmapping them
   ///
   /// See [map]
   /// See [InjectionMapping]
   /// See [InjectionMapping.unseal]
  void unmap(Type type, [String name = '']);

   /// Indicates whether the injector can supply a response for the specified dependency either
   /// by using a mapping of its own or by querying one of its ancestor injectors.
   ///
   /// [type]  The type of the dependency under query
   /// [name]  The name of the dependency under query
   ///
   /// Returns [true] if the dependency can be satisfied, [false] if not

  bool satisfies(Type type, [String name = '']);

   /// Indicates whether the injector can directly supply a response for the specified
   /// dependency.
   ///
   /// <p>In contrast to [satisfies], [satisfiesDirectly] only informs
   /// about mappings on this injector itself, without querying its ancestor injectors.</p>
   ///
   /// [type]  The type of the dependency under query
   /// [name]  The name of the dependency under query
   ///
   /// Returns [true] if the dependency can be satisfied, [false] if not

  bool satisfiesDirectly(Type type, [String name = '']);

   /// Returns the mapping for the specified dependency class
   ///
   /// <p>Note that getMapping will only return mappings in exactly this injector, not ones
   /// mapped in an ancestor injector. To get mappings from ancestor injectors, query them
   /// using [parentInjector].
   /// This restriction is in place to prevent accidental changing of mappings in ancestor
   /// injectors where only the child's response is meant to be altered.</p>
   ///
   /// [type]  The type of the dependency to return the mapping for
   /// [name]  The name of the dependency to return the mapping for
   ///
   /// Returns The mapping for the specified dependency class
   ///
   /// Throws a [InjectorMissingMappingError] when no mapping was found
   /// for the specified dependency
  InjectionMapping getMapping(Type type, [String name = '']);

  
   /// Inspects the given object and injects into all injection points configured for its class.
   ///
   /// [target]  The instance to inject into
   ///
   /// Throws a [InjectorError] The [Injector] must have mappings
   /// for all injection points
   ///
   /// See [map]

  void injectInto(dynamic target);

  
   /// Instantiates the class identified by the given [type]and [name].
   ///
   /// <p>The parameter [targetType]is only useful if the
   /// [InjectionMapping]used to satisfy the request might vary its result based on
   /// that [targetType]. An Example of that would be a provider returning a logger
   /// instance pre-configured for the instance it is used in.</p>
   ///
   /// [type]  The [class]describing the mapping
   /// [name]  The name, as a case-sensitive string, to use for mapping resolution
   /// [targetType]  The type of the instance that is dependent on the returned value
   ///
   /// Returns The mapped or created instance
   ///
   /// Throws a [InjectorMissingMappingError] if no mapping was found
   /// for the specified dependency and no [fallbackProvider]is set.
  dynamic getInstance(Type type, [String name = '', Type targetType = null]);

   /// Returns an instance of the given type. If the Injector has a mapping for the type, that
   /// is used for getting the instance. If not, a new instance of the class is created and
   /// injected into.
   ///
   /// [type]  The type to get an instance of
   /// Returns The instance that was created or retrieved from the mapped provider
   ///
   /// Throws a [InjectorMissingMappingError] if no mapping is found
   /// for one of the type's dependencies and no [fallbackProvider] is set
  dynamic getOrCreateNewInstance(Type type, [String name = '']);

   /// Creates an instance of the given type and injects into it.
   ///
   /// [type]  The type to instantiate
   /// Returns The new instance, with all of its dependencies fulfilled
   ///
   /// Throws a [InjectorMissingMappingError] if no mapping is found
   /// for one of the type's dependencies and no [fallbackProvider] is set
  dynamic instantiateUnmapped(Type type, [String constructor = '']);

   /// Uses the [TypeDescriptor] the injector associates with the given instance's
   /// type to iterate over all [[PreDestroy]]methods in the instance, supporting
   /// automated destruction.
   ///
   /// [instance]  The instance to destroy
  void destroyInstance(dynamic instance);

   /// Destroys the injector by cleaning up all instances it manages.
   ///
   /// Cleanup in this context means iterating over all mapped dependency providers and invoking
   /// their [destroy] methods and calling [preDestroy] methods on all objects the
   /// injector created or injected into.
   ///
  void teardown();

   /// Creates a new [Injector] and sets itself as that new [Injector]'s
   /// [parentInjector].
   ///
   /// Returns The newly created [Injector] instance
   ///
   /// See [parentInjector]
  IInjector createChildInjector();

   /// Sets the [Injector] to ask in case the current [Injector] doesn't
   /// have a mapping for a dependency.
   ///
   /// <p>Parent Injectors can be nested in arbitrary depths with very little overhead,
   /// enabling very modular setups for the managed object graphs.</p>
   ///
  IInjector parentInjector;

   /// Instructs the injector to use the description for the given [type] when constructing or
   /// destroying instances.
   ///
   /// The description [descriptor] consists details for the constructor, all properties and methods to
   /// inject into during construction and all methods to invoke during destruction.
  void addTypeDescriptor(Type type, TypeDescriptor descriptor);

   /// Returns a description of the given [type] containing its constructor, injection points
   /// and post construct and pre destroy hooks
  TypeDescriptor getTypeDescriptor(Type type);

  bool hasMapping(Type type, [String name = '']);

  bool hasDirectMapping(Type type, [String name = '']);

  String getQualifiedName(Type type);
}

class Injector implements IInjector {
  //-----------------------------------
  //
  // Public Static Properties
  //
  //-----------------------------------

  static Map INJECTION_POINTS_CACHE = new Map();

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  Map<String, IProvider> providerMappings = new Map<String, IProvider>();

  //-----------------------------------
  // Streams
  //-----------------------------------

  Stream _onPostInstantiated;

  Stream get onPostInstantiated => _onPostInstantiated;
  StreamController _onPostInstantiatedController = new StreamController();

  Stream _onPreMappingCreated;

  Stream get onPreMappingCreated => _onPreMappingCreated;
  StreamController _onPreMappingCreatedController = new StreamController();

  Stream _onPreMappingChanged;

  Stream get onPreMappingChanged => _onPreMappingChanged;
  StreamController onPreMappingChangedController = new StreamController();

  Stream _onPostMappingCreated;

  Stream get onPostMappingCreated => _onPostMappingCreated;
  StreamController _onPostMappingCreatedController = new StreamController();

  Stream _onPostMappingChanged;

  Stream get onPostMappingChanged => _onPostMappingChanged;
  StreamController onPostMappingChangedController = new StreamController();

  Stream _onPostMappingRemoved;

  Stream get onPostMappingRemoved => _onPostMappingRemoved;
  StreamController _onPostMappingRemovedController = new StreamController();

  Stream _onPreConstruct;

  Stream get onPreConstruct => _onPreConstruct;
  StreamController _onPreConstructController = new StreamController();

  Stream _onPostConstruct;

  Stream get onPostConstruct => _onPostConstruct;
  StreamController _onPostConstructController = new StreamController();

  Stream _onMappingOverride;

  Stream get onMappingOverride => _onMappingOverride;
  StreamController onMappingOverrideController = new StreamController();

  //-----------------------------------
  // ParentInjector
  //-----------------------------------

  IInjector parentInjector;

  //-----------------------------------
  // FallbackProvider
  //-----------------------------------

  IFallbackProvider fallbackProvider;

  //-----------------------------------
  // BlockParentFallbackProvider
  //-----------------------------------

  bool blockParentFallbackProvider = false;

  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------

  final Reflector _reflector = new Reflector();

  Map<String, bool> _mappingsInProcess = new Map<String, bool>();

  Map<String, InjectionMapping> _mappings = new Map<String, InjectionMapping>();

  List<dynamic> _managedObjects = new List<dynamic>();

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  Injector() {
    _onPostInstantiated =
        _onPostInstantiatedController.stream.asBroadcastStream();
    _onPreMappingCreated =
        _onPreMappingCreatedController.stream.asBroadcastStream();
    _onPreMappingChanged =
        onPreMappingChangedController.stream.asBroadcastStream();
    _onPostMappingCreated =
        _onPostMappingCreatedController.stream.asBroadcastStream();
    _onPostMappingChanged =
        onPostMappingChangedController.stream.asBroadcastStream();
    _onPostMappingRemoved =
        _onPostMappingRemovedController.stream.asBroadcastStream();
    _onPreConstruct = _onPreConstructController.stream.asBroadcastStream();
    _onPostConstruct = _onPostConstructController.stream.asBroadcastStream();
    _onMappingOverride = onMappingOverrideController.stream.asBroadcastStream();
  }

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  InjectionMapping map(Type type, [String name = '']) {
    final String mappingId = getMappingId(type, name);

    if (_mappings[mappingId] == null)
      return _createMapping(mappingId, type, name);
    else
      return _mappings[mappingId];
  }

  void unmap(Type type, [String name = '']) {
    final String mappingId = getMappingId(type, name);
    InjectionMapping mapping = _mappings[mappingId];

    if ((mapping != null) && mapping.isSealed) {
      throw new InjectorError('can\'t unmap a sealed mapping');
    }
    if (mapping == null) {
      throw new InjectorError('Error while removing an injector mapping: ' +
          'No mapping defined for dependency ' +
          mappingId);
    }
    mapping.getProvider().destroy();
    _mappings.remove(mappingId);
    providerMappings.remove(mappingId);

    _onPostMappingRemovedController.add("");
  }

  bool satisfies(Type type, [String name = '']) {
    final String mappingId = getMappingId(type, name);
    return getProvider(mappingId, true) != null;
  }

  bool satisfiesDirectly(Type type, [String name = '']) {
    final String mappingId = getMappingId(type, name);
    return hasDirectMapping(type, name) ||
        (getDefaultProvider(mappingId, false) != null);
  }

  InjectionMapping getMapping(Type type, [String name = '']) {
    final String mappingId = getMappingId(type, name);
    InjectionMapping mapping = _mappings[mappingId];
    if (mapping == null) {
      throw new InjectorMissingMappingError(
          'Error while retrieving an injector mapping: ' +
              'No mapping defined for dependency ' +
              mappingId);
    }
    return mapping;
  }

  void injectInto(dynamic target) {
    final Type type = _reflector.getType(target);
    applyinjectionPoints(target, type, _reflector.getDescriptor(type));
  }

  dynamic getInstance(Type type, [String name = '', Type targetType = null]) {
    final String mappingId = getMappingId(type, name);
    IProvider provider = getProvider(mappingId);
    if (provider == null) provider = getDefaultProvider(mappingId, true);

    if (provider != null) {
      if (provider is TypeProvider) {
        TypeDescriptor typeDescriptor = _reflector.getDescriptor(type);
        List<ConstructorInjectionPoint> constructorInjectionPoints =
            typeDescriptor.constructorInjectionPoints;
        Iterable<ConstructorInjectionPoint> iterable =
            constructorInjectionPoints.where((injectionPoint) {
          return injectionPoint.method ==
              (provider as TypeProvider).constructor;
        });
        final ConstructorInjectionPoint constructorInjectionPoint =
            iterable.first;

        return provider.apply(
            this, targetType, constructorInjectionPoint.injectParameters);
      } else {
        return provider.apply(this, targetType, null);
      }
    }

    String fallbackMessage = (fallbackProvider != null)
        ? "the fallbackProvider, '" +
            fallbackProvider.toString() +
            "', was unable to fulfill this request."
        : "the injector has no fallbackProvider.";

    throw new InjectorMissingMappingError('No mapping found for request ' +
        mappingId +
        ' and ' +
        fallbackMessage);
  }

  dynamic getOrCreateNewInstance(Type type, [String name = '']) {
    dynamic instance;
    if (satisfies(type))
      instance = getInstance(type);
    else
      instance = instantiateUnmapped(type);

    return instance;
  }

  dynamic instantiateUnmapped(Type type, [String constructor = '']) {
    if (!canBeInstantiated(type)) {
      throw new InjectorInterfaceConstructorError(
          'Can\'t instantiate interface ' + type.toString());
    }
    TypeDescriptor typeDescription = _reflector.getDescriptor(type);
    dynamic instance = typeDescription.constructorInjectionPoints
        .where((injectionPoint) => injectionPoint.method == constructor)
        .first
        .createInstance(type, this);
    _onPostInstantiatedController.add("");
    applyinjectionPoints(instance, type, typeDescription);

    return instance;
  }

  void destroyInstance(dynamic instance) {
    if (instance == null) return;

    final Type type = _reflector.getType(instance);
    final TypeDescriptor typeDescriptor = getTypeDescriptor(type);

    PreDestroyInjectionPoint preDestroyInjectionPoint =
        typeDescriptor.preDestroyMethods;

    while (preDestroyInjectionPoint != null) {
      preDestroyInjectionPoint.applyInjection(this, instance, type);
      preDestroyInjectionPoint = preDestroyInjectionPoint.next;
    }
  }

  void teardown() {
    _mappings.forEach((String key, InjectionMapping mapping) {
      mapping.getProvider().destroy();
    });

    _managedObjects.forEach((dynamic instance) {
      destroyInstance(instance);
    });

    _mappings = new Map<String, InjectionMapping>();
    providerMappings.clear();
    _mappingsInProcess = new Map();
    _managedObjects = new List<dynamic>();
    fallbackProvider = null;
    blockParentFallbackProvider = false;
  }

  IInjector createChildInjector() {
    IInjector injector = new Injector();
    injector.parentInjector = this;
    return injector;
  }

  void addTypeDescriptor(Type type, TypeDescriptor descriptor) =>
      _reflector.addDescriptor(type, descriptor);

  TypeDescriptor getTypeDescriptor(Type type) => _reflector.getDescriptor(type);

  bool hasMapping(Type type, [String name = '']) =>
      getProvider(getMappingId(type, name)) != null;

  bool hasDirectMapping(Type type, [String name = '']) =>
      _mappings[getMappingId(type, name)] != null;

  String getQualifiedName(Type type) => _getQualifiedName(type);

  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------

  void _purgeInjectionPointsCache() {
    INJECTION_POINTS_CACHE = new Map();
  }

  bool canBeInstantiated(Type type) {
    final TypeDescriptor descriptor = _reflector.getDescriptor(type);
    return descriptor.constructorInjectionPoints.length != null;
  }

  IProvider getProvider(String mappingId, [fallbackToDefault = true]) {
    IProvider softProvider;
    Injector injector = this;
    while (injector != null) {
      IProvider provider = injector.providerMappings[mappingId];
      if (provider != null) {
        if (provider is SoftProvider) {
          softProvider = provider;
          injector = injector.parentInjector;
        }
        if (provider is LocalOnlyProvider && injector != this) {
          injector = injector.parentInjector;
        }
        return provider;
      }
      injector = injector.parentInjector;
    }

    if (softProvider != null) {
      return softProvider;
    }
    return fallbackToDefault ? getDefaultProvider(mappingId, true) : null;
  }

  IProvider getDefaultProvider(String mappingId, bool consultParents) {
    if ((fallbackProvider != null) &&
        (fallbackProvider.prepareNextRequest(mappingId) != null)) {
      return fallbackProvider;
    }

    if (consultParents &&
        !blockParentFallbackProvider &&
        (parentInjector != null)) {
      return (parentInjector as Injector)
          .getDefaultProvider(mappingId, consultParents);
    }
    return null;
  }

  InjectionMapping _createMapping(String mappingId, Type type, String name) {
    if (_mappingsInProcess[mappingId] != null) {
      throw new InjectorError(
          'Can\'t change a mapping from inside a listener to it\'s creation event');
    }

    _mappingsInProcess[mappingId] = true;

    _onPreMappingCreatedController.add('');

    final InjectionMapping mapping =
        new InjectionMapping(mappingId, this, type, name);

    _mappings[mappingId] = mapping;

    final dynamic sealKey = mapping.seal();

    _onPostMappingCreatedController.add('');

    _mappingsInProcess.remove(mappingId);

    mapping.unseal(sealKey);

    return mapping;
  }

  void applyinjectionPoints(
      dynamic instance, Type type, TypeDescriptor typeDescriptor) {
    InjectionPoint injectionPoint = typeDescriptor.injectionPoints;

    _onPreConstructController.add('');

    while (injectionPoint != null) {
      injectionPoint.applyInjection(this, instance, type);
      injectionPoint = injectionPoint.next;
    }

    if (typeDescriptor.preDestroyMethods != null) {
      _managedObjects.add(instance);
    }

    _onPostConstructController.add('');
  }

  //-----------------------------------
  //
  // Private Static Methods
  //
  //-----------------------------------

  static String getMappingId(Type type, [String injectionName = '']) {
    String qualifiedName = _getQualifiedName(type);
    return qualifiedName + "|" + injectionName;
  }

  static String _getQualifiedName(Type type) {
    String qualifiedName;
    try {
      qualifiedName = reflect.reflectType(type).qualifiedName;
    } catch (e) {
      print(
          " Class you are trying to map is not marked for reflection. You need"
          " to anotate it. Please check docs for how to ");
      throw e;
    }
    return qualifiedName;
  }
}
