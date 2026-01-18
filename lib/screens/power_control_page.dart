import 'package:flutter/material.dart';
import 'dart:async';
import '../services/firebase_service.dart';
import '../widgets/dual_power_monitor_card.dart';

class PowerControlPage extends StatefulWidget {
  const PowerControlPage({super.key});

  @override
  State<PowerControlPage> createState() => _PowerControlPageState();
}

class _PowerControlPageState extends State<PowerControlPage> {
  final FirebaseService _firebaseService = FirebaseService();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up automatic refresh every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          // Trigger rebuild to fetch latest data from Firebase stream
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(
              Icons.electrical_services,
              color: theme.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Power Control',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Electricity Meter Monitoring',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Real-time CEB grid power consumption - Updates every 10 seconds',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              StreamBuilder(
                stream: _firebaseService.getPowerMonitorStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading power data...',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  final powerData = snapshot.data!;
                  // Use actual CEB grid readings from Firebase
                  final cebCurrent = powerData.currentAmps;
                  final cebPrevious = powerData.previousAmps;

                  // Convert historical data to list format for the widget
                  final historicalDataList = powerData.historicalData.map((reading) {
                    return {
                      'timestamp': reading.timestamp,
                      'amps': reading.amps,
                      'voltage': reading.voltage,
                      'watts': reading.watts,
                    };
                  }).toList();

                  return DualPowerMonitorCard(
                    cebCurrentAmps: cebCurrent,
                    cebPreviousAmps: cebPrevious,
                    solarCurrentAmps: 0.0, // Not using solar
                    solarPreviousAmps: 0.0, // Not using solar
                    lastUpdated: powerData.lastUpdatedTime,
                    hasCebOutage: cebCurrent < 0.001,
                    hasSolarOutage: true, // Hide solar card
                    historicalData: historicalDataList,
                    voltage: powerData.voltage,
                    powerWatts: powerData.powerWatts,
                    energyKwh: powerData.energyKwh,
                  );
                },
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                context,
                'About CEB Grid Power Monitoring',
                'This system monitors CEB grid electricity consumption in real-time using a current transformer (CT) sensor. '
                'Data is updated every 10 seconds from Firebase and displayed in the graph showing usage over time. '
                'Monitor current (Amperes), voltage (Volts), power consumption (Watts), and total energy used (kWh). '
                'The graph shows your actual electricity usage from the CEB grid connection.',
                Icons.info_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
