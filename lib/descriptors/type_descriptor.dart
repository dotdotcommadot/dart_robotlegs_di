part of robotlegs_di;

class TypeDescriptor 
{
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------
	
	InjectionPoint injectionPoints;
	
	ConstructorInjectionPoint constructorInjectionPoint;
	
	PreDestroyInjectionPoint preDestroyMethods;
	
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	bool _postConstructAdded;
	
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------
	
	TypeDescriptor([bool useDefaultConstructor = true]) 
	{
		if (useDefaultConstructor)
			constructorInjectionPoint = new NoParamsConstructorInjectionPoint();
	}
	
  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------
	
	TypeDescriptor setConstructor(
		[positionalArguments = null, 
		 namedArguments = null]
	)
	{
		constructorInjectionPoint = new ConstructorInjectionPoint(positionalArguments, namedArguments);
		return this;
	}
	
	TypeDescriptor addPropertyInjection(
	   Symbol property,
	   Type type,
	   [String injectionName = '',
	    bool optional = false]
	)
	{
		if (_postConstructAdded)
			throw new InjectorError('Can\'t add injection point after post construct method');
		
		addInjectionPoint(new PropertyInjectionPoint(Injector._getMappingId(type, injectionName), property, optional));
		
		return this;
	}
	
	TypeDescriptor addMethodInjection(
		Symbol method,
		[positionalArguments = null, 
     namedArguments = null,
     optional = false]
	)
	{
		if (_postConstructAdded)
    	throw new InjectorError('Can\'t add injection point after post construct method');
		
		addInjectionPoint(new MethodInjectionPoint(method, positionalArguments, namedArguments));
		
		return this;
	}
	
	TypeDescriptor addPostConstructMethod(
		Symbol method,
		[positionalArguments = null, 
		 namedArguments = null]
	)
	{
		_postConstructAdded = true;
		
		addInjectionPoint(new PostConstructInjectionPoint(method, positionalArguments, namedArguments, 0));
		
		return this;
	}

	TypeDescriptor addPreDestroyMethod(
	  Symbol method,
	  [positionalArguments = null, 
	   namedArguments = null]
	)
	{
		final PreDestroyInjectionPoint injectionPoint = new PreDestroyInjectionPoint(method, positionalArguments, namedArguments, 0);
		
		if (preDestroyMethods != null)
		{
			preDestroyMethods.last.next = injectionPoint;
    	preDestroyMethods.last = injectionPoint;
		}
		else
		{
			preDestroyMethods = injectionPoint;
    	preDestroyMethods.last = injectionPoint;
		}
		
		return this;
	}
	
	void addInjectionPoint(InjectionPoint injectionPoint) 
	{
		if (injectionPoints != null)
		{
			injectionPoints.last.next = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
		else
		{
			injectionPoints = injectionPoint;
			injectionPoints.last = injectionPoint;
		}
	}
}