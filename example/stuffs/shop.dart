import 'package:robotlegs_di/src/reflection/annotations.dart';
import 'package:robotlegs_di/src/reflection/reflector.dart';

import 'product.dart';

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

@Reflect()
class Shop {
  //-----------------------------------
  //
  // Public Properties
  //
  //-----------------------------------

  @inject
  Product product;

  @inject
  Product otherProduct;

  ValueHolder _valueHolder;

  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  Shop();

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  @postConstruct
  void onPostConstruct() {
    print("Shop::onPostConstruct: " + product.toString());
    print("Shop::onPostConstruct: " + otherProduct.toString());
  }

  @preDestroy
  void onPreDestroy() {
    print("Shop::onPreDestroy");
  }

  @inject
  void injectedMethod() {
    print("Shop::injectedMethod");
  }

  @inject
  void withParamesInjectedMethod(ValueHolder valueHolder) {
    print("Shop::withParamesInjectedMethod " + valueHolder.value);
    this._valueHolder = valueHolder;
  }

  String getValue() => _valueHolder != null ?_valueHolder.value:null;
}

@Reflect()
class ValueHolder {
  final String value;

  const ValueHolder(this.value);
}

