
// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// const String backendBase = "http://127.0.0.1:8000";

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Visual Search Engine',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();

//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }
//   var favourites = <WordPair>[];
//   void toggleFavourite(){
//     if (favourites.contains(current)){
//       favourites.remove(current);
//     }else {
//       favourites.add(current);
//     }
//     notifyListeners();
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           pair.asLowerCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }




// class MyHomePage extends StatefulWidget{
//   const MyHomePage({super.key});
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   File? _imageFile;
//   bool _loading = false;
//   List<dynamic> _results = [];

//   Future<void> _pickImage(ImageSource source) async{
//     final picker = ImagePicker();
//     final xfile = await picker.pickImage(source: source, maxWidth:1024);
//     if (xfile != null){
//       setState(() {_imageFile = File(xfile.path); _results = [];});
//     }
//   }

//   Future<void> _search() async {
//     if (_imageFile == null) return ;
//     setState((){_loading = true;});

//     final req = http.MultipartRequest("POST", Uri.parse("$backendBase/search"));
//     req.files.add(await http.MultipartFile.fromPath("file", _imageFile!.path));
//     req.fields["topk"] = "8";

//     final streamed = await req.send();
//     final resp = await http.Response.fromStream(streamed);

//     setState((){_loading = false;});

//     if (resp.statusCode == 200){
//       final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
//       setState(() {_results = decoded["results"] as List<dynamic>;});
//     }else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Search failed: ${resp.statusCode}")));
//     }
//   }

//   var selectedIndex = 0;
//   @override
//   Widget build(BuildContext context){
//     final canSearch = _imageFile != null && !_loading;
//     Widget page;
//     switch (selectedIndex){
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = FavoritesPage();
//         break;
//     default:
//       throw UnimplementedError('no widget for $selectedIndex');
//     }
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Scaffold(
//           body: Row(
//             children: [
//               SafeArea(
//                 child: NavigationRail(
//                   extended: constraints.maxWidth >= 600,
//                   destinations: [
//                     NavigationRailDestination(
//                       icon: Icon(Icons.home),
//                       label: Text('Home'),
//                     ),
//                     NavigationRailDestination(
//                       icon: Icon(Icons.favorite),
//                       label: Text('Favourites'),
//                     )
//                   ], 
//                   selectedIndex: selectedIndex,
//                   onDestinationSelected: (value) {
//                     setState(() {
//                         selectedIndex = value;
//                       });
//                   } ,
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   child: page,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }


// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>(); 
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favourites.contains(pair)){
//       icon = Icons.favorite;
//     }else{
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: (){
//                   appState.toggleFavourite();
//                 },
//                 icon: Icon(icon),
//                 label: Text("Like"),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context){
//     var appState =  context.watch<MyAppState>();

//     if (appState.favourites.isEmpty){
//       return Center(child: Text('No favourites et.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have'
//                 '${appState.favourites.length} favourites:')
//         ),
//         for (var pair in appState.favourites)
//           ListTile(
//             leading: Icon(Icons.favorite),
//             title: Text(pair.asLowerCase),
//           ),
//       ],
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// When testing on iOS **simulator**, you can keep localhost.
/// When testing on a **physical iPhone**, use your Mac's LAN IP, e.g. "http://192.168.1.50:8000"
const String backendBase = "http://127.0.0.1:8000";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visual Search Engine',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepOrange),
      home: const SearchPage(),
    );
  }
}

Future<File?> _ensureJpeg(File f) async{
  final path = f.path.toLowerCase();
  if (path.endsWith('.heic') || path.endsWith('.heif')){
    final jpgPath = await HeicToJpg.convert(f.path);
    if (jpgPath == null) return null;
    return File(jpgPath);
  }
  return f;
}

