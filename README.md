# GetSecureStorage
With WASM Support
A cryptography Secure version of GetStorage originally written by Jonny Borges (https://github.com/jonataslaw/get_storage).

GetSecureStorage is a secure, fast, extra light and synchronous key-value in memory, which backs up data to disk at each operation. It is written entirely in Dart and is based on the Cryptography dart package.

The cryptography library used is https://pub.dev/packages/cryptography

The algorithm used is 128bit AES-CTR with MAC sha256

Supports Android, iOS, Web, Mac, Linux, and Windows. 
Can store String, int, double, Map and List

### Add to your pubspec:
```
dependencies:
  get_secure_storage:
```
### Install it

You can install packages from the command line:

with `Flutter`:

```css
$  flutter packages get
```

### Import it

Now in your `Dart` code, you can use: 

````dart
import 'package:get_secure_storage/get_secure_storage.dart';
````

### Initialize storage driver with await:
```dart
main() async {
  await GetSecureStorage.init(password: 'strongpassword');
  runApp(App());
}
```
#### use GetSecureStorage through an instance or use directly `GetSecureStorage().read('key')`
```dart
final box = GetSecureStorage(password: 'strongpassword');
```
#### To write information you must use `write` :
```dart
box.write('quote', 'GetSecureStorage is the best');
```

#### To read values you use `read`:
```dart
print(box.read('quote'));
// out: GetSecureStorage is the best

```
#### To remove a key, you can use `remove`:

```dart
box.remove('quote');
```

#### To listen changes you can use `listen`:
```dart
Function? disposeListen;
disposeListen = box.listen((){
  print('box changed');
});
```
#### If you subscribe to events, be sure to dispose them when using:
```dart
disposeListen?.call();
```
#### To listen changes on key you can use `listenKey`:

```dart
box.listenKey('key', (value){
  print('new key is $value');
});
```

#### To erase your container:
```dart
box.erase();
```

#### If you want to create different containers, simply give it a name. You can listen to specific containers, and also delete them.

```dart
GetSecureStorage g = GetSecureStorage(container:'MyStorage', password: 'strongpassword');
```

#### To initialize specific container:
```dart
await GetSecureStorage.init(container:'MyStorage', password: 'strongpassword');
```

## SharedPreferences Implementation
```dart
class MyPref {
  static final _otherBox = () => GetSecureStorage(container:'MyPref', password: 'strongpassword');

  final username = ''.val('username');
  final age = 0.val('age');
  final price = 1000.val('price', getBox: _otherBox);

  // or
  final username2 = ReadWriteValue('username', '');
  final age2 = ReadWriteValue('age', 0);
  final price2 = ReadWriteValue('price', '', _otherBox);
}

...

void updateAge() {
  final age = 0.val('age');
  // or 
  final age = ReadWriteValue('age', 0, () => box);
  // or 
  final age = Get.find<MyPref>().age;

  age.val = 1; // will save to box
  final realAge = age.val; // will read from box
}
```
