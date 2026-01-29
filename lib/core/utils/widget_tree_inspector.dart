import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:collection';

/// Widget 信息
class WidgetInfo {
  final String type;
  final String key;
  final int depth;
  final List<WidgetInfo> children;
  final Size? size;
  final Offset? position;
  final String? widgetRuntimeType;

  WidgetInfo({
    required this.type,
    required this.key,
    required this.depth,
    required this.children,
    this.size,
    this.position,
    this.widgetRuntimeType,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'key': key,
      'depth': depth,
      'children': children.map((c) => c.toJson()).toList(),
      'size': size?.toString(),
      'position': position?.toString(),
      'runtimeType': widgetRuntimeType,
    };
  }
}

/// Widget 树检查器
class WidgetTreeInspector {
  static WidgetTreeInspector? _instance;
  static WidgetTreeInspector get instance => _instance ??= WidgetTreeInspector._();

  WidgetTreeInspector._();

  final List<WidgetInfo> _widgetTree = [];
  final StreamController<WidgetInfo> _widgetUpdateController = StreamController<WidgetInfo>.broadcast();

  Stream<WidgetInfo> get widgetUpdates => _widgetUpdateController.stream;

  List<WidgetInfo> get widgetTree => UnmodifiableListView(_widgetTree);

  /// 扫描 Widget 树
  void scanWidgetTree(BuildContext context) {
    _widgetTree.clear();
    _scanContext(context, 0);
    _widgetUpdateController.add(_widgetTree.first);
  }

  void _scanContext(BuildContext context, int depth) {
    if (depth > 20) return; // 防止无限递归

    final widget = context.widget;
    final renderObject = context.findRenderObject();

    String keyStr = 'no-key';
    if (widget.key is ValueKey) {
      keyStr = (widget.key as ValueKey).value.toString();
    } else if (widget.key is GlobalKey) {
      keyStr = (widget.key as GlobalKey).toString();
    }

    // 获取尺寸和位置信息
    Size? widgetSize;
    Offset? widgetPosition;
    if (renderObject is RenderBox) {
      try {
        widgetSize = (renderObject as RenderBox).size;
        widgetPosition = (renderObject as RenderBox).localToGlobal(Offset.zero);
      } catch (e) {
        // RenderObject 可能还未挂载
      }
    }

    final info = WidgetInfo(
      type: widget.runtimeType.toString(),
      key: keyStr,
      depth: depth,
      children: [],
      widgetRuntimeType: widget.runtimeType.toString(),
      size: widgetSize,
      position: widgetPosition,
    );

    _widgetTree.add(info);

    // 访问子元素
    (context as Element).visitChildElements((element) {
      _scanContext(element, depth + 1);
    });
  }

  void dispose() {
    _widgetUpdateController.close();
  }
}

/// 火焰图分析器
class FlameGraphAnalyzer {
  static FlameGraphAnalyzer? _instance;
  static FlameGraphAnalyzer get instance => _instance ??= FlameGraphAnalyzer._();

  FlameGraphAnalyzer._() {
    _startFrameTracking();
  }

  final List<FrameData> _frames = [];
  final StreamController<List<FrameData>> _frameController = StreamController<List<FrameData>>.broadcast();

  Stream<List<FrameData>> get frameUpdates => _frameController.stream;
  List<FrameData> get frames => UnmodifiableListView(_frames);

  bool _isTracking = false;
  Timer? _trackingTimer;

  void _startFrameTracking() {
    SchedulerBinding.instance.addPersistentFrameCallback((_) {
      if (_isTracking) {
        _captureFrame();
      }
    });
  }

  void startTracking({Duration duration = const Duration(seconds: 5)}) {
    _isTracking = true;
    _frames.clear();
    _trackingTimer?.cancel();
    _trackingTimer = Timer(duration, () {
      _isTracking = false;
      _frameController.add(List.from(_frames));
    });
  }

  void _captureFrame() {
    final frameData = FrameData(
      timestamp: DateTime.now(),
      frameNumber: _frames.length,
    );

    // 捕获帧构建时间
    final buildStart = DateTime.now();
    SchedulerBinding.instance.scheduleFrame();
    final buildEnd = DateTime.now();

    frameData.buildDuration = buildEnd.difference(buildStart);

    _frames.add(frameData);

    // 限制帧数量
    if (_frames.length > 500) {
      _frames.removeRange(0, _frames.length - 500);
    }
  }

  List<FrameData> getSlowFrames({Duration threshold = const Duration(milliseconds: 16)}) {
    return _frames.where((frame) => frame.buildDuration > threshold).toList();
  }

  double getAverageFrameTime() {
    if (_frames.isEmpty) return 0;
    final total = _frames.fold<int>(0, (sum, frame) => sum + frame.buildDuration.inMicroseconds);
    return total / _frames.length / 1000; // 返回毫秒
  }

  void dispose() {
    _trackingTimer?.cancel();
    _frameController.close();
  }
}

/// 帧数据
class FrameData {
  final DateTime timestamp;
  final int frameNumber;
  Duration buildDuration = Duration.zero;
  Duration layoutDuration = Duration.zero;
  Duration paintDuration = Duration.zero;

  FrameData({
    required this.timestamp,
    required this.frameNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'frameNumber': frameNumber,
      'buildDuration': buildDuration.inMicroseconds,
      'layoutDuration': layoutDuration.inMicroseconds,
      'paintDuration': paintDuration.inMicroseconds,
    };
  }
}

