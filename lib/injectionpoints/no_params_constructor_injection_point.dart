part of robotlegs_di;

class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint 
{
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	NoParamsConstructorInjectionPoint()
		: super( new Symbol(''), [], null );
}