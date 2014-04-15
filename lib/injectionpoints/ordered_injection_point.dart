part of robotlegs_di;

class OrderedInjectionPoint extends MethodInjectionPoint 
{
	//-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	int order;
	
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	OrderedInjectionPoint( 
		Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, this.order)
		: super(method, positionalArguments, namedArguments);
}