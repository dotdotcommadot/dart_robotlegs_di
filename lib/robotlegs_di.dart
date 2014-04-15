library robotlegs_di;

//-----------------------------------
// imports
//-----------------------------------

import 'dart:mirrors';
import 'dart:async';

//-----------------------------------
// Descriptors
//-----------------------------------

part 'descriptors/type_descriptor.dart';

//-----------------------------------
// Errors
//-----------------------------------

part 'errors/injector_error.dart';
part 'errors/injector_missing_mapping_error.dart';

//-----------------------------------
// Injection
//-----------------------------------

part 'injection/injector.dart';
part 'injection/i_injector.dart';

//-----------------------------------
// InjectionPoints
//-----------------------------------

part 'injectionpoints/constructor_injection_point.dart';
part 'injectionpoints/injection_point.dart';
part 'injectionpoints/method_injection_point.dart';
part 'injectionpoints/no_params_constructor_injection_point.dart';
part 'injectionpoints/ordered_injection_point.dart';
part 'injectionpoints/post_construct_injection_point.dart';
part 'injectionpoints/pre_destroy_injection_point.dart';
part 'injectionpoints/property_injection_point.dart';

//-----------------------------------
// Mapping
//-----------------------------------

part 'mapping/injection_mapping.dart';

//-----------------------------------
// Providers
//-----------------------------------

part 'providers/i_provider.dart';
part 'providers/singleton_provider.dart';
part 'providers/type_provider.dart';
part 'providers/value_provider.dart';

//-----------------------------------
// Reflection
//-----------------------------------

part 'reflection/annotations.dart';
part 'reflection/reflector.dart';