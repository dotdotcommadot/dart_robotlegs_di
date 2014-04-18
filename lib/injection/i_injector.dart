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

abstract class IInjector 
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	//-----------------------------------
	// Streams
	//-----------------------------------
	
  Stream get onPostInstantiated;

  Stream get onPreMappingCreated;

  Stream get onPreMappingChanged;
  StreamController _onPreMappingChangedController;
  
  Stream get onPostMappingCreated;
  
  Stream get onPostMappingChanged;
  StreamController _onPostMappingChangedController;

  Stream get onPostMappingRemoved;

  Stream get onPreConstruct;

  Stream get onPostConstruct;
  
  Stream get onMappingOverride;
  StreamController _onMappingOverrideController;
  
	//-----------------------------------
	// ParentInjector
	//-----------------------------------
	
	set parentInjector(IInjector value);
	IInjector get parentInjector;
	
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<String, IProvider> _providerMappings;
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	InjectionMapping map(Type type, [String name = '']);
	
	void unmap(Type type, [String name = '']);
	
	bool satisfies(Type type, [String name = '']);
	
	bool satisfiesDirectly(Type type, [String name = '']);
	
	InjectionMapping getMapping(Type type, [String name = '']);
	
	void injectInto(dynamic target);

	dynamic getInstance(Type type, [String name = '']);

	dynamic getOrCreateNewInstance(Type type, [String name = '']);
	
	dynamic instantiateUnMapped(Type type);
	
	void destroyInstance(dynamic instance);

	void teardown();
	
	IInjector createChildInjector();
	
	void addTypeDescriptor(Type type, TypeDescriptor descriptor);
	
	TypeDescriptor getTypeDescriptor(Type type);
	
	bool hasMapping(Type type, [String name = '']);

  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	void _purgeInjectionPointsCache();
	
	bool _canBeInstantiated(Type type);
	
	IProvider _getProvider(String _mappingId);
	
	IProvider _getDefaultProvider(String mappingId, bool consultParents);
	
	InjectionMapping _createMapping(String mappingId, Type type, String name);
	
	void _applyinjectionPoints(dynamic instance, Type type, TypeDescriptor typeDescriptor);
}