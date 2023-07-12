import 'package:flutter/material.dart';

final class TestButton extends StatefulWidget {
  final VoidCallback onTap;

  const TestButton({
    required this.onTap,
    super.key,
  });

  @override
  State<TestButton> createState() => _TestButtonState();
}

class _TestButtonState extends State<TestButton> {
  var _onRegion = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _onRegion = true),
      onExit: (_) => setState(() => _onRegion = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          margin: const EdgeInsets.all(8),
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(32),
              ),
              color: _onRegion ? Colors.grey.shade800 : Colors.grey.shade600),
          child: const Center(
            child: Text(
              'Count',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
