import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/model/pagination.dart';
import 'package:social_media_app/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:social_media_app/presentation/pages/profile/profile_page.dart';
import 'package:social_media_app/presentation/widget/user_card.dart';

void showBottomSheetFollowersFollowings({
  required BuildContext context,
  required String bottomSheetTitle,
  required ProfileEvent event,
  required String noMoreItemsText,
}) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext innerContext) => BlocProvider.value(
      value: context.read<ProfileBloc>(),
      child: FractionallySizedBox(
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
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (profileContext, state) {
                final pagination =
                    bottomSheetTitle.toLowerCase() ==
                        context.l10n.bottomSheetFollowingsTitle
                            .toString()
                            .toLowerCase()
                    ? state.followingsPagination
                    : state.followersPagination;
                return pagination.list.isEmpty
                    ? Center(
                        child: Text(
                          'No ${bottomSheetTitle.toLowerCase()} found',
                        ),
                      )
                    : _usersList(
                        pagination: pagination,
                        event: event,
                        context: context,
                        noMoreItemsText: noMoreItemsText,
                      );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void _showUserProfile({required BuildContext context, required String id}) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ProfilePage(userId: id)),
  );
}

Widget _usersList({
  required BuildContext context,
  required Pagination<UserEntity> pagination,
  required ProfileEvent event,
  required String noMoreItemsText,
}) {
  return NotificationListener<ScrollNotification>(
    onNotification: (scrollInfo) {
      if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200 &&
          pagination.hasMoreToLoad) {
        context.read<ProfileBloc>().add(event);
      }
      return false;
    },
    child: Expanded(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        // need to make text 'no more followers' a part of the this list
        itemCount: pagination.list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == pagination.list.length) {
            if (!pagination.hasMoreToLoad) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  top: 4.0,
                ),
                child: Center(child: Text(noMoreItemsText)),
              );
            } else {
              return SizedBox();
            }
          }

          final user = pagination.list[index];

          return UserCard(
            entity: user,
            onTap: () => _showUserProfile(context: context, id: user.id),
          );
        },
      ),
    ),
  );
}
