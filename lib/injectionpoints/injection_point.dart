part of robotlegs_di;

class InjectionPoint 
{
	//-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
  InjectionPoint next;
  InjectionPoint last;
  Map injectParameters;
  
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
  
  InjectionPoint();

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
  
	void applyInjection(IInjector injector, dynamic target, Type type)
	{
		
	}
}