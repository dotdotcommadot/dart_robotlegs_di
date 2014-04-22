part of robotlegs_di_test;

instantiationTestCase()
{
	IInjector injector;
	
	test('Mapping Class', ()
	{
		injector = new Injector();	
		injector.map(Clazz);
		injector.map(String).toValue('');
		
		var myClazz = injector.getInstance(Clazz);
    expect(myClazz, isNotNull);
	});

	test('Mapping Class To Interface', ()
	{
		injector = new Injector();
		injector.map(InterfaceClass).toType(Clazz);
		injector.map(String).toValue('');
		
		var myClazz = injector.getInstance(InterfaceClass);
		expect(myClazz, isNotNull);
	});

	test('Mapping Class To Abstract Class', ()
	{
		injector = new Injector();
		injector.map(AbstractClazz).toType(Clazz);
		injector.map(String).toValue('');
		
		var myClazz = injector.getInstance(AbstractClazz);
		expect(myClazz, isNotNull);
	});
}