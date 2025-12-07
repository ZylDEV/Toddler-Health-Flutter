import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/navbar.dart';
import '../widgets/topbar.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/notification/floating_notification.dart';
import 'rekam_medis_page.dart';
import 'imunisasi_page.dart';
import 'jadwal_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, String> userData;
  const MainPage({super.key, required this.userData});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  bool _showNotifications = false;
  late final PageController _pageController;
  late final List<Widget> _pages;

  final List<String> _titles = ["Rekam Medis", "Data Imunisasi", "Jadwal"];
  final List<Map<String, dynamic>> _notifications = [];
  final DatabaseReference _jadwalRef = FirebaseDatabase.instance.ref('jadwal');

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
    _pages = [
      RekamMedisPage(userData: widget.userData),
      ImunisasiPage(userData: widget.userData),
      JadwalPage(userData: widget.userData),
    ];

    _requestNotificationPermission();
    _initLocalNotifications();
    _setupJadwalListener();
    _setupFCMListener();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        debugPrint("Notification permission denied!");
      }
    }
  }

  void _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        _onTap(2);
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'jadwal_channel',
      'Jadwal Notifications',
      description: 'Notifikasi untuk update jadwal',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _showLocalNotification(String message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'jadwal_channel',
      'Jadwal Notifications',
      channelDescription: 'Notifikasi untuk update jadwal',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Update Jadwal',
      message,
      details,
    );
  }

  void _setupJadwalListener() async {
    final snapshot = await _jadwalRef.get();
    List<String> existingIds = [];
    if (snapshot.exists) {
      final allData = Map<String, dynamic>.from(snapshot.value as Map);
      existingIds = allData.keys.map((e) => e.toString()).toList();
    }

    _jadwalRef.onChildAdded.listen((event) {
      final key = event.snapshot.key;
      if (existingIds.contains(key)) return;

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final notifTitle =
          "${data['deskripsiKegiatan']} pukul ${data['waktuPelaksanaan']}";
      setState(() => _notifications.add({"title": notifTitle}));
      _showLocalNotification(notifTitle);
    });

    _jadwalRef.onChildChanged.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final notifTitle =
          "[Update] ${data['deskripsiKegiatan']} pukul ${data['waktuPelaksanaan']}";
      setState(() => _notifications.add({"title": notifTitle}));
      _showLocalNotification(notifTitle);
    });
  }

  void _setupFCMListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "Update Jadwal";
      final body = message.notification?.body ?? "";
      _showLocalNotification("$title\n$body");
      setState(() {
        _notifications.add({"title": "$title\n$body"});
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentIndex = index;
      _showNotifications = false;
    });
  }

  void _onNotificationPressed() {
    setState(() {
      _showNotifications = !_showNotifications;
      // Jangan clear semua notifikasi saat panel dibuka
    });
  }

  void _onTapNotificationItem(Map<String, dynamic> notif) {
    _onTap(2); // langsung ke page Jadwal
    setState(() {
      _notifications.remove(notif); // hapus notif yang ditekan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: NavBar(userData: widget.userData),
          appBar: TopBar(
            title: _titles[_currentIndex],
            notificationCount: _notifications.length,
            onNotificationPressed: _onNotificationPressed,
          ),
          body: PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: _pages,
          ),
          bottomNavigationBar: BottomBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
          ),
        ),
        FloatingNotification(
          visible: _showNotifications,
          notifications: _notifications,
          onTapItem: _onTapNotificationItem,
          topOffset: kToolbarHeight + 32,
        ),
      ],
    );
  }
}
