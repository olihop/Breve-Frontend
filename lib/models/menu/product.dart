import 'dart:collection';
import 'package:breve/widgets/utils.dart';

import 'attribute.dart';
import 'may_segment_on_size.dart';

class GenericProduct {
  String name, defaultSize;
  List<Attribute> attributes;
  SegmentOnSize<int> price;
  String description;

  GenericProduct.fromJSON(dynamic yaml, {List<Attribute> allAttributes}) {
    this.name = yaml['name'];
    this.description = yaml["description"];
    print("Product "+ this.name);
    this.defaultSize = yaml['defaultSize'];
    //Not MaySegmentOnSize as products must have a size 
    LinkedHashMap priceBuilder = LinkedHashMap();
    yaml['price'].forEach((i) {
      var k = i.keys.first;
      var v = i[k];
      priceBuilder[k] = v;
    });
    this.price = SegmentOnSize(LinkedHashMap.from(priceBuilder.cast<String, int>())); 
    attributes = List();
    yaml['attributes'].forEach((atr) {
      attributes.add(Attribute.fromJSONReference(atr, allAttributes));
    });
  }

  String get minPriceString => formatPrice(sizes().values.fold(9999999, (int a, int b) => (a < b ? a : b))) + (attributes.length == 0 ? "" : "+");

  @override
  String toString() {
    return "\n  " + name + "\n   " + this.attributes.toString() +"\n   " + this.sizes().toString();
  }

  LinkedHashMap<String, int> sizes() => price.sizes;
}