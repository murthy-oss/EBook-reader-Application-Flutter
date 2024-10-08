import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/google_books_api.dart';
import 'book_detail.dart'; // Import added

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<GoogleBooksApi>(context);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
            title: const Text('EBook reader Application', style: TextStyle(fontSize: 25)),
            backgroundColor: Colors.green[700],
            toolbarHeight: 70,
            elevation: 5,
            shadowColor: Colors.green[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))
      ),
      body: Column(
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for books',
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 3, 131, 29),// Set the color you want here
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, size: 30, color:  Color.fromARGB(255, 3, 131, 29),),
                  onPressed: () {
                    bookProvider.search(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: bookProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: bookProvider.books.length,
                    itemBuilder: (context, index) {
                      final book = bookProvider.books[index];
                      return ListTile(
                        title: Text(book['volumeInfo']['title'] ?? 'No Title'),
                        subtitle: Text(book['volumeInfo']['authors'] != null
                            ? book['volumeInfo']['authors'].join(', ')
                            : 'Unknown Author'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookDetail(book: book),
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
