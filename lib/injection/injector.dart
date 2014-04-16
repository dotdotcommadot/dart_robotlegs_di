part of robotlegs_di;

class Injector implements IInjector 
{
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
  StreamController _onPreMappingChangedController = new StreamController();

  Stream _onPostMappingCreated;
  Stream get onPostMappingCreated => _onPostMappingCreated;
  StreamController _onPostMappingCreatedController = new StreamController();

  Stream _onPostMappingChanged;
  Stream get onPostMappingChanged => _onPostMappingChanged;
  StreamController _onPostMappingChangedController = new StreamController();

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
  StreamController _onMappingOverrideController = new StreamController();
	
	//-----------------------------------
	// ParentInjector
	//-----------------------------------
  
	IInjector _parentInjector;
	set parentInjector(IInjector value) => _parentInjector = value;
	IInjector get parentInjector => _parentInjector;
	
	IFallbackProvider _fallbackProvider;
	set fallbackProvider(IFallbackProvider value) => _fallbackProvider = value;
	IFallbackProvider get fallbackProvider => _fallbackProvider;

	bool _blockParentFallbackProvider;
	set blockParentFallbackProvider(bool value) => _blockParentFallbackProvider = value;
	bool get blockParentFallbackProvider => _blockParentFallbackProvider;

  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<String, IProvider> _providerMappings = new Map<String, IProvider>();
	
	final Reflector _reflector = new Reflector();
	
	Map<String, bool> _mappingsInProcess = new Map<String, bool>();

	Map<String, InjectionMapping> _mappings = new Map<String, InjectionMapping>();

	Map _managedObjects = new Map();
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	Injector()
	{
		_onPostInstantiated 	= _onPostInstantiatedController.stream.asBroadcastStream();
		_onPreMappingCreated 	= _onPreMappingCreatedController.stream.asBroadcastStream();
		_onPreMappingChanged 	= _onPreMappingChangedController.stream.asBroadcastStream();
		_onPostMappingCreated = _onPostMappingCreatedController.stream.asBroadcastStream();
		_onPostMappingChanged = _onPostMappingChangedController.stream.asBroadcastStream();
		_onPostMappingRemoved = _onPostMappingRemovedController.stream.asBroadcastStream();
		_onPreConstruct 			= _onPreConstructController.stream.asBroadcastStream();
		_onPostConstruct 			= _onPostConstructController.stream.asBroadcastStream();
		_onMappingOverride 		= _onMappingOverrideController.stream.asBroadcastStream();
	}
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	InjectionMapping map(Type type, [String name = '']) 
	{
		final String mappingId = _getMappingId(type, name);
	 	
	 	if (_mappings[mappingId] == null)
	 		return _createMapping(mappingId, type, name);
	 	else 
	 		return _mappings[mappingId];
	}
  	
  void unmap(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	InjectionMapping mapping = _mappings[mappingId];
  	
  	if( (mapping != null) && mapping.isSealed)
  	{
  		throw new InjectorError('can\'t unmap a sealed mapping');
  	}
  	if (mapping == null)
  	{
  		throw new InjectorError('Error while removing an injector mapping: ' +
				'No mapping defined for dependency ' + mappingId);
  	}
  	mapping.getProvider().destroy();
  	_mappings.remove(mappingId);
  	_providerMappings.remove(mappingId);
  	
  	_onPostMappingRemovedController.add("");
  }
  
  bool satisfies(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	return _getProvider(mappingId, true) != null;
  }

  bool satisfiesDirectly(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	return hasDirectMapping(type, name) || _getDefaultProvider(mappingId, false) != null;
  }
  
  InjectionMapping getMapping(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	InjectionMapping mapping = _mappings[mappingId];
  	if (mapping == null)
  	{
  		throw new InjectorMissingMappingError('Error while retrieving an injector mapping: '
    		+ 'No mapping defined for dependency ' + mappingId);
  	}
  	return mapping;
  }
  
	void injectInto(dynamic target )
	{
		final Type type = _reflector.getType(target);
		_applyinjectionPoints(target, type, _reflector.getDescriptor(type));
	}

  dynamic getInstance(Type type, [String name = '', Type targetType = null]) 
  {
  	final String mappingId = _getMappingId(type, name);
  	IProvider provider = _getProvider(mappingId);
  	if (provider == null) provider = _getDefaultProvider(mappingId, true);
  	
  	if (provider != null)
  	{
  		final ConstructorInjectionPoint constructorInjectionPoint = _reflector.getDescriptor(type).constructorInjectionPoint;
  		return provider.apply(this, targetType, (constructorInjectionPoint != null)? constructorInjectionPoint.injectParameters : null);
  	}
  	
  	String fallbackMessage = (_fallbackProvider != null)
  			? "the fallbackProvider, '" + _fallbackProvider.toString() + "', was unable to fulfill this request."
  			: "the injector has no fallbackProvider.";
  	
  	throw new InjectorMissingMappingError('No mapping found for request ' + mappingId
  		+ ' and ' + fallbackMessage);
  }
  
  dynamic getOrCreateNewInstance(Type type, [String name = ''])
  {
  	dynamic instance;
  	if (satisfies(type))
  		instance = getInstance(type);
  	else
  		instance = instantiateUnMapped(type);
  	
  	return instance;
  }
  
