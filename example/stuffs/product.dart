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

part of robotlegs_di_example;

class Product {
  //-----------------------------------
  //
  // Constructor
  //
  //-----------------------------------

  Product();

  //-----------------------------------
  //
  // Public Methods
  //
  //-----------------------------------

  @postConstruct
  void postConstructMethod() {
    print("Product::postConstructMethod");
  }

  @PostConstruct(order: 1)
  void firstPostConstructMethod() {
    print("Product::firstPostConstructMethod");
  }

  @PostConstruct(order: 2)
  void secondPostConstructMethod() {
    print("Product::secondPostConstructMethod");
  }

  @preDestroy
  void preDestroyMethod() {
    print("Product::preDestroyMethod");
  }

  @PreDestroy(order: 1)
  void firstPreDestroyMethod() {
    print("Product::firstPreDestroyMethod");
  }

  @PreDestroy(order: 2)
  void secondPreDestroyMethod() {
    print("Product::secondPreDestroyMethod");
  }
}
