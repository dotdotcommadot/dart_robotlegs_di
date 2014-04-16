part of robotlegs_di;

class InjectorUsingProvider extends ForwardingProvider
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	IInjector injector;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	InjectorUsingProvider(this.injector, IProvider provider) : super(provider);
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	@override
  dynamic apply(IInjector injector, Type type, Map injectParameters)
  {
  	return provider.apply(injector, type, injectParameters);
  }
}