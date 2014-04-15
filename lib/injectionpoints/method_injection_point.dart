part of robotlegs_di;

class MethodInjectionPoint extends InjectionPoint {
	
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	Symbol method;
	bool isOptional;
	
	List<dynamic> positionalArguments;
	Map<Symbol, dynamic> namedArguments;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	MethodInjectionPoint( this.method, this.positionalArguments, this.namedArguments  );
	
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	void applyInjection( Injector injector, Object target, Type targetType ) {
		
		reflect( target ).invoke( method, positionalArguments, namedArguments);
	}
}