/// 火焰图查看器
class FlameGraphViewer extends StatefulWidget {
  const FlameGraphViewer({super.key});

  @override
  State<FlameGraphViewer> createState() => _FlameGraphViewerState();
}

class _FlameGraphViewerState extends State<FlameGraphViewer> {
  final FlameGraphAnalyzer _analyzer = FlameGraphAnalyzer.instance;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _analyzer.frameUpdates.listen((frames) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = _analyzer.frames;
    final averageFrameTime = _analyzer.getAverageFrameTime();
    final slowFrames = _analyzer.getSlowFrames();

    return Scaffold(
      appBar: AppBar(
        title: const Text('火焰图分析'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              if (_isTracking) {
                setState(() => _isTracking = false);
              } else {
                _analyzer.startTracking();
                setState(() => _isTracking = true);
              }
            },
            tooltip: _isTracking ? '停止' : '开始录制',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 统计卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '性能统计',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _StatRow('总帧数', '${frames.length}'),
                  _StatRow('平均帧时间', '${averageFrameTime.toStringAsFixed(2)} ms'),
                  _StatRow('目标帧率', '60 FPS (16.67ms)'),
                  _StatRow('慢帧数', '${slowFrames.length}', color: Colors.red),
                  _StatRow('慢帧率', frames.isEmpty ? '0%' : '${(slowFrames.length / frames.length * 100).toStringAsFixed(1)}%', color: Colors.orange),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 火焰图
          if (frames.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '帧时间火焰图',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _FlameGraphPainter(frames),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          // 慢帧列表
          if (slowFrames.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '慢帧详情',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...slowFrames.take(20).map((frame) => ListTile(
                          title: Text('帧 #${frame.frameNumber}'),
                          subtitle: Text('${frame.buildDuration.inMicroseconds / 1000} ms'),
                          trailing: const Icon(Icons.warning, color: Colors.orange),
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatRow(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _FlameGraphPainter extends CustomPainter {
  final List<FrameData> frames;

  _FlameGraphPainter(this.frames);

  @override
  void paint(Canvas canvas, Size size) {
    if (frames.isEmpty) return;

    const targetMs = 16.67; // 60 FPS
    final barWidth = size.width / frames.length;
    final maxMs = frames.map((f) => f.buildDuration.inMicroseconds / 1000).reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < frames.length; i++) {
      final frame = frames[i];
      final frameMs = frame.buildDuration.inMicroseconds / 1000;
      final barHeight = (frameMs / maxMs) * size.height;

      final color = _getColorForFrame(frameMs, targetMs);
      final paint = Paint()..color = color;

      final rect = Rect.fromLTWH(
        i * barWidth,
        size.height - barHeight,
        barWidth - 1,
        barHeight,
      );

      canvas.drawRect(rect, paint);

      // 绘制目标线
      if (i == 0) {
        final targetY = size.height - (targetMs / maxMs) * size.height;
        final targetPaint = Paint()
          ..color = Colors.green
          ..strokeWidth = 2;
        canvas.drawLine(
          Offset(0, targetY),
          Offset(size.width, targetY),
          targetPaint,
        );
      }
    }
  }

  Color _getColorForFrame(double frameMs, double targetMs) {
    if (frameMs <= targetMs) return Colors.green;
    if (frameMs <= targetMs * 2) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget 树查看器
class WidgetTreeViewer extends StatefulWidget {
  const WidgetTreeViewer({super.key});

  @override
  State<WidgetTreeViewer> createState() => _WidgetTreeViewerState();
}

class _WidgetTreeViewerState extends State<WidgetTreeViewer> {
  final WidgetTreeInspector _inspector = WidgetTreeInspector.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _inspector.widgetUpdates.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget 树检查器'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _scanWidgetTree(),
            tooltip: '刷新',
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索 Widget 类型...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
              },
            ),
          ),
          // Widget 树
          Expanded(
            child: _inspector.widgetTree.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_tree, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('点击刷新按钮扫描 Widget 树'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _inspector.widgetTree.length,
                    itemBuilder: (context, index) {
                      final widget = _inspector.widgetTree[index];
                      if (_searchQuery.isNotEmpty && !widget.type.toLowerCase().contains(_searchQuery)) {
                        return const SizedBox.shrink();
                      }
                      return _WidgetTile(widget: widget);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _scanWidgetTree() {
    _inspector.scanWidgetTree(context);
  }
}

class _WidgetTile extends StatelessWidget {
  final WidgetInfo widget;

  const _WidgetTile({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.depth * 16.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ExpansionTile(
          leading: const Icon(Icons.insert_page_break),
          title: Text(
            widget.type,
            style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'monospace'),
          ),
          subtitle: Text('Key: ${widget.key}'),
          children: [
            if (widget.size != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow('Size', '${widget.size!.width.toStringAsFixed(1)} x ${widget.size!.height.toStringAsFixed(1)}'),
                    if (widget.position != null)
                      _InfoRow('Position', '(${widget.position!.dx.toStringAsFixed(1)}, ${widget.position!.dy.toStringAsFixed(1)})'),
                    _InfoRow('Depth', '${widget.depth}'),
                  ],
                ),
              ),
            ...widget.children.map((child) => _WidgetTile(widget: child)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
