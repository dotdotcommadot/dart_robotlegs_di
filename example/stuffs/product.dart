part of robotlegs_di_example;

class Product implements IProduct {
	
	String param;
	
// Constructor
	Product();
	
	/*// Constructor with parameters
	@inject
	Product.withParamsConstructor( String param ){ 
		this.param = param; 
	}

	// Constructor without parameters
	@inject
	Product.withoutParamsConstructor(){ 
		
	}*/
	
	@postConstruct
	void postConstructMethod() {
		print( "postConstructMethod" );
	}

	/*@PostConstruct( order: 10)
	void orderedPostConstructMethod() {
		
	}*/

	@preDestroy
	void preDestroyMethod() {
		print( "preDestroyMethod" );
	}

	/*@PreDestroy(order: 10)
	void orderedPreDestroyMethod() {
		
	}*/
	
	@inject
	String getParam() {
		return param;
	}

	/*@inject
	void withPositionalParamsMethod( String paramOne ) {

	}

	@inject
	void withNamedParamsMethod( {param} ) {
		
	}*/

	@inject
	void withoutParamsMethod() {
		print( "withoutParamsMethod" );
	}
	
	@inject
	void interfaceMethod() {
		print( "interfaceMethod" );
	}
	
	@Inject(name: "myNamedInjectionMethod")
	void namedInjectionMethod() {
		print( "namedInjectionMethod" );
	}
}