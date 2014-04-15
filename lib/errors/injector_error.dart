part of robotlegs_di;

class InjectorError extends Error
{
	//-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	final String message;
	
	//-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	InjectorError([this.message = ""]);
      
	//-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
  String toString() 
  {
    if (message != null) 
      return "Injector Error: $message";

    return "Injector Error";
  }
}