part of robotlegs_di_test;

class ClazzTwo
{
	String injectedString;
	
	ClazzTwo(String _injectedString)
	{
		injectedString = _injectedString;
	}

	ClazzTwo.named()
	{
		injectedString = "named";
	}
}