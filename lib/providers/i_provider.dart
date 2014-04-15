part of robotlegs_di;

abstract class IProvider
{
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
  
  dynamic apply(IInjector injector, Type type);
  
  void destroy();
}