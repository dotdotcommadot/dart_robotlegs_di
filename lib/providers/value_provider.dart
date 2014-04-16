part of robotlegs_di;

class ValueProvider implements IProvider 
{
	//-----------------------------------
	//
	// Private Properties
	//
	//-----------------------------------
	
	dynamic _value;
	
	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	ValueProvider(this._value);
	
	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply(IInjector injector, Type type, Map injectParameters) 
	{
  	return _value;
  }
  
  void destroy() 
  {
  }
}