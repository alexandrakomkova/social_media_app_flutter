import 'package:flutter/material.dart';
import 'package:social_media_app/l10n/l10n.dart';

import 'bottom_sheet_list_tile.dart';

void showBottomSheetToChooseImageSource({
  required BuildContext context,
  required void Function()? onCameraTap,
  required void Function()? onGalleryTap,
}) {
  final l10n = context.l10n;

  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius:
      BorderRadius.vertical(top: Radius.circular(20)),
    ),
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: .6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  l10n.bottomSheetImageSourceTitle,
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
              title: l10n.bottomSheetImageSourceOptionCamera,
              onTap: onCameraTap,
            ),
            BottomSheetListTile(
              icon: Icons.image,
              title: l10n.bottomSheetImageSourceOptionGallery,
              onTap: onGalleryTap,
            ),
          ],
        ),
      );
    },
  );
}
