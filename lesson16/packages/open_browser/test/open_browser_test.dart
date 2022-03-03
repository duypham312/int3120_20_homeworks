import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_browser/open_browser.dart';

void main() {
  const MethodChannel channel = MethodChannel('open_browser');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OpenBrowser.platformVersion, '42');
  });
}
