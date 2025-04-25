import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetail extends StatelessWidget {
  final Map book;

  const BookDetail({Key? key, required this.book}) : super(key: key);
  // Function to open URLs in the browser
  Future<void> _launchURL(String url) async {
    try {
      // Encode the URL to handle special characters
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      // Show a snackbar with the error message
      debugPrint('Error launching URL: $e');
      // You might want to show this error to the user through a SnackBar
      // or other UI element
    }
  }

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book['volumeInfo'];

    // Extract URLs
    final thumbnail =
        volumeInfo['imageLinks'] != null
            ? volumeInfo['imageLinks']['thumbnail']
            : null;

    final previewLink = volumeInfo['previewLink'];
    final downloadLink =
        book['accessInfo'] != null
            ? book['accessInfo']['pdf'] != null &&
                    book['accessInfo']['pdf']['isAvailable']
                ? book['accessInfo']['pdf']['acsTokenLink']
                : null
            : null;

    final buyLink = volumeInfo['infoLink'];

    return Scaffold(
      appBar: AppBar(title: Text(volumeInfo['title'] ?? 'No Title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image with a placeholder and error handling
            thumbnail != null
                ? Center(
                  child: Image.network(
                    thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 100);
                    },
                  ),
                )
                : const Icon(Icons.book, size: 100),
            const SizedBox(height: 16),
            Text(
              volumeInfo['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Author(s): ' +
                  (volumeInfo['authors'] != null
                      ? volumeInfo['authors'].join(', ')
                      : 'Unknown'),
            ),
            const SizedBox(height: 8),
            Text(volumeInfo['description'] ?? 'No Description'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Preview Button
                if (previewLink != null)
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(previewLink);
                    },
                    child: const Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        right: 20,
                        left: 25,
                        top: 15,
                        bottom: 15,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                // Download Button
                if (downloadLink != null)
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(downloadLink);
                    },
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        right: 20,
                        left: 25,
                        top: 15,
                        bottom: 15,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(buyLink);
                    },
                    child: const Text(
                      'More Info',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(
                        right: 20,
                        left: 25,
                        top: 15,
                        bottom: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
