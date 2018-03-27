# Robotlegs DI


###### Version: 0.1.3 -- alpha

## About

Robotlegs DI is a Dependency Injection framework for the Google Dart programming language.
It will also be the default DI-engine for Robotlegs for Dart.

### Robotlegs for Dart
Robotlegs is an open source MV* framework, which was originally written for ActionScript 3.
It provides a very clean API for building applications ranging from large enterprise software, to mini-sites and animations.
Robotlegs for Dart project is the beginning of an attempt to bring all the sweetness Robotlegs for AS3 has to Google Dart.
At the moment, project has not reached even alpha
- [Robotlegs for AS3 on Github](https://github.com/robotlegs/robotlegs-framework)
- [Robotlegs for Dart on Github](https://github.com/matejthetree/dart_robotlegs)

### Robotlegs DI
Robotlegs DI, the project you're currently looking at, is a Dependency Injection framework inspired by the DI framework the original Robotlegs framework uses, called [SwiftSuspenders](https://github.com/robotlegs/swiftsuspenders).
The original API is very clean, intuitive and flexible, so this project will try to remain as close to the original API as possible, 
and be extended or modified where needed.
Programming in Google Dart isn't necessarily that much different to programming in ActionScript 3 (and certainly Apache Flex), so a big part can remain in the same likes.
- [SwiftSuspenders on Github](https://github.com/robotlegs/swiftsuspenders)

## Features

### Reflection in Robotlegs DI
Robotlegs DI is using [Reflectable](https://github.com/dart-lang/reflectable) as a reflection system for dart, since dart:mirrors are not supported on many dart platforms.

To be able to use Reflectable there are some steps you need to take care of:
* You must mark all the classes you wish to map with `@Reflect()` metadata
```$xslt
@Reflect()
abstract class AbstractClazz
{

}

```
* Creating a build script, taken from Reflectable readme:


In order to generate code, you will need to write a tiny Dart program which imports the actual builder. We'll assume that you store this program as tool/builder.dart as seen from the root of your package. Here's the code:
```
import 'package:reflectable/reflectable_builder.dart' as builder;

main(List<String> arguments) async {
  await builder.reflectableBuild(arguments);
}
```
Now run the code generation step with the root of your package as the current directory:

`> dart tool/builder.dart lib/main.dart`
where `lib/main.dart` should be replaced by the root file/library of the program for which you wish to generate code that contains your `main()` function. You can generate code for several programs in one step; for instance, to generate code for a set of test files in test, this would typically be `tool/builder.dart test/*_test.dart`.
Note that you should generate code for the same set of root libraries every time you run builder.dart. This is because the build framework stores data about the code generation in a single database in the directory .dart_tool, so you will get complaints about inconsistencies if you switch from generating code for `lib/main.dart` to generating code for `lib/other.dart`.
If and when you need to generate code for another set of programs, delete all files named `*.reflectable.dart`, and the directory `.dart_tool`.

* It is necessary to import the generated code, which is stored in a library whose file name is obtained by taking the file name of the main library of the program and adding .reflectable. If you main library was called `main.dart`, this amounts to `import 'main.reflectable.dart'`.
   
   It is also necessary to initialize the reflection support by calling `initializeReflectable()`, at the beginning of your `main()` function.
```$xslt
main() {
  initializeReflectable(); // Set up reflection support.
... // continue with running your app
}
```
   
 


### Optionally Named Mappings 

	// basic mapping
	injector.map(Product);
	
	// named mapping
	injector.map(Product, 'shoe');
	
### Mapping to Type, Value, or as Singleton

	// map abstract type to implementation
	injector.map(AbstractProduct).toType(Product);

	// map interface to implementation
	injector.map(IProduct).toType(Product);

	// map mixin to implementation
	injector.map(SellableMixin).toType(Product);
	
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
	
## Tests
Check test files for simple examples how to use injector.

## Info
	
For more info about this project, contact:

- [matejthetree@gmail.com](mailto:matejthetree@gmail.com)

##Todo
* optimize reflectable capabilities
* simplify broadcasts
* cover more use cases with tests
