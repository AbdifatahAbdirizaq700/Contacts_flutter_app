import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailsPage({super.key, required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  final ApiService _apiService = ApiService();
  bool isFavorite = false;
  bool isLoading = false;

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  Future<void> _toggleFavorite() async {
    setState(() => isLoading = true);
    try {
      if (isFavorite) {
        await _apiService.removeFromFavorites(widget.contact.id);
      } else {
        await _apiService.addToFavorites(widget.contact.id);
      }
      setState(() => isFavorite = !isFavorite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: isLoading ? null : _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'contact_${widget.contact.id}',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    widget.contact.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Name',
              content: widget.contact.name,
              icon: Icons.person,
            ),
            _buildDetailCard(
              title: 'Phone',
              content: widget.contact.phone,
              icon: Icons.phone,
              onCopy: () => _copyToClipboard(
                widget.contact.phone,
                'Phone number',
              ),
            ),
            _buildDetailCard(
              title: 'Email',
              content: widget.contact.email,
              icon: Icons.email,
              onCopy: () => _copyToClipboard(
                widget.contact.email,
                'Email address',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String content,
    required IconData icon,
    VoidCallback? onCopy,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: onCopy != null
            ? IconButton(
                icon: const Icon(Icons.copy),
                onPressed: onCopy,
                tooltip: 'Copy $title',
              )
            : null,
      ),
    );
  }
}
