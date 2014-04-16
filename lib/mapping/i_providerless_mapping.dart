part of robotlegs_di;

abstract class IProviderlessMapping
{
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	IUnsealedMapping toType(Type type);

	IUnsealedMapping toValue(dynamic value);

	IUnsealedMapping toSingleton(Type type);

	IUnsealedMapping asSingleton();

	IUnsealedMapping toProvider(IProvider provider);

	dynamic seal();
}