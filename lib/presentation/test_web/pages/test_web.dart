import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:test_web/presentation/test_web/widgets/test_button.dart';
import 'package:test_web/presentation/test_web/widgets/test_text_field.dart';

class TestWeb extends StatefulWidget {
  const TestWeb({super.key});

  @override
  State<TestWeb> createState() => _TestWebState();
}

class _TestWebState extends State<TestWeb> {
  late final List<GlobalKey<FormState>> _formKeys;

  double _latitude = 0;
  double _longitude = 0;
  double _zoom = 0;
  var _x = 0;
  var _y = 0;
  var _url = '';

  int _lon2tile(double lon, int zoom) {
    try {
      return ((lon + 180) / 360 * math.pow(2, zoom)).round();
    } catch (_) {
      return -1;
    }
  }

  int _lat2tile(double lat, int zoom) {
    try {
      final radians = lat * math.pi / 180;
      return ((1 -
                  math.log(math.tan(radians) + 1 / math.cos(radians)) /
                      math.pi) /
              2 *
              math.pow(2, zoom))
          .round();
    } catch (_) {
      return -1;
    }
  }

  List<int> _countCoordinates() {
    setState(() {
      _x = _lon2tile(_longitude, _zoom.toInt());
      _y = _lat2tile(_latitude, _zoom.toInt());
    });

    return [_x, _y, _zoom.toInt()];
  }

  String _buildTileURL(int x, int y, int zoom) {
    const baseURL =
        'https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles';
    const layer = 'carparks';
    const scale = '1';
    const lang = 'ru_RU';

    return '$baseURL?l=$layer&x=$x&y=$y&z=$zoom&scale=$scale&lang=$lang';
  }

  void _onCountButtonTap() {
    final coordinates = _countCoordinates();
    setState(
      () => _url = _buildTileURL(
        coordinates[0],
        coordinates[1],
        coordinates[2],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _formKeys = List.generate(
      3,
      (_) => GlobalKey<FormState>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тестовое'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    'You need to enter longitude and latitude coordinates, you can also specify the map zoom',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TestTextField(
                    label: 'Latitude coordinate',
                    onChanged: (value) => setState(() => _latitude = value),
                    formKey: _formKeys.first,
                  ),
                  TestTextField(
                    label: 'Longitude coordinate',
                    onChanged: (value) => setState(() => _longitude = value),
                    formKey: _formKeys[1],
                  ),
                  TestTextField(
                    label: 'Map\'s zoom',
                    onChanged: (value) => setState(() => _zoom = value),
                    formKey: _formKeys.last,
                  ),
                  const Spacer(),
                  TestButton(
                    onTap: () {
                      final firstValid =
                          _formKeys.first.currentState!.validate();
                      final secondValid = _formKeys[1].currentState!.validate();
                      final thirdValid =
                          _formKeys.last.currentState!.validate();
                      if (!firstValid || !secondValid || !thirdValid) return;

                      _onCountButtonTap();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    'A tile will be displayed here if one is found, as well as the calculated coordinates',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  if (_url.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Image.network(
                      _url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, error, stackTrace) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 700,
                              height: 400,
                              child: Image.network(
                                'https://img.gazeta.ru/files3/933/14275933/stepan-pic_32ratio_900x600-900x600-67361.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Text(
                              'Tile not found. Cat for vivacity. Try again!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                    const Spacer(),
                    Text(
                      'X coordinate is $_x\nY coordinate is $_y,\nZoom is $_zoom',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
