import 'package:contacts_app/pages/contact_details_page.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/contact.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService _apiService = ApiService();
  List<Contact> favorites = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    try {
      final fetchedFavorites = await _apiService.getFavorites();
      setState(() => favorites = fetchedFavorites);
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

  Future<void> _deleteFavorite(Contact contact) async {
    try {
      await _apiService.removeFromFavorites(contact.id);
      _loadFavorites(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final contact = favorites[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text(contact.name[0].toUpperCase()),
                        ),
                        title: Text(contact.name),
                        subtitle: Text('${contact.phone}\n${contact.email}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.red,
                          onPressed: () => _deleteFavorite(contact),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactDetailsPage(contact: contact),
                            ),
                          ).then((_) => _loadFavorites());
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
