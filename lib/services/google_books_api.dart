import 'dart:convert';               
import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 

class GoogleBooksApi extends ChangeNotifier {
  // List to store fetched books data from the API
  List books = [];                    

  // Boolean to indicate whether data is currently being fetched
  bool isLoading = false;              

  // Function to search books based on user query
  Future<void> search(String query) async {
    // Construct the URL for the Google Books API with the query string
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=$query';

    // Set loading state to true to indicate data fetching has started
    isLoading = true;
    // Notify listeners (e.g., UI) to update the loading state
    notifyListeners();   

    try {
      // Make an HTTP GET request to the Google Books API
      final response = await http.get(Uri.parse(url));

      // Log the response status code for debugging purposes
      print("response status code ${response.statusCode}");

      // Check if the request was successful (HTTP status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response body
        final data = json.decode(response.body);   
        // Extract the 'items' field from the response, or set to an empty list if null
        books = data['items'] ?? [];  
      } else {
        // If the request fails, clear the books list
        books = [];  
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      // Clear the books list in case of an error
      books = [];
    }

    // Set loading state to false to indicate data fetching is complete
    isLoading = false;
    // Notify listeners (e.g., UI) to update the loading state and display results
    notifyListeners();   
  }
}