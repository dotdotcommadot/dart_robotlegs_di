part of robotlegs_di_example;

class Shop {

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	@inject
	Product product;

	@inject
	Product otherProduct;

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
		print("Shop::onPostConstruct: " + otherProduct.toString());
	}

	@preDestroy
	void onPreDestroy() 
	{
		print("Shop::onPreDestroy");
	}

	@inject
	void injectedMethod() 
	{
		print("Shop::injectedMethod");
	}
}