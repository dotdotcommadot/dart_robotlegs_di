part of robotlegs_di;

class PreDestroyInjectionPoint extends OrderedInjectionPoint {
	
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	PreDestroyInjectionPoint(
		Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order )
	  : super( method, positionalArguments, namedArguments, order );
}