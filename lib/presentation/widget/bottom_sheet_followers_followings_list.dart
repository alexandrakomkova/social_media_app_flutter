import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

void showBottomSheetCreationVariants({
  required BuildContext context,
  required String bottomSheetTitle,
  required List<UserEntity> users,
}) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
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
                        ? Center( child: Text('No ${bottomSheetTitle.toLowerCase()} found'))
                        : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        var user = users[index];

                        return ListTile(
                          leading: ProfileAvatar(
                            radius: 20.0,
                            userEntity: UserEntity(
                                username: user.username,
                                photoUrl: user.photoUrl
                            ),
                          ),
                          title: Text(
                              user.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          subtitle: Text(
                            user.bio,
                            overflow: TextOverflow.ellipsis,
                          ),
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