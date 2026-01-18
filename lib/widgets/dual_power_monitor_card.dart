import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/colors.dart';

class DualPowerMonitorCard extends StatelessWidget {
  final double cebCurrentAmps;
  final double cebPreviousAmps;
  final double solarCurrentAmps;
  final double solarPreviousAmps;
  final String lastUpdated;
  final bool hasCebOutage;
  final bool hasSolarOutage;
  final List<dynamic>? historicalData;
  final double voltage;
  final double powerWatts;
  final double energyKwh;

  const DualPowerMonitorCard({
    super.key,
    required this.cebCurrentAmps,
    required this.cebPreviousAmps,
    required this.solarCurrentAmps,
    required this.solarPreviousAmps,
    required this.lastUpdated,
    this.hasCebOutage = false,
    this.hasSolarOutage = false,
    this.historicalData,
    this.voltage = 230.0,
    this.powerWatts = 0.0,
    this.energyKwh = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final totalCurrent = cebCurrentAmps;

    return Column(
      children: [
        // Power Outage Alert
        if (hasCebOutage) ...[
          _buildOutageAlert(context, 'CEB Grid Power', AppColors.error),
          const SizedBox(height: 16),
        ],

        // CEB Power Card
        _buildPowerSourceCard(
          context,
          title: 'CEB Grid Power Consumption',
          icon: Icons.electrical_services,
          currentAmps: cebCurrentAmps,
          previousAmps: cebPreviousAmps,
          percentage: 100.0,
          color: const Color(0xFF00AA55),
          gradientColors: [const Color(0xFF00AA55), const Color(0xFF00CC66)],
          isOutage: hasCebOutage,
        ),

        const SizedBox(height: 24),

        // Current Usage Graph
        _buildCombinedGraph(context),

        const SizedBox(height: 20),

        // Summary Stats
        _buildSummaryStats(context, totalCurrent),

        const SizedBox(height: 16),

        // Last Updated
        _buildLastUpdated(context, lastUpdated),
      ],
    );
  }

  Widget _buildOutageAlert(BuildContext context, String source, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$source OUTAGE',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'No current detected',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerSourceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required double currentAmps,
    required double previousAmps,
    required double percentage,
    required Color color,
    required List<Color> gradientColors,
    required bool isOutage,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradientColors),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Real-time consumption',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOutage ? AppColors.error : color,
                      boxShadow: [
                        BoxShadow(
                          color: isOutage ? AppColors.error : color,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Current and Previous Values
              Row(
                children: [
                  Expanded(
                    child: _buildMetricBox(
                      context,
                      'Current',
                      '${currentAmps.toStringAsFixed(5)} A',
                      Icons.bolt,
                      color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricBox(
                      context,
                      'Previous',
                      '${previousAmps.toStringAsFixed(5)} A',
                      Icons.history,
                      Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Mini Line Chart
              SizedBox(
                height: 60,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 2,
                    minY: 0,
                    maxY: (currentAmps * 1.2).clamp(0.001, 1.0),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, previousAmps),
                          FlSpot(1, (previousAmps + currentAmps) / 2),
                          FlSpot(2, currentAmps),
                        ],
                        isCurved: true,
                        gradient: LinearGradient(colors: gradientColors),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.3),
                              color.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedGraph(BuildContext context) {
    final theme = Theme.of(context);

    // Prepare historical data points for CEB only
    List<FlSpot> cebSpots = [];
    double maxY = 0.01;

    if (historicalData != null && historicalData!.isNotEmpty) {
      // Use historical data from Firebase (10-second intervals)
      final dataPoints = historicalData!.take(30).toList(); // Show last 30 readings (5 minutes)

      for (int i = 0; i < dataPoints.length; i++) {
        final reading = dataPoints[i];
        final amps = (reading['amps'] ?? 0).toDouble();

        cebSpots.add(FlSpot(i.toDouble(), amps));

        if (amps > maxY) maxY = amps;
      }
    } else {
      // Fallback to simple 3-point graph with current readings
      cebSpots = [
        FlSpot(0, cebPreviousAmps),
        FlSpot(1, (cebPreviousAmps + cebCurrentAmps) / 2),
        FlSpot(2, cebCurrentAmps),
      ];
      maxY = cebCurrentAmps;
    }

    final maxX = cebSpots.length > 2 ? cebSpots.length.toDouble() - 1 : 2;
    maxY = (maxY * 1.2).clamp(0.01, 100.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CEB Grid Current Usage',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Real-time power consumption - Updates every 10 seconds',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: maxY / 5,
                    verticalInterval: maxX / 6,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.dividerColor.withValues(alpha: 0.5),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: maxX / 6,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) {
                            return const Text(
                              '5m ago',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          } else if (value >= maxX - 1) {
                            return const Text(
                              'Now',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            );
                          } else if ((value % (maxX / 3)).abs() < 0.5) {
                            final secondsAgo = ((maxX - value) * 10).toInt();
                            return Text(
                              '${secondsAgo}s',
                              style: const TextStyle(fontSize: 9, color: Colors.grey),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: maxY / 5,
                        getTitlesWidget: (value, meta) {
                          if (value >= 1.0) {
                            return Text(
                              '${value.toStringAsFixed(1)}A',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Text(
                              '${(value * 1000).toStringAsFixed(0)}mA',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: theme.dividerColor),
                  ),
                  minX: 0,
                  maxX: maxX.toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    // CEB Line
                    LineChartBarData(
                      spots: cebSpots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00AA55), Color(0xFF00CC66)],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: cebSpots.length <= 10,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: const Color(0xFF00CC66),
                            strokeWidth: 1.5,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00AA55).withValues(alpha: 0.3),
                            const Color(0xFF00AA55).withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('CEB Grid Power', const Color(0xFF00AA55)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(BuildContext context, double totalCurrent) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Current readings
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Total Current',
                    '${totalCurrent.toStringAsFixed(5)} A',
                    Icons.power,
                    theme.colorScheme.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Voltage',
                    '${voltage.toStringAsFixed(1)} V',
                    Icons.electrical_services,
                    Colors.blue,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Power',
                    '${powerWatts.toStringAsFixed(1)} W',
                    Icons.bolt,
                    Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Energy and peak reading
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Energy Used',
                    '${energyKwh.toStringAsFixed(3)} kWh',
                    Icons.energy_savings_leaf,
                    Colors.purple,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Previous',
                    '${cebPreviousAmps.toStringAsFixed(5)} A',
                    Icons.history,
                    Colors.grey,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Current',
                    '${cebCurrentAmps.toStringAsFixed(5)} A',
                    Icons.bolt,
                    const Color(0xFF00AA55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLastUpdated(BuildContext context, String time) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            'Last updated: $time',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
