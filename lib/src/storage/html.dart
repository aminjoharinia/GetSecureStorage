import 'dart:async';
import 'dart:convert';
import 'package:web/web.dart' as web;
import 'package:get_secure_storage/get_secure_storage.dart';

class StorageImpl {
  StorageImpl(this.fileName, [this.path]);
  web.Storage get localStorage => web.window.localStorage;

  final String? path;
  final String fileName;
  StringCallback _encrypt = (input) async => input;
  StringCallback _decrypt = (input) async => input;

  ValueStorage<Map<String, dynamic>> subject = ValueStorage<Map<String, dynamic>>(<String, dynamic>{});

  void clear() {
    localStorage.removeItem(fileName);
    subject.value?.clear();

    subject
      ..value?.clear()
      ..changeValue("", null);
  }

  static Future<bool> hasContainer(container, [String? path]) async => true;
  static deleteContainer(container, [String? path]) {}

  Future<bool> _exists() async {
    return localStorage.getItem(fileName) != null;
  }

  Future<void> flush() {
    return _writeToStorage(subject.value ?? {});
  }

  T? read<T>(String key) {
    return subject.value![key] as T?;
  }

  T getKeys<T>() {
    return subject.value!.keys as T;
  }

  T getValues<T>() {
    return subject.value!.values as T;
  }

  Future<void> init(Map<String, dynamic>? initialData, StringCallback encrypt, StringCallback decrypt) async {
    _encrypt = encrypt;
    _decrypt = decrypt;
    subject.value = initialData ?? <String, dynamic>{};
    if (await _exists()) {
      await _readFromStorage();
    } else {
      await _writeToStorage(subject.value ?? {});
    }
    return;
  }

  void remove(String key) {
    subject
      ..value?.remove(key)
      ..changeValue(key, null);
  }

  void write(String key, dynamic value) {
    subject
      ..value![key] = value
      ..changeValue(key, value);
  }

  Future<void> _writeToStorage(Map<String, dynamic> data) async {
    final subjectValue = await _encrypt(json.encode(subject.value));
    localStorage.setItem(fileName, subjectValue);
  }

  Future<void> _readFromStorage() async {
    final dataValue = localStorage.getItem(fileName);
    if (dataValue != null) {
      String decryptedData = await _decrypt(dataValue);
      subject.value = json.decode(decryptedData) as Map<String, dynamic>;
    } else {
      await _writeToStorage(<String, dynamic>{});
    }
  }
}

extension FirstWhereExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
