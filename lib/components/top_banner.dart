// top_banner.dart
import 'package:Guard_Room_Application/constraints/colors.dart';
import 'package:flutter/material.dart';

class TopBanner extends StatefulWidget {
  final String message; // Message to display on the banner
  final Duration displayDuration; // Duration for which the banner will be visible

  const TopBanner({
    Key? key,
    required this.message,
    this.displayDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _TopBannerState createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = _createOverlayEntry();
  }

  // Function to create the overlay entry
  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Adjust the top position as needed
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ApplicationColors.BUTTON_COLOR_BLUE,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: ApplicationColors.PURE_BLACK,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: ApplicationColors.PURE_WHITE, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: ApplicationColors.PURE_WHITE),
                    onPressed: () {
                      _removeBanner(); // Remove banner on close button tap
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the banner
  void showBanner(BuildContext context) {
    Overlay.of(context).insert(_overlayEntry);
    // Automatically remove the banner after the specified duration
    Future.delayed(widget.displayDuration, () {
      _removeBanner();
    });
  }

  // Function to remove the banner
  void _removeBanner() {
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }

  @override
  void dispose() {
    _removeBanner(); // Ensure the banner is removed when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // The widget itself doesn't render anything directly
  }
}
