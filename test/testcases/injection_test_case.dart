part of robotlegs_di_test;

injectionTestCase()
{
	IInjector injector;
	test('Injecting String', () {
		injector = new Injector();	
		
		injector.map(String).toValue("Hello World");
		injector.map(Clazz);
		
		Clazz myClazz = injector.getInstance(Clazz);
    expect(myClazz.helloWorld, equals("Hello World"));
	});
}