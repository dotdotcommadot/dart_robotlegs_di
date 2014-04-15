part of robotlegs_di_example;

class Shop {

  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	@inject
	IProduct product;
	
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
	void onPostConstruct() {
		print("post construct");
	}

	@preDestroy
	void onPreDestroy() {
		print("pre destroy");
	}

	@inject
	void injectMethod() {
		print("inject method");
	}
}