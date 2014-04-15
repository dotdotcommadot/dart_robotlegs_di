part of robotlegs_di;

class PropertyInjectionPoint extends InjectionPoint {
	
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
  
	PropertyInjectionPoint( this._mappingId, this._property, this._optional  ) {
		
	}
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
  void applyInjection( IInjector injector, dynamic target, Type type )
  {
    IProvider provider = injector._getProvider( _mappingId );
    
    if ( provider == null )
    {
    	if( _optional )
      	return;
    	
    	print( 'Injector is missing a mapping to handle injection into property ${_property.toString()} of object ${target}' );
    	
      /*throw(new InjectorMissingMappingError(
          'Injector is missing a mapping to handle injection into property "' +
          _propertyName.toString() + '" of object "' + target + '" with type "' +
          targetType.toString() +
          '". Target dependency: "' + _mappingId + '"'));*/
    }
    
		var instance = provider.apply( injector, type );
    
    InstanceMirror instanceMirror = reflect( target );
    instanceMirror.setField( _property, instance );
  }
}