  dynamic instantiateUnMapped(Type type) 
  {
  	if (!_canBeInstantiated(type))
  	{
  		throw new InjectorInterfaceConstructorError('Can\'t instantiate interface ' + type.toString());
  	}
  	TypeDescriptor typeDescription = _reflector.getDescriptor(type);
  	dynamic instance = typeDescription.constructorInjectionPoint.createInstance(type, this);
  	_onPostInstantiatedController.add("");
  	_applyinjectionPoints(instance, type, typeDescription);
  	
  	return instance;
  }
  
  void destroyInstance(dynamic instance)
  {
  	if (instance == null)
  		return;
  				
  	final Type type = _reflector.getType(instance);
  	final TypeDescriptor typeDescription = getTypeDescriptor(type);
  	
  	PreDestroyInjectionPoint preDestroyHook = typeDescription.preDestroyMethods;
  	
  	while (preDestroyHook != null)
  	{
  		 preDestroyHook.applyInjection(this, instance, type);
  		 preDestroyHook = preDestroyHook.next;
  	}
  }
  
  void teardown()
  {
  	_mappings.forEach((String key, InjectionMapping mapping)
		{
  		mapping.getProvider().destroy();
		});
  	
  	_managedObjects.forEach((String key, dynamic instance)
		{
  		destroyInstance(instance);
		});
  	
  	_mappings = new Map<String, InjectionMapping>();
	  _mappingsInProcess = new Map();
	  _managedObjects = new Map();
	  _fallbackProvider = null;
	  _blockParentFallbackProvider = false;
  }
  
  IInjector createChildInjector()
  {
  	IInjector injector = new Injector();
  	injector.parentInjector = this;
  	return injector;
  }
  
  void addTypeDescriptor(Type type, TypeDescriptor descriptor)
  {
  	_reflector.addDescriptor(type, descriptor);
  }
  
  TypeDescriptor getTypeDescriptor(Type type)
  {
  	return _reflector.getDescriptor(type);
  }
  
  bool hasMapping(Type type, [String name = ''])
  {
  	return _getProvider(_getMappingId(type, name)) != null;
  }

  bool hasDirectMapping(Type type, [String name = ''])
  {
  	return _mappings[_getMappingId(type, name)] != null;
  }
  
  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
  
  void _purgeInjectionPointsCache()
  {
  	INJECTION_POINTS_CACHE = new Map();
  }

  bool _canBeInstantiated(Type type)
  {
  	final TypeDescriptor descriptor = _reflector.getDescriptor(type);
  	return descriptor.constructorInjectionPoint != null;
  }
  
  IProvider _getProvider(String mappingId, [fallbackToDefault= true]) 
  {
  	IProvider softProvider;
  	Injector injector = this;
  	while (injector != null)
  	{
  		IProvider provider = _providerMappings[mappingId];
  		if (provider != null)
  		{
  			if (provider is SoftProvider)
  			{
  				softProvider = provider;
  				injector = injector.parentInjector;
  			}
  			if (provider is LocalOnlyProvider && injector != this)
  			{
  				injector = injector.parentInjector;
  			}
  			return provider;
  		}
  		injector = injector.parentInjector;
  	}
  	
  	if (softProvider != null)
  	{
  		return softProvider;
  	}
  	return fallbackToDefault ? _getDefaultProvider(mappingId, true) : null;
  }
  
  IProvider _getDefaultProvider(String mappingId, bool consultParents)
  {
  	/*if (_baseTypes.indexOf(mappingId) > -1)
	  {
	  	return null;
	  }*/
  	
  	if ((_fallbackProvider != null) && (_fallbackProvider.prepareNextRequest(mappingId) != null))
  	{
  		return _fallbackProvider;
  	}
  	
  	if (consultParents && !_blockParentFallbackProvider && (_parentInjector != null))
  	{
  		return _parentInjector._getDefaultProvider(mappingId, consultParents);
  	}
  	return null;
  }
  
  
  InjectionMapping _createMapping(String mappingId, Type type, String name) 
  {
  	if (_mappingsInProcess[mappingId] != null)
  	{
  		throw new InjectorError('Can\'t change a mapping from inside a listener to it\'s creation event');
  	}
  	
  	_mappingsInProcess[mappingId] = true;
  	
  	_onPreMappingCreatedController.add('');
  	
  	final InjectionMapping mapping = new InjectionMapping(mappingId, this, type, name);
  	
  	_mappings[mappingId] = mapping;
  	
  	final dynamic sealKey = mapping.seal();
  	
  	_onPostMappingCreatedController.add('');
  	
  	_mappingsInProcess.remove(mappingId);
  	
  	mapping.unseal(sealKey);
  	
  	return mapping;
  }
  
  void _applyinjectionPoints(dynamic instance, Type type, TypeDescriptor typeDescriptor) 
  {
  	InjectionPoint injectionPoint = typeDescriptor.injectionPoints;
  	
  	_onPreConstructController.add('');
  	
  	while (injectionPoint != null)
  	{
  		injectionPoint.applyInjection(this, instance, type);
      injectionPoint = injectionPoint.next;
  	}
  	
  	if (typeDescriptor.preDestroyMethods != null)
	  {
			_managedObjects[instance] = instance;
	  }
  	
  	_onPostConstructController.add('');
  }
  
  //-----------------------------------
  //
  // Private Static Methods
  //
  //-----------------------------------
	
  static String _getMappingId(Type type, String injectionName) 
  {
  	Symbol qualifiedNameSymbol = reflectClass( type ).qualifiedName;
  	String qualifiedName = MirrorSystem.getName( qualifiedNameSymbol );
  	return qualifiedName + "|" + injectionName;
  }
}