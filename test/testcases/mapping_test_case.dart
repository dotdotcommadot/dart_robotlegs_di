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

mappingTestCase()
{
	IInjector injector;
	
	setUp(() 
	{
		injector = new Injector();	
	});
	
	tearDown(() 
	{
		injector = null;
	});
	
	test('Mapping To Value', () 
	{
		injector.map(String).toValue("abcABC-123");
		injector.map(InjectedClazz);
		injector.map(Clazz);
		
		Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.myInjectedString, equals("abcABC-123"));
	});
	
	test('Mapping To Type', () 
	{
		injector.map(InterfaceClazz).toType(Clazz);
		injector.map(String).toValue("abcABC-123");
		injector.map(InjectedClazz);
		
		InterfaceClazz myInterfaceClazz = injector.getInstance(InterfaceClazz);
		expect(myInterfaceClazz, isNotNull);
	});

	test('Mapping As Singleton', () 
	{
		injector.map(InjectedClazz).asSingleton();
		injector.map(String).toValue("abcABC-123");
		injector.map(Clazz);
		
		Clazz myClazz = injector.getInstance(Clazz);
		expect(myClazz.myInjectedClazz, isNotNull);
		expect(myClazz.firstMethodWithParametersValue, isNotNull);
		expect(identical(myClazz.firstMethodWithParametersValue, myClazz.myInjectedClazz), isTrue);
	});
}