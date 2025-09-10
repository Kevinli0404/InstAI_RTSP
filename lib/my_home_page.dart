// import 'package:example/recording_page.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _rtmpUrlController = TextEditingController(
//     text: 'rtmp://ns8.indexforce.com/home/mystream', // 預設值，可移除
//   );

//   @override
//   void dispose() {
//     _rtmpUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _rtmpUrlController,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter URL',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_rtmpUrlController.text.isEmpty) {
//                     Fluttertoast.showToast(msg: '請輸入 URL');
//                     return;
//                   }
//                   // 導航到第二頁，並傳遞 URL
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           RecordingPage(url: _rtmpUrlController.text),
//                     ),
//                   );
//                 },
//                 child: const Text('載入'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
