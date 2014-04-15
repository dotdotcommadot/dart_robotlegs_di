part of robotlegs_di;

class TypeProvider implements IProvider 
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	Type targetType;
	
	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	TypeProvider(this.targetType);

	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply(IInjector injector, Type type) 
	{
		return injector.instantiateUnMapped(targetType);
  }
  
  void destroy() 
  {
  }
}