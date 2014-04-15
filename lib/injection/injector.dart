part of robotlegs_di;

class Injector implements IInjector 
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	Injector _parentInjector;
	set parentInjector(IInjector value) => _parentInjector = parentInjector;
	get parentInjector => _parentInjector;

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
	
	Injector();
	
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