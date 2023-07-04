import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationsController {
  success(message) {
    showSimpleNotification(
      Text(message, style: const TextStyle(color: Colors.white)),
      trailing: Builder(builder: (context) {
        return TextButton(
          onPressed: () { OverlaySupportEntry.of(context)!.dismiss(); },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white))
        );
      }),
      background: Colors.green
    );
  }

  info(message) {
    showSimpleNotification(
      Text(message, style: const TextStyle(color: Colors.white)),
      trailing: Builder(builder: (context) {
        return TextButton(
          onPressed: () { OverlaySupportEntry.of(context)!.dismiss(); },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white))
        );
      }),
      background: Colors.lightBlue,
      autoDismiss: false
    );
  }

  warning(message) {
    showSimpleNotification(
      Text(message, style: const TextStyle(color: Colors.white)),
      trailing: Builder(builder: (context) {
        return TextButton(
          onPressed: () { OverlaySupportEntry.of(context)!.dismiss(); },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white))
        );
      }),
      background: Colors.orange
    );
  }

  error(message) {
    showSimpleNotification(
      Text(message, style: const TextStyle(color: Colors.white)),
      trailing: Builder(builder: (context) {
        return TextButton(
          onPressed: () { OverlaySupportEntry.of(context)!.dismiss(); },
          child: const Text('Dismiss', style: TextStyle(color: Colors.white))
        );
      }),
      background: Colors.red,
      autoDismiss: false
    );
  }
}