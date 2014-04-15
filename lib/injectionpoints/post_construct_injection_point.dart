part of robotlegs_di;

class PostConstructInjectionPoint extends OrderedInjectionPoint {
	
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	PostConstructInjectionPoint( 
			Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order )
      : super( method, positionalArguments, namedArguments, order );
}