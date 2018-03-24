/*
* Copyright (c) 2014 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

part of robotlegs_di;

class Refly extends Reflectable {
	const Refly():super(
		instanceInvokeCapability,
		invokingCapability,
		reflectedTypeCapability,
		typeCapability,
		typingCapability,
		metadataCapability,
		newInstanceCapability,
	);
}

class Reflector
{
  //-----------------------------------
  //
  // Private Properties
  //
  //-----------------------------------
	
	Map<Type, TypeDescriptor> _descriptorsCache = new Map<Type, TypeDescriptor>();

	List<ClassMirror> _processableClassMirrors = new List<ClassMirror>();
	
	List<ConstructorInjectionPoint> _constructorInjectionPoints;
	
	List<PropertyInjectionPoint> _propertyInjectionPoints; 
	
	List<MethodInjectionPoint> _methodInjectionPoints; 
	
	List<PostConstructInjectionPoint> _postConstructInjectionPoints; 
	
	List<PreDestroyInjectionPoint> _preDestroyInjectionPoints; 

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
     if (_descriptorsCache[type] == null)
    	 _descriptorsCache[type] = createDescriptor(type);

     return _descriptorsCache[type];
  }
	
	void addDescriptor(Type type, TypeDescriptor descriptor)
	{
		_descriptorsCache[type] = descriptor;
	}
	
	Type getType(dynamic value)
	{
		return value.runtimeType;
	}
	
	TypeDescriptor createDescriptor(Type type) 
	{
		_constructorInjectionPoints = new List<ConstructorInjectionPoint>();
		_propertyInjectionPoints = new List<PropertyInjectionPoint>();
		_methodInjectionPoints = new List<MethodInjectionPoint>();
		_postConstructInjectionPoints = new List<PostConstructInjectionPoint>();
		_preDestroyInjectionPoints = new List<PreDestroyInjectionPoint>();
		
		final TypeDescriptor typeDescriptor = new TypeDescriptor(false);
		
		_createProcessableClassMirrorsFor(type);
		_generateConstructorsFor(_processableClassMirrors.first);
		_processableClassMirrors.forEach((mirror) => _generateInjectionPointsFor(mirror));
		
		_constructorInjectionPoints.forEach( (ConstructorInjectionPoint injectionPoint) => typeDescriptor.addConstructorInjectionPoint(injectionPoint));
		_propertyInjectionPoints.forEach( (PropertyInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		_methodInjectionPoints.forEach( (MethodInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		_postConstructInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		_postConstructInjectionPoints.forEach( (PostConstructInjectionPoint injectionPoint) => typeDescriptor.addInjectionPoint(injectionPoint) );
		_preDestroyInjectionPoints.sort( (x, y) => x.order.compareTo(y.order) );
		_preDestroyInjectionPoints.forEach( (PreDestroyInjectionPoint injectionPoint) => typeDescriptor.addPreDestroyInjectionPoint(injectionPoint) );
		
		_processableClassMirrors = _constructorInjectionPoints = _propertyInjectionPoints = _methodInjectionPoints = _postConstructInjectionPoints = _preDestroyInjectionPoints = null;
		
		return typeDescriptor;
	}
	
  //-----------------------------------
  //
  // Private Methods
  //
  //-----------------------------------
	
	void _generateConstructorsFor(ClassMirror mirror)
	{
		List<DeclarationMirror> constructors = new List.from(
      mirror.declarations.values.where( (declare) => declare is MethodMirror && declare.isConstructor)
    );
		
		constructors.forEach( (constructor) 
		{
      if (constructor is MethodMirror) 
      {
        _createConstructorInjectionPoint(constructor.constructorName, constructor.parameters);
      }
    });
	}
	
	void _generateInjectionPointsFor(ClassMirror mirror) 
	{
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
					else if (declaration is MethodMirror && !declaration.isGetter)
					{
					  if (declaration.isSetter)
					  {
							final String name = (declaration.simpleName).toString().split('=').first;
					    final String mappingId = Injector._getMappingId(declaration.parameters.first.type.reflectedType, (metadata.reflectee as Inject).name );
					    
					    _createPropertyInjectionPoint(mappingId, name, (metadata.reflectee as Inject).optional);
					  }
					  else
					  {
							_createMethodInjectionPoint(declaration.simpleName, declaration.parameters, (metadata.reflectee as Inject).optional, declaration.isSetter);
					  }
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
	
	void _createConstructorInjectionPoint(String method, List<ParameterMirror> parameters)
	{
		ConstructorInjectionPoint injectionPoint;
		
		if (parameters == null || parameters.length == 0)
			injectionPoint = new NoParamsConstructorInjectionPoint(method);
		else
			injectionPoint = new ConstructorInjectionPoint(
					method,
					_getPositionalParameters(parameters), 
					_getNumberOfRequiredPositionalParameters(parameters),
					_getNamedParameters(parameters));
		
		_constructorInjectionPoints.add(injectionPoint);
		
	}
	
	void _createPropertyInjectionPoint(String mappingId, String property, bool optional)
	{
		PropertyInjectionPoint injectionPoint = new PropertyInjectionPoint(mappingId, property, optional);
		
		_propertyInjectionPoints.add(injectionPoint);
  }
	
	void _createMethodInjectionPoint(String method, List<ParameterMirror> parameters, bool optional, bool isSetter)
	{
		MethodInjectionPoint injectionPoint = new MethodInjectionPoint(
			method, 
			_getPositionalParameters(parameters), 
			_getNumberOfRequiredPositionalParameters(parameters),
			_getNamedParameters(parameters),
			optional);
		
		_methodInjectionPoints.add(injectionPoint);
	}

	void _createPostConstructInjectionPoint(String method, List<dynamic> positionalArguments, Map<String, dynamic> namedArguments, int order)
	{
		PostConstructInjectionPoint injectionPoint = new PostConstructInjectionPoint(method, positionalArguments, 0, namedArguments, order);
		
		_postConstructInjectionPoints.add(injectionPoint);
	}

	void _createPreDestroyInjectionPoint(String method, List<dynamic> positionalArguments, Map<String, dynamic> namedArguments, int order)
	{
		PreDestroyInjectionPoint injectionPoint = new PreDestroyInjectionPoint(method, positionalArguments, 0, namedArguments, order);
		
		_preDestroyInjectionPoints.add(injectionPoint);
	}
	
	List<Type> _getPositionalParameters(List<ParameterMirror> parameterMirrors)
	{
		List<Type> parameters = new List<Type>();
		
		parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed).forEach(
			(ParameterMirror parameter) 
			{
				parameters.add(parameter.type.reflectedType);
			}
		); 
		
		return parameters;
	}

	int _getNumberOfRequiredPositionalParameters(List<ParameterMirror> parameterMirrors)
	{
		return parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed && !parameter.isOptional).length;
	}
	
	Map<String, Type> _getNamedParameters(List<ParameterMirror> parameterMirrors)
	{
		Map<String, Type> parameters = new Map<String, Type>();
		
		parameterMirrors.where((ParameterMirror parameter) => !parameter.isNamed).forEach(
			(ParameterMirror parameter) 
			{
				parameters[parameter.simpleName] = parameter.type.reflectedType;
			}
		); 
		
    return parameters;
	}
	
	void _createProcessableClassMirrorsFor(Type type)
	{
		_processableClassMirrors = new List<ClassMirror>();

		ClassMirror classMirror = _refly.reflectType(type);
		
		while (classMirror != null)
		{
			_processableClassMirrors.add(classMirror);
			classMirror = classMirror.superclass;
		}
	}
}