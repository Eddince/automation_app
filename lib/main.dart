import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskSchedulerScreen(),
    );
  }
}

class TaskSchedulerScreen extends StatefulWidget {
  @override
  _TaskSchedulerScreenState createState() => _TaskSchedulerScreenState();
}

class _TaskSchedulerScreenState extends State<TaskSchedulerScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    await notificationsPlugin.initialize(InitializationSettings(android: initializationSettingsAndroid));
  }

  Future<void> _scheduleTask() async {
    // 1. Activar el servicio de accesibilidad (necesita configuración manual en Android)
    final AndroidIntent intent = AndroidIntent(
      action: 'android.settings.ACCESSIBILITY_SETTINGS',
    );
    await intent.launch();

    // 2. Programar notificación para recordar la tarea
    await _showNotification(
      "Tarea programada",
      "La automatización se ejecutará a las ${selectedTime.format(context)}",
    );
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id', 'Automator Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    await notificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Automator App")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Hora programada: ${selectedTime.format(context)}"),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text("Seleccionar Hora"),
            ),
            ElevatedButton(
              onPressed: _scheduleTask,
              child: Text("Iniciar Automatización"),
            ),
          ],
        ),
      ),
    );
  }
}