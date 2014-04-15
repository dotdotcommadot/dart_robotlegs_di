library robotlegs_di_example;

import 'package:robotlegs_di/robotlegs_di.dart';

part 'stuffs/iproduct.dart';
part 'stuffs/product.dart';
part 'stuffs/shop.dart';
part 'stuffs/ishop.dart';

void main() 
{
	IInjector injector = new Injector();
	
	injector.map( IProduct ).toType( Product );
	injector.map( Shop );
	
	Shop shop = injector.getInstance( Shop );
	
	print( shop.product );
}