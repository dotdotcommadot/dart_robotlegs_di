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

library robotlegs_di_test;

import 'package:test/test.dart';

import 'robotlegs_di_test.reflectable.dart';
import 'testcases/instantiation_test_case.dart';
import 'testcases/parent_injector_test_case.dart';
import 'testcases/mapping_test_case.dart';
import 'testcases/post_construct_methods_test_case.dart';
import 'testcases/pre_destroy_methods_test_case.dart';
import 'testcases/injection_test_case.dart';



main()
{
	initializeReflectable();
	group('Instantiation Tests -', instantiationTestCase);
	group('Injection Tests -', injectionTestCase);
	group('Mapping Tests -', mappingTestCase);
	group('Parent Injector Tests -', parentInjectorTestCase);
	group('Post-Contrust Methods Tests -', postConstructMethodsTestCase);
	group('Pre-Destroy Methods Tests -', preDestroyMethodsTestCase);
}