part of robotlegs_di;

class Reflector 
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<Type, TypeDescriptor> descriptorsCache = new Map<Type, TypeDescriptor>();
	
	ConstructorInjectionPoint constructorInjectionPoint;
	
	List<PropertyInjectionPoint> propertyInjectionPoints; 
	
	List<MethodInjectionPoint> methodInjectionPoints; 
	
	List<PostConstructInjectionPoint> postConstructInjectionPoints; 
	
	List<PreDestroyInjectionPoint> preDestroyInjectionPoints; 
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	Reflector();
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	TypeDescriptor getDescriptor(Type type) 
	{
     if (descriptorsCache[type] == null)
    	 descriptorsCache[type] = createDescriptor(type);

     return descriptorsCache[type];
  }
	
	void addDescriptor(Type type, TypeDescriptor descriptor)
	{
		descriptorsCache[type] = descriptor;
	}
	
	Type getType(dynamic value)
	{
		return reflect(value).runtimeType;
	}
	
	TypeDescriptor createDescriptor(Type type) 
	{
		propertyInjectionPoints = new List<PropertyInjectionPoint>();
		methodInjectionPoints = new List<MethodInjectionPoint>();
		postConstructInjectionPoints = new List<PostConstructInjectionPoint>();
		preDestroyInjectionPoints = new List<PreDestroyInjectionPoint>();
		
		final TypeDescriptor typeDescriptor = new TypeDescriptor(false);
		
		generateInjectionPoints(type);
		
		typeDescriptor.constructorInjectionPoint = _getConstructorInjectionPoint();
		propertyInjectionPoints.forEach( (PropertyInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		methodInjectionPoints.forEach( (MethodInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		postConstructInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		postConstructInjectionPoints.forEach( (PostConstructInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		preDestroyInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		preDestroyInjectionPoints.forEach( (PreDestroyInjectionPoint injectionPoint) => typeDescriptor.addPreDestroyInjectionPoint(injectionPoint) );
		
		constructorInjectionPoint = propertyInjectionPoints = methodInjectionPoints = postConstructInjectionPoints = preDestroyInjectionPoints = null;
		
		return typeDescriptor;
	}
	
	void generateInjectionPoints(Type type) 
	{
		ClassMirror mirror = reflectClass(type);
		
		mirror.declarations.values.forEach( (DeclarationMirror declaration) 
		{
			declaration.metadata.forEach( (InstanceMirror metadata) 
			{
				if (metadata.reflectee is Inject)
				{
					if (declaration is VariableMirror) 
					{
						final String mappingId = Injector._getMappingId(declaration.type.reflectedType, (metadata.reflectee as Inject).name );
						
						_createPropertyInjectionPoint(mappingId, declaration.simpleName, (metadata.reflectee as Inject).optional);
					}
					else if (declaration is MethodMirror)
					{
						_createMethodInjectionPoint(declaration.simpleName, [], null);
					}
				} 
				else if (metadata.reflectee is PostConstruct) 
				{
					_createPostConstructInjectionPoint(declaration.simpleName, [], null, (metadata.reflectee as PostConstruct).order);
				}
				else if (metadata.reflectee is PreDestroy) 
				{
					_createPreDestroyInjectionPoint(declaration.simpleName, [], null, (metadata.reflectee as PreDestroy).order);
				}
			});
		});
	}
	
	ConstructorInjectionPoint _getConstructorInjectionPoint() 
	{
		return new NoParamsConstructorInjectionPoint();
	}
	
	void _createPropertyInjectionPoint(String mappingId, Symbol property, bool optional) 
	{
		PropertyInjectionPoint injectionPoint = new PropertyInjectionPoint(mappingId, property, optional);
		
		propertyInjectionPoints.add(injectionPoint);
  }
	
	void _createMethodInjectionPoint(Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments)
	{
		MethodInjectionPoint injectionPoint = new MethodInjectionPoint(method, positionalArguments, namedArguments);
		
		methodInjectionPoints.add(injectionPoint);
	}

	void _createPostConstructInjectionPoint(Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order)
	{
		PostConstructInjectionPoint injectionPoint = new PostConstructInjectionPoint(method, positionalArguments, namedArguments, order);
		
		postConstructInjectionPoints.add(injectionPoint);
	}

	void _createPreDestroyInjectionPoint(Symbol method, List<dynamic> positionalArguments, Map<Symbol, dynamic> namedArguments, int order)
	{
		PreDestroyInjectionPoint injectionPoint = new PreDestroyInjectionPoint(method, positionalArguments, namedArguments, order);
		
		preDestroyInjectionPoints.add(injectionPoint);
	}
}