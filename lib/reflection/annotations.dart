part of robotlegs_di;

//-----------------------------------
// inject
//-----------------------------------

const Inject inject = const Inject();

class Inject {
	
	final String name;
	final bool optional;
	
  const Inject( {this.name : "", this.optional : false} );
}

//-----------------------------------
// postConstruct
//-----------------------------------

const PostConstruct postConstruct = const PostConstruct();

class PostConstruct {
	
	final String name;
	final int order;
	
	const PostConstruct( {this.name : "", this.order : 99999} );
}

//-----------------------------------
// preDestroy
//-----------------------------------

const PreDestroy preDestroy = const PreDestroy();

class PreDestroy {
	
	final String name;
	final int order;
	
	const PreDestroy( {this.name : "", this.order : 99999} );
}