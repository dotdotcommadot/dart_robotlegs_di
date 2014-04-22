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

part of robotlegs_di_test;

class Clazz extends AbstractClazz implements InterfaceClass
{
  //-----------------------------------
  //
  // Properties
  //
  //-----------------------------------
	
	@inject
	String myInjectedString;

	@inject
	InjectedClazz myInjectedClazz;
	
  //-----------------------------------
  // Injectable Methods
  //-----------------------------------
	
	bool hasRunFirstMethod = false;
	
	InjectedClazz firstMethodWithParametersValue;
	
  //-----------------------------------
  // Post-Construct Methods
  //-----------------------------------

	bool hasRunFirstPostConstructMethod = false;

	bool hasRunSecondPostConstructMethod = false;

	bool hasRunLastPostConstructMethod = false;
	
  //-----------------------------------
  // Pre-Destroy Methods
  //-----------------------------------
	
	bool hasRunFirstPreDestroyMethod = false;

	bool hasRunSecondPreDestroyMethod = false;

	bool hasRunLastPreDestroyMethod = false;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	Clazz();
	
  //-----------------------------------
  //
  // Methods
  //
  //-----------------------------------
	
  //-----------------------------------
  // Injectable Methods
  //-----------------------------------
	
	@inject
	firstMethod()
	{
		hasRunFirstMethod = true;
	}

	@inject
	firstMethodWithParameters(InjectedClazz value)
	{
		this.firstMethodWithParametersValue = value;
	}
	
  //-----------------------------------
  // Post-Construct Methods
  //-----------------------------------

	@PostConstruct(order: 1)
	firstPostConstructMethod()
	{
		hasRunFirstPostConstructMethod = true;
	}

	@PostConstruct(order: 2)
	secondPostConstructMethod()
	{
		hasRunSecondPostConstructMethod = true;
	}

	@postConstruct
	lastPostConstructMethod()
	{
		hasRunLastPostConstructMethod = true;
	}
	
  //-----------------------------------
  // Pre-Destroy Methods
  //-----------------------------------
	
	@PreDestroy(order: 1)
	firstPreDestroyMethod()
	{
		hasRunFirstPreDestroyMethod = true;
	}

	@PreDestroy(order: 2)
	secondPreDestroyMethod()
	{
		hasRunSecondPreDestroyMethod = true;
	}

	@preDestroy
	lastPreDestroyMethod()
	{
		hasRunLastPreDestroyMethod = true;
	}
}