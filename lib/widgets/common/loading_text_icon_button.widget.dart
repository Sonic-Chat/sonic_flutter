import 'package:flutter/material.dart';

class LoadingTextIconButton extends StatelessWidget {
  final bool connected;
  final bool loading;
  final VoidCallback onFormSubmit;

  final String text;
  final String loadingText;

  final Icon icon;

  const LoadingTextIconButton({
    Key? key,
    required this.connected,
    required this.loading,
    required this.onFormSubmit,
    required this.text,
    required this.loadingText,
    this.icon = const Icon(Icons.edit),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: connected
          ? !loading
              ? onFormSubmit
              : null
          : null,
      label: Text(
        connected
            ? !loading
                ? text
                : loadingText
            : 'You are offline',
      ),
      icon: connected
          ? !loading
              ? icon
              : SizedBox(
                  height: MediaQuery.of(context).size.longestSide * 0.025,
                  width: MediaQuery.of(context).size.longestSide * 0.025,
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                )
          : const Icon(
              Icons.offline_bolt_outlined,
            ),
    );
  }
}
