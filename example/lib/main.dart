import 'package:feature_overlay_tour/feature_overlay_tour.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeatureOverlayTour(
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    return FeatureOverlayTourTarget(
                      key: GlobalKey(),
                      order: 0,
                      onItemTap: () {
                        FeatureOverlayTourScope.once(context).controller.close();
                      },
                      overlay: FeatureOverlayTourTooltip(
                        allowSize: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.white.withOpacity(0.5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  FeatureOverlayTourScope.once(context).controller.next();
                                },
                                child: const Text('next'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          FeatureOverlayTourScope.once(context).controller.launch();
                        },
                        child: const Text('Overlay'),
                      ),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    return FeatureOverlayTourTarget(
                      key: GlobalKey(),
                      shape: const CircleBorder(eccentricity: 1.0),
                      overlayPadding: const EdgeInsets.all(20),
                      order: 1,
                      onItemTap: () {
                        FeatureOverlayTourScope.once(context).controller.close();
                      },
                      overlay: FeatureOverlayTourTooltip(
                        allowSize: 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.white.withOpacity(0.5),
                          child: const Text('Container2'),
                        ),
                      ),
                      child: const Text('Overlay'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
