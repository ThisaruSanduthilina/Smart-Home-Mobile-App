import 'package:firebase_database/firebase_database.dart';
import '../models/led_model.dart';
import '../models/curtain_model.dart';
import '../models/power_monitor_model.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // LED Controls
  Stream<Map<String, LedModel>> getLEDsStream() {
    return _database.child('LEDs').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <String, LedModel>{};

      final Map<String, LedModel> leds = {};
      data.forEach((key, value) {
        leds[key.toString()] = LedModel.fromJson(key.toString(), value);
      });
      return leds;
    });
  }

  Future<void> toggleLED(String ledName, bool value) async {
    await _database.child('LEDs/$ledName').set(value ? 1 : 0);
  }

  // Curtain Controls
  Stream<CurtainModel> getCurtainStream() {
    return _database.child('curtain').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return CurtainModel(
          actual: 0,
          cmd: '',
          position: 0,
          state: 'unknown',
          status: 'unknown',
          value: 0,
        );
      }
      return CurtainModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  Future<void> openCurtain() async {
    await _database.child('curtain/cmd').set('open');
  }

  Future<void> closeCurtain() async {
    await _database.child('curtain/cmd').set('close');
  }

  Future<void> stopCurtain() async {
    await _database.child('curtain/cmd').set('stop');
  }

  Future<void> setCurtainPosition(int position) async {
    await _database.child('curtain/value').set(position);
  }

  // Power Monitor - CEB Grid Electricity Meter
  Stream<PowerMonitorModel> getPowerMonitorStream() {
    return _database.child('ct_monitor').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return PowerMonitorModel(
          currentAmps: 0,
          lastUpdated: 0,
          previousAmps: 0,
          voltage: 230.0,
          powerWatts: 0.0,
          energyKwh: 0.0,
        );
      }

      // Convert the data to proper format
      final currentAmps = (data['current_amps'] ?? 0).toDouble();
      final voltage = 230.0; // Standard CEB voltage

      return PowerMonitorModel(
        currentAmps: currentAmps,
        lastUpdated: data['last_updated'] ?? 0,
        previousAmps: (data['previous_amps'] ?? 0).toDouble(),
        voltage: voltage,
        powerWatts: currentAmps * voltage, // Calculate power
        energyKwh: 0.0, // Can be calculated if needed
        historicalData: [], // Will be added when you implement history in database
      );
    });
  }

  // Get CEB Grid Power reading - same as above for now
  Stream<PowerMonitorModel> getCEBPowerStream() {
    return getPowerMonitorStream();
  }

  // Get all data for dashboard
  Stream<Map<String, dynamic>> getDashboardStream() {
    return _database.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <String, dynamic>{};
      return Map<String, dynamic>.from(data);
    });
  }

  // Chat command processor
  Future<String> processCommand(String command) async {
    final cmd = command.toLowerCase().trim();

    // LED commands
    if (cmd.contains('turn on') || cmd.contains('switch on')) {
      final ledMatch = _extractLedName(cmd);
      if (ledMatch != null) {
        await toggleLED(ledMatch, true);
        return 'Turned on $ledMatch';
      }
    }

    if (cmd.contains('turn off') || cmd.contains('switch off')) {
      final ledMatch = _extractLedName(cmd);
      if (ledMatch != null) {
        await toggleLED(ledMatch, false);
        return 'Turned off $ledMatch';
      }
    }

    // Curtain commands
    if (cmd.contains('open curtain') || cmd.contains('open the curtain')) {
      await openCurtain();
      return 'Opening curtain';
    }

    if (cmd.contains('close curtain') || cmd.contains('close the curtain')) {
      await closeCurtain();
      return 'Closing curtain';
    }

    if (cmd.contains('stop curtain') || cmd.contains('stop the curtain')) {
      await stopCurtain();
      return 'Stopped curtain';
    }

    // Status commands
    if (cmd.contains('status') || cmd.contains('power') || cmd.contains('current')) {
      final snapshot = await _database.child('ct_monitor').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final monitor = PowerMonitorModel.fromJson(data);
        return 'Current: ${monitor.currentAmps.toStringAsFixed(5)}A\nLast updated: ${monitor.lastUpdatedTime}';
      }
    }

    return 'Sorry, I didn\'t understand that command. Try:\n- Turn on/off LED1-4\n- Open/close curtain\n- Check power status';
  }

  String? _extractLedName(String command) {
    final ledPattern = RegExp(r'led[1-4]|lobby.*led[1-2]', caseSensitive: false);
    final match = ledPattern.firstMatch(command);
    if (match != null) {
      final ledName = match.group(0)!.toUpperCase();
      if (ledName.contains('LOBBY')) {
        return ledName.replaceAll(' ', '_');
      }
      return ledName;
    }
    return null;
  }
}
