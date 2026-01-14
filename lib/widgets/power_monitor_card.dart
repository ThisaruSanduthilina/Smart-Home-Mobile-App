import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/colors.dart';
import '../models/power_monitor_model.dart';

class PowerMonitorCard extends StatelessWidget {
  final PowerMonitorModel powerMonitor;

  const PowerMonitorCard({
    super.key,
    required this.powerMonitor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  powerMonitor.hasPowerOutage
                      ? Icons.power_off
                      : Icons.electrical_services,
                  size: 32,
                  color: powerMonitor.hasPowerOutage
                      ? AppColors.error
                      : primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Power Monitor',
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (powerMonitor.hasPowerOutage)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POWER OUTAGE DETECTED',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No current detected',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    context,
                    'Current',
                    '${powerMonitor.currentAmps.toStringAsFixed(5)} A',
                    Icons.bolt,
                    AppColors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    context,
                    'Previous',
                    '${powerMonitor.previousAmps.toStringAsFixed(5)} A',
                    Icons.history,
                    AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Last Updated',
              powerMonitor.lastUpdatedTime,
              Icons.access_time,
              AppColors.greyText,
            ),
            const SizedBox(height: 20),
            Text(
              'Current Flow',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.002,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.lightGrey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  minX: 0,
                  maxX: 2,
                  minY: 0,
                  maxY: (powerMonitor.currentAmps * 1.2).clamp(0.01, 1.0),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, powerMonitor.previousAmps),
                        FlSpot(1, (powerMonitor.previousAmps + powerMonitor.currentAmps) / 2),
                        FlSpot(2, powerMonitor.currentAmps),
                      ],
                      isCurved: true,
                      color: AppColors.green,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.green,
                            strokeWidth: 2,
                            strokeColor: AppColors.black,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.greenGlow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.mediumGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
