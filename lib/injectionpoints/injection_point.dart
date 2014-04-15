part of robotlegs_di;

abstract class InjectionPoint 
{
	//-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
  InjectionPoint next;
  InjectionPoint last;
  
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
  
	void applyInjection(IInjector injector, dynamic target, Type type);
}