Future<File?> _heicToJpegCompress(File f) async {
  final tmp = await getTemporaryDirectory();
  final outPath = p.join(tmp.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
  
  final bytes = await FlutterImageCompress.compressWithFile(
    f.path,
    quality:92,
    format: CompressFormat.jpeg
  );
  if (bytes == null) return null;

  final out = File(outPath);
  return out.writeAsBytes(bytes, flush:true);
}

/// ---------- Data model ----------

class ResultItem {
  final String id;
  final double score;
  final String? label;
  final String? url;   // optional thumbnail URL
  final Map<String, dynamic>? extra;

  ResultItem({
    required this.id,
    required this.score,
    this.label,
    this.url,
    this.extra,
  });

  factory ResultItem.fromJson(Map<String, dynamic> m) => ResultItem(
        id: (m['id'] ?? '').toString(),
        score: (m['score'] ?? 0).toDouble(),
        label: m['label']?.toString(),
        url: m['url']?.toString(),
        extra: (m['extra'] is Map<String, dynamic>) ? m['extra'] : null,
      );
}

/// ---------- API client ----------

class ApiClient {
  final String base;
  ApiClient(this.base);

  Future<List<ResultItem>> searchImage(File imageFile, {int topk = 8}) async {
    final uri = Uri.parse("$base/search");
    final req = http.MultipartRequest("POST", uri)
      ..files.add(await http.MultipartFile.fromPath("file", imageFile.path))
      ..fields["topk"] = topk.toString();

    // Add a timeout for reliability
    final streamed = await req.send().timeout(const Duration(seconds: 30));
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode != 200) {
      throw HttpException("Search failed: ${resp.statusCode} ${resp.body}");
    }
    final Map<String, dynamic> decoded = jsonDecode(resp.body);
    final List<dynamic> raw = (decoded["results"] ?? []) as List<dynamic>;
    return raw.map((e) => ResultItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}

/// ---------- UI ----------

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _api = ApiClient(backendBase);
  final _picker = ImagePicker();

  File? _imageFile;
  bool _loading = false;
  List<ResultItem> _results = [];
  String? _error;

  Future<void> _pick(ImageSource source) async {
    try {
      final x = await _picker.pickImage(
        source: source,
        maxWidth: 1024,     // keep payload reasonable
        imageQuality: 92,   // slight jpeg compression for faster upload
      );

      if (x != null){
        var file = File(x.path);
        if (file.path.toLowerCase().endsWith('.heic') || file.path.toLowerCase().endsWith('heif')){
          file = (await _heicToJpegCompress(file)) ?? file;
        }
        setState(() {_imageFile = file; _results = []; _error = null; });
      }

      if (x == null) return;
      setState(() {
        _imageFile = File(x.path);
        _results = [];
        _error = null;
      });
    } catch (e) {
      setState(() => _error = "Failed to pick image: $e");
    }
  }

  Future<void> _search() async {
    if (_imageFile == null || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _results = [];
    });
    try {
      final res = await _api.searchImage(_imageFile!, topk: 8);
      setState(() => _results = res);
    } catch (e) {
      setState(() => _error = e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSearch = _imageFile != null && !_loading;

    return Scaffold(
      appBar: AppBar(title: const Text("SimCLR + Faiss Search")),
      body: SafeArea(
        child: Column(
          children: [
            // Controls
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: canSearch ? _search : null,
                    icon: _loading
                        ? const SizedBox(
                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.search),
                    label: Text(_loading ? "Searching..." : "Search"),
                  ),
                ],
              ),
            ),

            // Picked image preview
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Error banner
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: MaterialBanner(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  content: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                  actions: [
                    TextButton(onPressed: () => setState(() => _error = null), child: const Text("Dismiss")),
                  ],
                ),
              ),

            // Results
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text("No results yet"))
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, i) => _ResultCard(item: _results[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ResultItem item;
  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item.label?.isNotEmpty == true ? item.label! : item.id;
    final score = item.score.toStringAsFixed(3);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: () {
          // TODO: open details / full screen image / product page using item.url or item.extra
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: item.url != null && item.url!.isNotEmpty
                  ? Image.network(item.url!, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                      return const Center(child: Icon(Icons.image_not_supported));
                    })
                  : const Center(child: Icon(Icons.image, size: 48)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text("score: $score", style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
