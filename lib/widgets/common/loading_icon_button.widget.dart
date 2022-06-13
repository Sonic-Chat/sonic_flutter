import 'package:flutter/material.dart';

class LoadingIconButton extends StatelessWidget {
  final bool connected;
  final bool loading;
  final VoidCallback onFormSubmit;

  final Icon icon;

  const LoadingIconButton({
    Key? key,
    required this.connected,
    required this.loading,
    required this.onFormSubmit,
    this.icon = const Icon(Icons.edit),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !loading
        ? IconButton(
            onPressed: connected
                ? !loading
                    ? onFormSubmit
                    : null
                : null,
            icon: icon,
          )
        : const SizedBox(
            child: CircularProgressIndicator(),
            height: 26,
            width: 26,
          );
  }
}
