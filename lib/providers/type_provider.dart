part of robotlegs_di;

class TypeProvider implements IProvider 
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Type _responseType;
	
	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	TypeProvider(this._responseType);

	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply(IInjector injector, Type targetType, Map injectParameters) 
	{
		return injector.instantiateUnMapped(_responseType);
  }
  
  void destroy() 
  {
  }
}