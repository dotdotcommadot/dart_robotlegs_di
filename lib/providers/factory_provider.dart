part of robotlegs_di;

class FactoryProvider implements IProvider
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Type _factoryType;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	FactoryProvider(this._factoryType);
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	dynamic apply(IInjector injector, Type type, Map injectParameters)
	{
		return (injector.getInstance(_factoryType) as IProvider).apply(injector, type, injectParameters);
	}
    
  void destroy()
  {
  	
  }
}