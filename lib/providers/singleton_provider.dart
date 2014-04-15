part of robotlegs_di;

class SingletonProvider implements IProvider
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	IInjector injector;
	Type type;
	
	dynamic _instance;

	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	SingletonProvider( IInjector injector, Type type );

	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply( IInjector injector, Type type ) {
		
		if( _instance == null )
			_instance = reflectClass( type ).newInstance( new Symbol(''), [] ).reflectee;
		
  	return _instance;
  }
  
  void destroy() {
  	
  }
}