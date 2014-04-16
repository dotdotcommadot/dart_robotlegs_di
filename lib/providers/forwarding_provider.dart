part of robotlegs_di;

class ForwardingProvider implements IProvider
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	IProvider provider;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	ForwardingProvider(this.provider);
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
  dynamic apply(IInjector injector, Type type, Map injectParameters)
  {
  	return provider.apply(injector, type, injectParameters);
  }
  
  void destroy()
  {
  	provider.destroy();
  }
}