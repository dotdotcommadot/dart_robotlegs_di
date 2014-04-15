part of robotlegs_di;

class TypeDescriptor {
	
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	InjectionPoint injectionPoints;
	ConstructorInjectionPoint constructorInjectionPoint;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	TypeDescriptor( [bool useDefaultConstructor = true] ) {
		if( useDefaultConstructor )
			constructorInjectionPoint = new NoParamsConstructorInjectionPoint();
	}
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	void addInjectionPoint( InjectionPoint injectionPoint ) {
		
		if( injectionPoints != null )
		{
			injectionPoints.last.next = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
		else
		{
			injectionPoints = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
	}
}