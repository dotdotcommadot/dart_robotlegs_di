# Robotlegs DI

###### Version: 0.0.1 -- alpha

## About

Robotlegs DI is a Dependency Injection framework for the Google Dart programming language.
It will also be the default DI-engine for Robotlegs for Dart.

### Google Dart
Google Dart is a new open source programming language by Google, which attempts to clean up the mess web development has become.
It comes with its own Virtual Machine which will be implemented out-of-the-box in Google Chrome and hopefully other browsers later on as well, 
but currently it does a great job cross-compiling to JavaScript.
It respects the HTML-CSS-JavaScript mindset, but when the VM will be in place, it will replace (only) the JavaScript part.
- [Official Website](https://www.dartlang.org/)

### Robotlegs for Dart
Robotlegs is an open source MV* framework, which was originally written for ActionScript 3.
It provides a very clean API for building applications ranging from large enterprise software, to mini-sites and animations.
Robotlegs for Dart project is the beginning of an attempt to bring all the sweetness Robotlegs for AS3 has to Google Dart.
- [Robotlegs for AS3 on Github](https://github.com/robotlegs/robotlegs-framework)
- [Robotlegs for Dart on Github](https://github.com/dotdotcommadot/dart_robotlegs)

### Robotlegs DI
Robotlegs DI, the project you're currently looking at, is a Dependency Injection framework inspired by the DI framework the original Robotlegs framework uses, called [SwiftSuspenders](https://github.com/robotlegs/swiftsuspenders).
The original API is very clean, intuitive and flexibel, so this project will try to remain as close to the original API as possible, 
and be extended or modified where needed.
Programming in Google Dart isn't necessarily that much different to programming in ActionScript 3 (and certainly Apache Flex), so a big part can remain in the same likes.
- [SwiftSuspenders on Github](https://github.com/robotlegs/swiftsuspenders)

## Features

### Optionally Named Mappings 

	// basic mapping
	injector.map(Product);
	
	// named mapping
	injector.map(Product, 'shoe');
	
### Mappings to Type, Value, or as Singleton

	// map abstract type to implementation
	injector.map(AbstractProduct).toType(Product);
	
	// map type to instance
	injector.map(Product).toValue(new Product);
	
	// map type as singleton
	injector.map(Product).asSingleton;

### Optionally Named Metadata-Based Injection

	// unnamed
	@inject 
	Product product;

	// named
	@Inject('shoe') 
	Product product;

### Inject Into Properties, Methods and Constructors

	// inject into property
	@inject 
	Product product;
	
	// inject into method
	@inject
	void buyThisThing(Product myProduct) { }
	
	// inject into constructor
	@inject
	Shop(Product myProduct) { };
	
### Optionally Ordered Post-Construct Methods
These methods run after all injections for the current class have been resolved.
	
	// unordered
	@postConstruct
	void whenAllPropertiesAreInjected() { }

	// ordered
	@PostConstruct(order: 1)
	void whenAllPropertiesAreInjected() { }

### Optionally Ordered Pre-Destroy Methods
These methods run right before the mappings for this object are removed by calling 'injector.tearDown()' 
	
	// unordered
	@preDestroy
	void rightBeforeDestruction() { }

	// ordered
	@PreDestroy(order: 1)
	void rightBeforeDestruction() { }
	
## Info
	
For more info about this project, contact:

- [hans@dotdotcommadot.com](mailto:hans@dotdotcommadot.com)
