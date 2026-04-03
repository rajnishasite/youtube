import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const GpsTrackerApp());
}

class GpsTrackerApp extends StatelessWidget {
  const GpsTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TrackerScreen(),
    );
  }
}

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final MapController _mapController = MapController();
  final Distance _distance = const Distance();

  StreamSubscription<Position>? _positionSubscription;
  final List<LatLng> _trackPoints = [];

  bool _tracking = false;
  String _status = 'Tap Start Tracking';
  double _totalDistanceMeters = 0;
  DateTime? _startedAt;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _ensurePermissions() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required for tracking.');
    }
  }

  Future<void> _startTracking() async {
    try {
      await _ensurePermissions();

      setState(() {
        _tracking = true;
        _status = 'Tracking in progress...';
        _trackPoints.clear();
        _totalDistanceMeters = 0;
        _startedAt = DateTime.now();
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _startedAt == null) return;
        setState(() => _elapsed = DateTime.now().difference(_startedAt!));
      });

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      );

      _positionSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((position) {
        final point = LatLng(position.latitude, position.longitude);

        setState(() {
          if (_trackPoints.isNotEmpty) {
            _totalDistanceMeters += _distance(_trackPoints.last, point);
          }
          _trackPoints.add(point);
        });

        _mapController.move(point, 17);
      }, onError: (error) {
        setState(() => _status = 'Tracking error: $error');
      });
    } catch (e) {
      setState(() {
        _tracking = false;
        _status = 'Unable to start tracking: $e';
      });
    }
  }

  Future<void> _stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _timer?.cancel();

    setState(() {
      _tracking = false;
      _status = 'Tracking stopped';
    });
  }

  String get _distanceLabel {
    if (_totalDistanceMeters >= 1000) {
      return '${(_totalDistanceMeters / 1000).toStringAsFixed(2)} km';
    }
    return '${_totalDistanceMeters.toStringAsFixed(0)} m';
  }

  String get _elapsedLabel {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final center = _trackPoints.isNotEmpty
        ? _trackPoints.last
        : const LatLng(37.7749, -122.4194);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.gps_tracker',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _trackPoints,
                      strokeWidth: 5,
                      color: Colors.indigo,
                    ),
                  ],
                ),
                if (_trackPoints.isNotEmpty)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _trackPoints.last,
                        width: 45,
                        height: 45,
                        child: const Icon(
                          Icons.my_location,
                          size: 36,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $_status'),
                const SizedBox(height: 8),
                Text('Distance: $_distanceLabel'),
                Text('Elapsed: $_elapsedLabel'),
                if (_startedAt != null)
                  Text(
                    'Started: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_startedAt!.toLocal())}',
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _tracking ? null : _startTracking,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Tracking'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _tracking ? _stopTracking : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop Tracking'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
