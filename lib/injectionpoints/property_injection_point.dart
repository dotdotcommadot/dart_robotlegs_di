part of robotlegs_di;

class PropertyInjectionPoint extends InjectionPoint 
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	String _mappingId;
  
	Symbol _property;
  
	bool _optional;
  
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
  
	PropertyInjectionPoint(this._mappingId, this._property, this._optional);
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	@override
  void applyInjection(IInjector injector, dynamic target, Type type)
  {
    IProvider provider = injector._getProvider(_mappingId);
    
    if (provider == null)
    {
    	if (_optional)
      	return;
    	
    	throw(new InjectorMissingMappingError(
    		'Injector is missing a mapping to handle injection into property "' +
    		_property.runtimeType.toString() + '" of object "' + target + '" with type "' +
    		type.runtimeType.toString() + '". Target dependency: "' + _mappingId + '"'));
    }
    
    // TODO: figure out injectParameters;
		var instance = provider.apply(injector, type, new Map());
    
    InstanceMirror instanceMirror = reflect(target);
    instanceMirror.setField(_property, instance);
  }
}