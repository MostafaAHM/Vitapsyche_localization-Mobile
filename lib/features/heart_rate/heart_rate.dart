import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:math';

class HeartRateMonitor extends StatefulWidget {
  @override
  _HeartRateMonitorState createState() => _HeartRateMonitorState();
}

class _HeartRateMonitorState extends State<HeartRateMonitor>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isMeasuring = false;
  AudioPlayer _audioPlayer = AudioPlayer();
  int? _heartRate;
  AnimationController? _animationController;
  Animation<double>? _animation;
  int _countdown = 15; // Countdown timer in seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras!.first,
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _startMeasurement() async {
    setState(() {
      _isMeasuring = true;
      _heartRate = null;
      _countdown = 15; // Reset countdown
    });

    await _cameraController!.setFlashMode(FlashMode.torch);
    await _audioPlayer.play(AssetSource('assets/audio/heartbeat.mp3'));
    _animationController!.forward(from: 0);
    _startCountdown();

    await Future.delayed(Duration(seconds: 15));
    await _cameraController!.setFlashMode(FlashMode.off);

    setState(() {
      _isMeasuring = false;
      _heartRate = 75; // Simulated heart rate value
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Selected: ${pickedFile.path}')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioPlayer.dispose();
    _animationController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Rate Monitor'),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.redAccent, Colors.deepOrangeAccent],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _cameraController == null ||
                        !_cameraController!.value.isInitialized
                    ? CircularProgressIndicator()
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipPath(
                            clipper: HeartClipper(),
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CameraPreview(_cameraController!),
                            ),
                          ),
                          if (_isMeasuring)
                            AnimatedBuilder(
                              animation: _animationController!,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _animation!.value,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          if (_isMeasuring)
                            Positioned(
                              bottom: 10,
                              child: Text(
                                '$_countdown',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
            _isMeasuring
                ? Column(
                    children: [
                      SizedBox(height: 20),
                      Text('Measuring...',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  )
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _startMeasurement,
                        child: Text('Start Measurement'),
                      ),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image from Gallery'),
                      ),
                    ],
                  ),
            if (_heartRate != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Heart Rate: $_heartRate BPM',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height / 5);
    path.cubicTo(
      size.width / 2,
      size.height / 5,
      size.width,
      0,
      size.width,
      size.height / 3.5,
    );
    path.cubicTo(
      size.width,
      size.height / 2.5,
      size.width / 1.5,
      size.height / 1.5,
      size.width / 2,
      size.height,
    );
    path.cubicTo(
      size.width / 2.5,
      size.height / 1.5,
      0,
      size.height / 2.5,
      0,
      size.height / 3.5,
    );
    path.cubicTo(
      0,
      0,
      size.width / 2,
      size.height / 5,
      size.width / 2,
      size.height / 5,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
