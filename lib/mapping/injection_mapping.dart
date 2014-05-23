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

class InjectionMapping implements IProviderlessMapping, IUnsealedMapping
{
	//-----------------------------------
	//
	// Public Properties
	//
	//-----------------------------------
	
	bool get isSealed => _sealed;

	bool get hasProvider => _creatingInjector._providerMappings[_mappingId] != null;

	//-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Type _type;
	
	String _name;
	
	String _mappingId;

	IInjector _creatingInjector;

	IInjector _overridingInjector;
	
	bool _defaultProviderSet = false;
	
	IProvider provider;
	
	bool _soft = false;

	bool _local = false;

	bool _sealed = false;

	Symbol _sealKey;
	
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	InjectionMapping(this._mappingId, this._creatingInjector, this._type, this._name) 
	{
		_defaultProviderSet = true;
		_mapProvider(new TypeProvider(_type));
	}
	
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	IUnsealedMapping asSingleton()
	{
		toSingleton(_type);
		return this;
	}
	
	IUnsealedMapping toType(Type type, [Symbol constructor = const Symbol('')]) 
	{
		toProvider(new TypeProvider(type, constructor));
		return this;
	}
	
	IUnsealedMapping toSingleton(Type type)
	{
		toProvider(new SingletonProvider(_creatingInjector, type));
		return this;
	}

	IUnsealedMapping toValue(dynamic value) 
	{
		toProvider(new ValueProvider(value));
		return this;
	}
	
	IUnsealedMapping toProvider(IProvider provider)
	{
		if (_sealed)
			throw new InjectorError('Can\'t change a sealed mapping');
		
		if (hasProvider && provider != null && !_defaultProviderSet)
		{
			print('Warning: Injector already has a mapping for ' + _mappingId + '.\n ' +
			      'If you have overridden this mapping intentionally you can use ' +
            '"injector.unmap()" prior to your replacement mapping in order to ' +
            'avoid seeing this message.');
		}
			
			//TODO add name and "this" to event
			_creatingInjector._onMappingOverrideController.add(_type);
			_creatingInjector._onPreMappingChangedController.add('');
	    _defaultProviderSet = false;
	    _mapProvider(provider);
	    _creatingInjector._onPostMappingChangedController.add('');
	    return this;
	}
	
	IUnsealedMapping toProviderOf(Type type, [String name = ''])
	{
		final IProvider provider = _creatingInjector.getMapping(type).getProvider();
		toProvider(provider);
		return this;
	}
	
	IProviderlessMapping softly()
	{
		if (_sealed)
			throw new InjectorError('Can\'t change a sealed mapping');
		
		if (!_soft)
		{
			final IProvider provider = getProvider();
			_creatingInjector._onPreMappingChangedController.add('');
	    _soft = true;
	    _mapProvider(provider);
	    _creatingInjector._onPostMappingChangedController.add('');
		}
		return this;
	}
	
	IProviderlessMapping locally()
	{
		if (_sealed)
			throw new InjectorError('Can\'t change a sealed mapping');
			
		if (_local)
			return this;
		
		final IProvider provider = getProvider();
		_creatingInjector._onPreMappingChangedController.add('');
	  _local = true;
	  _mapProvider(provider);
	  _creatingInjector._onPostMappingChangedController.add('');
	  return this;
	}
	
	Symbol seal()
	{
		if (_sealed)
	  {
	  	throw new InjectorError('Mapping is already sealed.');
	  }
	  _sealed = true;
	  _sealKey = new Symbol("sealed");
	  return _sealKey;
	}
	
	InjectionMapping unseal(Symbol key)
	{
		if (!_sealed)
		{
			throw new InjectorError('Can\'t unseal a non-sealed mapping.');
		}
		if (key != _sealKey)
		{
			throw new InjectorError('Can\'t unseal mapping without the correct key.');
		}
		
		_sealed = false;
	  _sealKey = null;
	  return this;
	}
	
	
	IProvider getProvider()
	{
		IProvider provider = _creatingInjector._providerMappings[_mappingId];
		while (provider is ForwardingProvider)
		{
			provider = (provider as ForwardingProvider).provider;
		}
		return provider;
	}
	
	InjectionMapping setInjector(IInjector injector)
	{
		if (_sealed)
			throw new InjectorError('Can\'t change a sealed mapping');
		
		if (injector == _overridingInjector)
		{
			return this;
		}
		IProvider provider = getProvider();
		_overridingInjector = injector;
		_mapProvider(provider);
		return this;
	}
	
	//-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	void _mapProvider(IProvider provider)
	{
		if (_soft)
		{
			provider = new SoftProvider(provider);
		}
		
		if (_local)
		{
			provider = new LocalOnlyProvider(provider);
		}
		
		if (_overridingInjector != null)
		{
			provider = new InjectorUsingProvider(_overridingInjector, provider);
		}
		_creatingInjector._providerMappings[_mappingId] = provider;
	}
}