part of robotlegs_di;

class Injector implements IInjector 
{
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
  final StreamController _onPostInstantiatedController = new StreamController();

  Stream _onPreMappingCreated;
  Stream get onPreMappingCreated => _onPreMappingCreated;
  final StreamController _onPreMappingCreatedController = new StreamController();

  Stream _onPreMappingChanged;
  Stream get onPreMappingChanged => _onPreMappingChanged;
  final StreamController _onPreMappingChangedController = new StreamController();

  Stream _onPostMappingCreated;
  Stream get onPostMappingCreated => _onPostMappingCreated;
  final StreamController _onPostMappingCreatedController = new StreamController();

  Stream _onPostMappingChanged;
  Stream get onPostMappingChanged => _onPostMappingChanged;
  final StreamController _onPostMappingChangedController = new StreamController();

  Stream _onPostMappingRemoved;
  Stream get onPostMappingRemoved => _onPostMappingRemoved;
  final StreamController _onPostMappingRemovedController = new StreamController();

  Stream _onPreConstruct;
  Stream get onPreConstruct => _onPreConstruct;
  final StreamController _onPreConstructController = new StreamController();

  Stream _onPostConstruct;
  Stream get onPostConstruct => _onPostConstruct;
  final StreamController _onPostConstructController = new StreamController();
	
	//-----------------------------------
	// ParentInjector
	//-----------------------------------
  
	IInjector _parentInjector;
	set parentInjector(IInjector value) => _parentInjector = parentInjector;
	IInjector get parentInjector => _parentInjector;

  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<String, InjectionMapping> _mappings = new Map<String, InjectionMapping>();
	
	Reflector _reflector = new Reflector();
	
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
	 	
	 	
	 	_onPostInstantiatedController.add("");
	}
  	
  void unmap(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	InjectionMapping mapping = _mappings[mappingId];
  	
  	_mappings.remove(mappingId);
  }
  
	void injectInto(dynamic target )
	{
		final Type type = _reflector.getType(target);
		_applyinjectionPoints(target, type, _reflector.getDescriptor(type));
	}

  // TRIGGER INJECTION POINTS
  dynamic getInstance(Type type, [String name = '']) 
  {
  	final String mappingId = _getMappingId( type, name );
  	
  	IProvider provider = _mappings[mappingId].provider;
  	TypeDescriptor typeDescription = _reflector.getDescriptor(type);
  	InjectionMapping mapping = _mappings[mappingId];
  	
  	return mapping.provider.apply(this, type);
  }
  
  dynamic getOrCreateNewInstance(Type type, [String name = ''])
  {
  	return satisfies(type) && getInstance(type) || instantiateUnMapped(type);
  }
  
  dynamic instantiateUnMapped(Type type) 
  {
  	TypeDescriptor typeDescription = _reflector.getDescriptor(type);
  	dynamic instance = typeDescription.constructorInjectionPoint.createInstance(type, this);
  	_applyinjectionPoints(instance, type, typeDescription);
  	
  	return instance;
  }
  
  bool satisfies(Type type, [String name = ''])
  {
  	final String mappingId = _getMappingId(type, name);
  	return _getProvider(mappingId, true) != null;
  }
  
  void teardown()
  {
  	/*_mappings.forEach((String key, InjectionMapping mapping)
		{
  		mapping.getProvider().destroy();
		});
  	_managedObject.foreach((String key, dynamic instance)
		{
  		destroyInstance(instance)
		});
  	_mappings = new Map<String, InjectionMapping>();
	  _mappingsInProcess = new Map();
	  _managedObjects = new Map();
	  _fallbackProvider = null;
	  _blockParentFallbackProvider = false;*/
  }
  
  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
  
  InjectionMapping _createMapping(String mappingId, Type type, String name) 
  {
  	final String mappingId = _getMappingId(type, name);
  	
  	final InjectionMapping mapping = new InjectionMapping(mappingId, this, type, name);
  	_mappings[mappingId] = mapping;
  	
  	return mapping;
  }
  
  IProvider _getProvider(String mappingId, [fallbackToDefault= true]) 
  {
  	return _mappings[mappingId].provider;
  }
  
  // TODO
  void _applyinjectionPoints(dynamic instance, Type type, TypeDescriptor typeDescription) 
  {
  	InjectionPoint injectionPoint = typeDescription.injectionPoints;
  	
  	while (injectionPoint != null)
  	{
  		injectionPoint.applyInjection(this, instance, type);
      injectionPoint = injectionPoint.next;
  	}
  }
}