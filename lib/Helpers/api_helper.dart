import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tech/Helpers/encrypter.dart';
import 'package:tech/Widgets/server_error_screen.dart';
import 'package:tech/main.dart';

class ApiHelper{
  final String baseUrl = "https://techdemy.in/connect/api/";

  static final ApiHelper _instance = ApiHelper._internal();

  ApiHelper._internal();

  factory ApiHelper() => _instance;

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Get Method
  Future<http.Response> get(Uri url) async {
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15)); // optional timeout

      return response;
    } on SocketException {
      // No internet / server not reachable
      _goToServerErrorPage("Server not responding");
      throw Exception();
    } on TimeoutException {
      // Request timed out
      _goToServerErrorPage("Request timed out");
      throw Exception();
    } on http.ClientException {
      _goToServerErrorPage("Client exception occurred");
      throw Exception();
    } catch (e) {
      _goToServerErrorPage("Something went wrong");
      throw Exception();
    }
  }

  // POST Method
  Future<http.Response> post(Uri url, String body) async {
    log('Encrypted Data: $body');
    // return await http.post(url,  headers: {'Content-Type': 'application/json',}, body: encodedBody,);
    try {
      final response = await http.post(url, body: {"data" : body}).timeout(const Duration(seconds: 15)); // optional timeout

      return response;
    } on SocketException {
      // No internet / server not reachable
      _goToServerErrorPage("Server not responding");
      throw Exception();
    } on TimeoutException {
      // Request timed out
      _goToServerErrorPage("Request timed out");
      throw Exception();
    } on http.ClientException {
      _goToServerErrorPage("Client exception occurred");
     throw Exception();
    } catch (e) {
      _goToServerErrorPage("Something went wrong");
      throw Exception();
    }
  }


  void _goToServerErrorPage(String message) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => ServerErrorPage(errorMessage: message),
      ),
    );
  }

}