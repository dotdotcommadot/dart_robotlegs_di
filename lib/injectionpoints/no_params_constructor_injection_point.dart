part of robotlegs_di;

class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint 
{
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	NoParamsConstructorInjectionPoint() : super( [], null );
	
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	@override
	dynamic createInstance(Type type, IInjector injector)
	{
		return reflectClass(type).newInstance(method, []).reflectee;
	}
}