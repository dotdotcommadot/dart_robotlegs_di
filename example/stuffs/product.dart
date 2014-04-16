part of robotlegs_di_example;

class Product {
	
	Product();
	
	@postConstruct
	void postConstructMethod() 
	{
		print( "Product::postConstructMethod" );
	}

	@PostConstruct(order: 1)
	void firstPostConstructMethod() 
	{
		print( "Product::firstPostConstructMethod" );
	}

	@PostConstruct(order: 1)
	void secondPostConstructMethod() 
	{
		print( "Product::secondPostConstructMethod" );
	}

	@preDestroy
	void preDestroyMethod() 
	{
		print( "Product::preDestroyMethod" );
	}

	@PreDestroy(order: 1)
	void firstPreDestroyMethod() 
	{
		print( "Product::orderedPreDestroyMethod" );
	}

	@PreDestroy(order: 2)
	void secondPreDestroyMethod() 
	{
		print( "Product::secondPreDestroyMethod" );
	}
}