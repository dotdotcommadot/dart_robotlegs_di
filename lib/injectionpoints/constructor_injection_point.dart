part of robotlegs_di;

class ConstructorInjectionPoint extends MethodInjectionPoint 
{
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	ConstructorInjectionPoint(List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments)
		: super(new Symbol(""), positionalArguments, namedArguments);
	
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	dynamic createInstance(Type type, IInjector injector) 
	{
		return reflectClass(type).newInstance(method, positionalArguments, namedArguments).reflectee;
	}
}