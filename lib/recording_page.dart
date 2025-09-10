// class RecordingPage extends StatefulWidget {
//   final String url;

//   const RecordingPage({super.key, required this.url});

//   @override
//   State<RecordingPage> createState() => _RecordingPageState();
// }

// class _RecordingPageState extends State<RecordingPage> {
//   String logString = 'Logs will appear here...';
//   bool isProcessing = false;
//   String ffmpegOutput = '';
//   FFmpegSession? _session;
//   String? _outputPath; // 用來追蹤輸出檔案路徑
//   late VlcPlayerController _vlcController;

//   @override
//   void initState() {
//     super.initState();
//     _vlcController = VlcPlayerController.network(
//       widget.url,
//       autoPlay: true,
//       hwAcc: HwAcc.full,
//       options: VlcPlayerOptions(),
//     );
//   }

//   @override
//   void dispose() {
//     _vlcController.dispose();
//     super.dispose();
//   }

//   // 保存視頻到媒體庫（使用 Gal 套件）
//   Future<String> _saveVideoToLocal(String tempPath) async {
//     try {
//       // 先檢查並請求 Gal 的存取權限（Gal 會處理 Permission.photos 和 Permission.videos）
//       bool hasAccess = await Gal.hasAccess();
//       if (!hasAccess) {
//         hasAccess = await Gal.requestAccess();
//         if (!hasAccess) {
//           Fluttertoast.showToast(msg: '無法取得媒體儲存權限，請在設定中授予');
//           print('媒體儲存權限未授予');
//           return tempPath; // 如果權限未授予，返回臨時路徑
//         }
//       }

//       // 使用 Gal 保存影片到媒體庫（會出現在 Downloads 或 Videos 資料夾）
//       await Gal.putVideo(tempPath);
//       print('影片已保存到媒體庫');

//       // 顯示成功訊息
//       Fluttertoast.showToast(msg: '影片已保存到 Downloads 或 Videos 資料夾');
//       return '媒體庫路徑（透過畫廊或檔案管理器查看）';
//     } catch (e) {
//       print('影片儲存失敗: $e');
//       Fluttertoast.showToast(msg: '儲存失敗: $e');
//       return tempPath; // 如果失敗，返回臨時路徑
//     }
//   }

//   void startRecording() async {
//     setState(() {
//       isProcessing = true;
//       logString = 'Starting RTMP recording...\n\n';
//       ffmpegOutput = '';
//       _outputPath = null; // 重置輸出路徑
//     });

//     try {
//       final tempDir = await getTemporaryDirectory();
//       _outputPath =
//           '${tempDir.path}/rtmp_video_${DateTime.now().millisecondsSinceEpoch}.mp4';

//       // FFmpeg 命令：從 RTMP 錄製，複製碼流到 MP4（可調整時間或參數）
//       final command =
//           '-i ${widget.url} -c:v copy -c:a aac -movflags +faststart -y $_outputPath';

//       setState(() {
//         logString += 'Command: $command\n\n';
//         logString += 'Recording...\n';
//       });

//       _session = await FFmpegKit.executeAsync(
//         command,
//         (Session session) async {
//           final returnCode = await session.getReturnCode();

//           setState(() {
//             isProcessing = false;
//             _session = null;
//           });

//           if (ReturnCode.isSuccess(returnCode)) {
//             final savedPath = await _saveVideoToLocal(_outputPath!);
//             setState(() {
//               ffmpegOutput = 'Success! Recorded video at: $savedPath';
//             });
//           } else if (ReturnCode.isCancel(returnCode)) {
//             // 取消時也嘗試保存
//             if (_outputPath != null && await File(_outputPath!).exists()) {
//               final savedPath = await _saveVideoToLocal(_outputPath!);
//               setState(() {
//                 ffmpegOutput =
//                     'Recording stopped by user. Saved at: $savedPath';
//               });
//             } else {
//               setState(() {
//                 ffmpegOutput = 'Recording stopped by user. No file saved.';
//               });
//             }
//           } else {
//             setState(() {
//               ffmpegOutput =
//                   'Error! FFmpeg process failed with code: ${returnCode?.getValue() ?? 'unknown'}';
//             });
//           }
//         },
//         (Log log) {
//           setState(() {
//             logString += '${log.getMessage()}\n';
//           });
//           print('FFmpeg Log: ${log.getMessage()}');
//         },
//         (Statistics statistics) {
//           setState(() {
//             logString +=
//                 'Progress: ${statistics.getSize()} bytes, ${statistics.getTime()}ms\n';
//           });
//           print('FFmpeg Progress: ${statistics.getTime()} ms');
//         },
//       );
//     } catch (e) {
//       setState(() {
//         logString += '\n❌ Error: $e\n';
//         isProcessing = false;
//         _session = null;
//       });
//     }
//   }

//   void stopRecording() {
//     if (_session != null) {
//       _session!.cancel();
//       setState(() {
//         logString += 'Stopping recording...\n';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Recording Page'),
//       ),
//       body: Column(
//         children: [
//           // 顯示 RTMP 播放器
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: VlcPlayer(
//               controller: _vlcController,
//               aspectRatio: 16 / 9,
//               placeholder: const Center(child: CircularProgressIndicator()),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     Text(
//                       logString,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontFamily: 'monospace',
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       ffmpegOutput,
//                       style: const TextStyle(fontSize: 14, color: Colors.green),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (isProcessing)
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: LinearProgressIndicator(),
//             ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: isProcessing ? null : startRecording,
//               child: const Text('Start Recording'),
//             ),
//             ElevatedButton(
//               onPressed: !isProcessing ? null : stopRecording,
//               child: const Text('Stop Recording'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
