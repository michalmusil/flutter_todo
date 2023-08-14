abstract class GeneralClass {
  void printName();
}


class Tester extends GeneralClass {
  late String name;

  Tester(String cau){
    name = cau;
  }

  String getName(){
    return name;
  }
  
  @override
  void printName() {
    print("${name} is my name!");
  }

}

class ShoppingCart<T extends Object> extends GeneralClass {
  late final String name;
  late final List<T> items;

  ShoppingCart({required String name, List<T>? items}){
    this.name = name;
    this.items = items ?? [];
  }

  bool containsItem(T item){
    return items.contains(item);
  }

  void addItem(T item){
    items.add(item);
  }
  
  bool removeItem(T item){
    return items.remove(item);
  }

  void printItems(){
    items.forEach((element) {
      print(element);
    });
  }

  Future<int> complexComputation(int number) async {
      final result = await Future.delayed(const Duration(seconds: 3), () {
        return number * 1000;
      });
      print('Result of complex computation with $number is: $result');
      return result;
  }

  Stream<String> timer(){
    return Stream.periodic(const Duration(seconds: 1), (count) {
      final now = DateTime.now();
      return '${now.hour}:${now.minute}:${now.second}';
    });
  }

  @override
  void printName() {
    print('I am a shopping cart and my name is ${name}');
  }
}

extension EasyPrint on ShoppingCart{
  String get stringRepresentation {
    var itemsString = '';
    for(var item in items){
      itemsString += '$item \n';
    }
    return '____${name}____ \n$itemsString';
  }
}



void main() async {
  final cart = ShoppingCart(name: 'Ivan', items: ['Milk', 'Peaches', 'Car']);
  cart.printName();
  cart.addItem("testseetestst");
  cart.printItems();
  cart.removeItem('Peaches');
  cart.printItems();

  print('____________________________________________');
  print('Starting complex computation');
  cart.complexComputation(15);
  print('sync code finished');






  print('____________________________________________');
  var isFinished = false;
  Future.delayed(const Duration(seconds: 10), () {
    isFinished = true;
  });

  await for(final value in cart.timer()){
    print('time is: $value');
    if(isFinished == true){
      print('Program ended');
      break;
    }
  }
}