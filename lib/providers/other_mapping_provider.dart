part of robotlegs_di;

class OtherMappingProvider implements IProvider
{
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
	
  dynamic apply(IInjector injector, Type type, Map injectParameters)
  {
  	return _mapping.getProvider().apply(injector, type, injectParameters);
  }
  
  void destroy()
  {
  }
}