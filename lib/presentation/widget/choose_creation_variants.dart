
import 'package:flutter/material.dart';
import 'package:social_media_app/l10n/l10n.dart';
import 'package:social_media_app/presentation/pages/create_post/create_post_page.dart';
import 'package:social_media_app/presentation/widget/bottom_sheet_list_tile.dart';

void showBottomSheetCreationVariants(BuildContext context) {
  final l10n = context.l10n;

  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      showDragHandle: true,
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: Text(
                    l10n.bottomSheetCreateTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              Divider(),
              BottomSheetListTile(
                icon: Icons.camera_alt,
                title: l10n.bottomSheetCreateOptionPost,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CreatePostPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
  );
}
