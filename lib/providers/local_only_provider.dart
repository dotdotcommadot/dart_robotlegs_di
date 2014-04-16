part of robotlegs_di;

class LocalOnlyProvider extends ForwardingProvider
{
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	LocalOnlyProvider(IProvider provider) : super(provider);
}