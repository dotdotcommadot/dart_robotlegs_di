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

class TypeDescriptor 
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	InjectionPoint injectionPoints;
	
	ConstructorInjectionPoint constructorInjectionPoint;
	
	PreDestroyInjectionPoint preDestroyMethods;
	
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	bool _postConstructAdded;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	TypeDescriptor([bool useDefaultConstructor = true]) 
	{
		if (useDefaultConstructor)
			constructorInjectionPoint = new NoParamsConstructorInjectionPoint();
	}
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	TypeDescriptor setConstructor(
		[positionalArguments = null, 
		 namedArguments = null]
	)
	{
		constructorInjectionPoint = new ConstructorInjectionPoint(positionalArguments, namedArguments);
		return this;
	}
	
	TypeDescriptor addProperty(
	   Symbol property,
	   Type type,
	   [String injectionName = '',
	    bool optional = false]
	)
	{
		if (_postConstructAdded)
			throw new InjectorError('Can\'t add injection point after post construct method');
		
		addInjectionPoint(new PropertyInjectionPoint(Injector._getMappingId(type, injectionName), property, optional));
		
		return this;
	}
	
	TypeDescriptor addMethod(
		Symbol method,
		[positionalArguments = null, 
     namedArguments = null,
     optional = false]
	)
	{
		if (_postConstructAdded)
    	throw new InjectorError('Can\'t add injection point after post construct method');
		
		addInjectionPoint(new MethodInjectionPoint(method, positionalArguments, namedArguments));
		
		return this;
	}
	
	TypeDescriptor addPostConstructMethod(
		Symbol method,
		[positionalArguments = null, 
		 namedArguments = null]
	)
	{
		_postConstructAdded = true;
		
		addInjectionPoint(new PostConstructInjectionPoint(method, positionalArguments, namedArguments, 0));
		
		return this;
	}

	TypeDescriptor addPreDestroyMethod(
	  Symbol method,
	  [positionalArguments = null, 
	   namedArguments = null]
	)
	{
		final PreDestroyInjectionPoint injectionPoint = new PreDestroyInjectionPoint(method, positionalArguments, namedArguments, 0);
		
		addPreDestroyInjectionPoint(injectionPoint);
		
		return this;
	}
	
	void addInjectionPoint(InjectionPoint injectionPoint) 
	{
		if (injectionPoints != null)
		{
			injectionPoints.last.next = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
		else
		{
			injectionPoints = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
	}
	
	addPreDestroyInjectionPoint(PreDestroyInjectionPoint injectionPoint)
	{
		if (preDestroyMethods != null)
		{
			preDestroyMethods.last.next = injectionPoint;
    	preDestroyMethods.last = injectionPoint;
		}
		else
		{
			preDestroyMethods = injectionPoint;
    	preDestroyMethods.last = injectionPoint;
		}
	}
}