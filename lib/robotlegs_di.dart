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

library robotlegs_di;

//-----------------------------------
// imports
//-----------------------------------

import 'dart:async';

import 'package:reflectable/reflectable.dart';

part 'descriptors/type_descriptor.dart';
part 'errors/injector_error.dart';
part 'errors/injector_interface_constructor_error.dart';
part 'errors/injector_missing_mapping_error.dart';
part 'injection/i_injector.dart';
part 'injection/injector.dart';
part 'injectionpoints/constructor_injection_point.dart';
part 'injectionpoints/injection_point.dart';
part 'injectionpoints/method_injection_point.dart';
part 'injectionpoints/no_params_constructor_injection_point.dart';
part 'injectionpoints/ordered_injection_point.dart';
part 'injectionpoints/post_construct_injection_point.dart';
part 'injectionpoints/pre_destroy_injection_point.dart';
part 'injectionpoints/property_injection_point.dart';
part 'mapping/i_providerless_mapping.dart';
part 'mapping/i_unsealed_mapping.dart';
part 'mapping/injection_mapping.dart';
part 'providers/factory_provider.dart';
part 'providers/forwarding_provider.dart';
part 'providers/i_fallback_provider.dart';
part 'providers/i_provider.dart';
part 'providers/injector_using_provider.dart';
part 'providers/local_only_provider.dart';
part 'providers/other_mapping_provider.dart';
part 'providers/singleton_provider.dart';
part 'providers/soft_provider.dart';
part 'providers/type_provider.dart';
part 'providers/value_provider.dart';
part 'reflection/annotations.dart';
part 'reflection/reflector.dart';
//-----------------------------------
// Descriptors
//-----------------------------------
//-----------------------------------
// Errors
//-----------------------------------
//-----------------------------------
// Injection
//-----------------------------------
//-----------------------------------
// InjectionPoints
//-----------------------------------
//-----------------------------------
// Mapping
//-----------------------------------
//-----------------------------------
// Providers
//-----------------------------------
//-----------------------------------
// Reflection
//-----------------------------------


const Reflect reflect = const Reflect();
