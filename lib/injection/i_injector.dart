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
  
  Stream get onPostMappingCreated;
  
  Stream get onPostMappingChanged;

  Stream get onPostMappingRemoved;

  Stream get onPreConstruct;

  Stream get onPostConstruct;
  
	//-----------------------------------
	// ParentInjector
	//-----------------------------------
	
	set parentInjector(IInjector value);
	IInjector get parentInjector;
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	InjectionMapping map(Type type, [String name = '']);
	
	void unmap(Type type, [String name = '']);
	
	void injectInto(dynamic target);

	dynamic getInstance(Type type, [String name = '']);

	dynamic getOrCreateNewInstance(Type type, [String name = '']);
	
	dynamic instantiateUnMapped(Type type);

	dynamic satisfies(Type type, [String name = '']);
	
	void teardown();

  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	IProvider _getProvider(String _mappingId);
}