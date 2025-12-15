import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu.dart';

class MenuService {
  static const String baseUrl = 'http://localhost:8000/api';
}