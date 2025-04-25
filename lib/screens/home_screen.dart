import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/google_books_api.dart';
import './book_details.dart';

// HomeScreen is the main screen of the application where users can search for books
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the GoogleBooksApi provider
    final bookProvider = Provider.of<GoogleBooksApi>(context);
    // Controller for the search input field
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'EBook reader Application',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 5,
        shadowColor: Colors.green[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10), // Adds spacing at the top
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              // Binds the controller to the TextField
              controller: searchController,
              // Triggers search on submission
              onSubmitted:
                  (value) => bookProvider.search(searchController.text),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 3, 131, 29),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // Placeholder text
                labelText: 'Search for books',
                labelStyle: TextStyle(color: Color.fromARGB(255, 3, 131, 29)),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Color.fromARGB(255, 3, 131, 29),
                  ),
                  onPressed: () {
                    // Triggers search on button press
                    bookProvider.search(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            // Checks if data is still loading
            child:
                bookProvider.isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 3, 131, 29),
                      ),
                    )
                    : ListView.builder(
                      // Number of books to display
                      itemCount: bookProvider.books.length,
                      itemBuilder: (context, index) {
                        // Current book data
                        final book = bookProvider.books[index];
                        return ListTile(
                          // Book title
                          title: Text(
                            book['volumeInfo']['title'] ?? 'No Title',
                          ),
                          // Authors list
                          subtitle: Text(
                            book['volumeInfo']['authors'] != null
                                ? book['volumeInfo']['authors'].join(', ')
                                : 'Unknown Author', // Fallback if no authors are available
                          ),
                          onTap: () {
                            // Navigate to the BookDetail screen when a book is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(book: book),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
