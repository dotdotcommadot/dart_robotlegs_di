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

class Clazz extends AbstractClazz with MixinClazz implements InterfaceClazz
{
  //-----------------------------------
  //
  // Properties
  //
  //-----------------------------------
	
	@inject
	String myInjectedString;

	@Inject(name: 'hello', optional: true)
	String myInjectedHelloString;

	@inject
	InjectedClazz myInjectedClazz;
	
	String _mySetterInjectedString;
	
	@inject
	set mySetterInjectedString(String value) => _mySetterInjectedString = value;
	String get mySetterInjectedString => _mySetterInjectedString;
	
  //-----------------------------------
  // Injectable Methods
  //-----------------------------------
	
	bool hasRunFirstMethod = false;
	
	InjectedClazz firstMethodWithParametersValue;
	
  //-----------------------------------
  // Post-Construct Methods
  //-----------------------------------
	
	int postConstructOrder = 0;

	bool hasRunFirstPostConstructMethod = false;

	int firstPostConstructMethodOrder = 0;

	bool hasRunSecondPostConstructMethod = false;

	int secondPostConstructMethodOrder = 0;

	bool hasRunLastPostConstructMethod = false;

	int lastPostConstructMethodOrder = 0;
	
  //-----------------------------------
  // Pre-Destroy Methods
  //-----------------------------------
	
	int preDestroyOrder = 0;
	
	bool hasRunFirstPreDestroyMethod = false;
	
	int firstPreDestroytMethodOrder = 0;

	bool hasRunSecondPreDestroyMethod = false;
	
	int secondPreDestroytMethodOrder = 0;

	bool hasRunLastPreDestroyMethod = false;
	
	int lastPreDestroytMethodOrder = 0;
	
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
		firstPostConstructMethodOrder = postConstructOrder;
		postConstructOrder++;
	}

	@PostConstruct(order: 2)
	secondPostConstructMethod()
	{
		hasRunSecondPostConstructMethod = true;
    secondPostConstructMethodOrder = postConstructOrder;
    postConstructOrder++;
	}

	@postConstruct
	lastPostConstructMethod()
	{
		hasRunLastPostConstructMethod = true;
    lastPostConstructMethodOrder = postConstructOrder;
    postConstructOrder++;
	}
	
  //-----------------------------------
  // Pre-Destroy Methods
  //-----------------------------------
	
	@PreDestroy(order: 1)
	firstPreDestroyMethod()
	{
		hasRunFirstPreDestroyMethod = true;
		firstPreDestroytMethodOrder = preDestroyOrder;
		preDestroyOrder++;
	}

	@PreDestroy(order: 2)
	secondPreDestroyMethod()
	{
		hasRunSecondPreDestroyMethod = true;
		secondPreDestroytMethodOrder = preDestroyOrder;
    preDestroyOrder++;
	}

	@preDestroy
	lastPreDestroyMethod()
	{
		hasRunLastPreDestroyMethod = true;
		lastPreDestroytMethodOrder = preDestroyOrder;
    preDestroyOrder++;
	}
}