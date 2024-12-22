import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
    );
  }

  // Builds the app bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildLeadingBar(context),
          buildTrailingBar(context),
        ],
      ),
      actions: [
        buildLogoutButton(),
      ],
    );
  }

  // Builds the leading part of the app bar
  Row buildLeadingBar(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.rocket_launch,
          size: 32,
        ),
        const SizedBox(width: 8),
        Text(
          'Cockpit',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ],
    );
  }

  // Builds the trailing part of the app bar
  Text buildTrailingBar(BuildContext context) {
    return Text(
      'Logged in as ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
    );
  }

  // Builds the logout button
  IconButton buildLogoutButton() {
    return IconButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      icon: const Icon(Icons.logout),
    );
  }
}
