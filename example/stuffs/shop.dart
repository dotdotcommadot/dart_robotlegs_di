part of robotlegs_di_example;

class Shop {

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	@inject
	Product product;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	Shop();
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	@postConstruct
	void onPostConstruct() 
	{
		print("Shop::onPostConstruct: " + product.toString());
	}

	@preDestroy
	void onPreDestroy() 
	{
		print("Shop::onPreDestroy");
	}

	@inject
	void injectMethod() 
	{
		print("Shop::injectMethod");
	}
}