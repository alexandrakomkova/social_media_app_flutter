import 'package:flutter/material.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/widget/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final UserEntity userEntity;

  const UserCard({
    required this.userEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAvatar(
              radius: 30.0,
              userEntity: userEntity,
          ),
          SizedBox(width: 15.0,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userEntity.username ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),

               Expanded(
                 child: Text(
                    userEntity.bio ?? '',
                    style: TextStyle(
                        fontSize: 16,
                    ),
                     overflow: TextOverflow.ellipsis
                  ),
               ),

            ],
          )
        ],
      ),
    );
  }
}
