part of robotlegs_di;

abstract class InjectionPoint {
	
  InjectionPoint next;
  InjectionPoint last;
  
	void applyInjection( IInjector injector, dynamic target, Type type );
	
}