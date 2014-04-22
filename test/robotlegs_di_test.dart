library robotlegs_di_test;

import 'package:unittest/unittest.dart';
import 'package:robotlegs_di/robotlegs_di.dart';

part 'objects/clazz.dart';
part 'objects/abstract_clazz.dart';
part 'objects/interface_clazz.dart';

part 'testcases/instantiation_test_case.dart';
part 'testcases/injection_test_case.dart';

main()
{
	group('Instantiation Tests -', instantiationTestCase);
	group('Injection Tests -', injectionTestCase);
}