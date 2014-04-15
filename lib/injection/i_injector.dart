part of robotlegs_di;

abstract class IInjector 
{

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	set parentInjector(IInjector value);
	get parentInjector;
	
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