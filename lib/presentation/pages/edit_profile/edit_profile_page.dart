import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _EditProfileView();
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('edit profile'),
    );
  }
}
