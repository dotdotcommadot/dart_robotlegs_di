/*
* Copyright (c) 2014 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

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