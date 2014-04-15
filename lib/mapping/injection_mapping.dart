part of robotlegs_di;

class InjectionMapping {
	
	String mappingId;
	Type type;
	String name;
	IInjector injector;
	IProvider provider;
	
	InjectionMapping( this.mappingId, this.injector, this.type, this.name ) {
		toType( type );
	}
	
	void toType( Type type ) {
		provider = new TypeProvider( type );
	}

	void toValue( dynamic value ) {
		provider = new ValueProvider( value );
	}
	
	void asSingleton() {
		provider = new SingletonProvider( injector, this.type );
  }
}