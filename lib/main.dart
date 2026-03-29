import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Web3DPage(),
    );
  }
}

class Web3DPage extends StatefulWidget {
  const Web3DPage({super.key});

  @override
  State<Web3DPage> createState() => _Web3DPageState();
}

class _Web3DPageState extends State<Web3DPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_html);
  }

  final String _html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>body { margin:0; }</style>
</head>
<body>
<canvas id="c"></canvas>

<script src="https://cdn.jsdelivr.net/npm/three@0.152.2/build/three.min.js"></script>

<script>
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000);

const renderer = new THREE.WebGLRenderer({canvas: document.getElementById('c')});
renderer.setSize(window.innerWidth, window.innerHeight);

const geometry = new THREE.PlaneGeometry(10, 10, 50, 50);

for (let i = 0; i < geometry.attributes.position.count; i++) {
  const y = Math.sin(i * 0.3) * 0.5;
  geometry.attributes.position.setZ(i, y);
}

const material = new THREE.MeshBasicMaterial({
  color: 0x00ffcc,
  wireframe: true
});

const plane = new THREE.Mesh(geometry, material);
scene.add(plane);

camera.position.z = 5;

function animate() {
  requestAnimationFrame(animate);
  plane.rotation.z += 0.003;
  renderer.render(scene, camera);
}

animate();
</script>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3D Scanner")),
      body: WebViewWidget(controller: controller),
    );
  }
}
