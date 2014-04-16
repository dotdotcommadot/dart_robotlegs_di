part of robotlegs_di;

abstract class IInjector 
{
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
  StreamController _onPreMappingChangedController;
  
  Stream get onPostMappingCreated;
  
  Stream get onPostMappingChanged;
  StreamController _onPostMappingChangedController;

  Stream get onPostMappingRemoved;

  Stream get onPreConstruct;

  Stream get onPostConstruct;
  
  Stream get onMappingOverride;
  StreamController _onMappingOverrideController;
  
	//-----------------------------------
	// ParentInjector
	//-----------------------------------
	
	set parentInjector(IInjector value);
	IInjector get parentInjector;
	
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<String, IProvider> _providerMappings;
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	InjectionMapping map(Type type, [String name = '']);
	
	void unmap(Type type, [String name = '']);
	
	bool satisfies(Type type, [String name = '']);
	
	bool satisfiesDirectly(Type type, [String name = '']);
	
	InjectionMapping getMapping(Type type, [String name = '']);
	
	void injectInto(dynamic target);

	dynamic getInstance(Type type, [String name = '']);

	dynamic getOrCreateNewInstance(Type type, [String name = '']);
	
	dynamic instantiateUnMapped(Type type);
	
	void destroyInstance(dynamic instance);

	void teardown();
	
	IInjector createChildInjector();
	
	void addTypeDescriptor(Type type, TypeDescriptor descriptor);
	
	TypeDescriptor getTypeDescriptor(Type type);
	
	bool hasMapping(Type type, [String name = '']);

  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	void _purgeInjectionPointsCache();
	
	bool _canBeInstantiated(Type type);
	
	IProvider _getProvider(String _mappingId);
	
	IProvider _getDefaultProvider(String mappingId, bool consultParents);
	
	InjectionMapping _createMapping(String mappingId, Type type, String name);
	
	void _applyinjectionPoints(dynamic instance, Type type, TypeDescriptor typeDescriptor);
}