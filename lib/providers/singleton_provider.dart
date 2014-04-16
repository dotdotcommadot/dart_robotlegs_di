part of robotlegs_di;

class SingletonProvider implements IProvider
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	IInjector _creatingInjector;
	Type _responseType ;
	dynamic _response;
	bool _destroyed;

	//-----------------------------------
	//
	// Constructor
	//
	//-----------------------------------
	
	SingletonProvider(this._creatingInjector, this._responseType );

	//-----------------------------------
	//
	// Public Methods
	//
	//-----------------------------------
  
	dynamic apply(IInjector injector, Type type, Map injectParameters) 
	{
		if (_response == null)
			_response = reflectClass(type).newInstance(new Symbol(''), []).reflectee;
		
  	return _response;
  }
  
  void destroy() 
  {
  	_destroyed = true;
  	if (_response == null)
  		return;
  	
  	TypeDescriptor descriptor = _creatingInjector.getTypeDescriptor(_responseType);
  	PreDestroyInjectionPoint preDestroyInjectonPoint = descriptor.preDestroyMethods;
  	while (preDestroyInjectonPoint != null)
  	{
  		preDestroyInjectonPoint.applyInjection(_creatingInjector, _response, _responseType);
  		preDestroyInjectonPoint = preDestroyInjectonPoint.next;
  	}
  	_response = null;
  }
}