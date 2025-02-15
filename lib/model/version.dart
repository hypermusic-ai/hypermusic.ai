import 'dart:convert';
import 'package:crypto/crypto.dart';

///The Version class is a generic class that represents a version with a cryptographic hash
class Version<T>
{
  final Digest hash;

  Version({required this.hash});
}

Digest sha256FromString(String input) => sha256.convert(utf8.encode(input));