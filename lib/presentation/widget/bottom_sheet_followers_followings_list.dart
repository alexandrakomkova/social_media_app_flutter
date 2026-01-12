import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';
import 'package:social_media_app/presentation/widget/user_card.dart';

void showBottomSheetCreationVariants({
  required BuildContext context,
  required String bottomSheetTitle,
  required List<UserEntity> users,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  bottomSheetTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),

            Divider(),

            Expanded(
              child: users.isEmpty
                  ? Center(
                      child: Text('No ${bottomSheetTitle.toLowerCase()} found'),
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = users[index];

                        return UserCard(
                          entity: user,
                          onTap: () =>
                              _showUserProfile(context: context, id: user.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}

void _showUserProfile({required BuildContext context, required String id}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProfilePage(userId: id)),
  );
}
