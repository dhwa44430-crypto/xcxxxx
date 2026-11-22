import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game_models.dart';

class PlatformerGame extends FlameGame {
  PlatformerGame({required this.onStateChanged}) : super(camera: CameraComponent());
  final ValueChanged<RunState> onStateChanged;
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> lives = ValueNotifier(3);
  final ValueNotifier<int> level = ValueNotifier(0);
  final ValueNotifier<double> timeLeft = ValueNotifier(120);
  final ValueNotifier<int> coins = ValueNotifier(0);
  final _player = Player();
  SceneArt? _scene;
  final _blocks = <Rect>[];
  final _coinItems = <CollectibleCoin>[];
  final _enemyItems = <Enemy>[];
  final _questionItems = <QuestionBox>[];
  double _worldX = 80;
  double _velocityX = 0;
  double _velocityY = 0;
  bool left = false, right = false, jumpHeld = false;
  bool _jumpLatch = false;
  bool _loaded = false;
  LevelData get currentLevel => levels[level.value];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = 1;
    add(_player);
    _loadLevel();
    _loaded = true;
  }

  void start() { if (!_loaded) return; level.value = 0; score.value = 0; lives.value = 3; onStateChanged(RunState.playing); _loadLevel(); }
  void restart() { level.value = 0; score.value = 0; lives.value = 3; onStateChanged(RunState.playing); _loadLevel(); }
  void setLeft(bool value) => left = value;
  void setRight(bool value) => right = value;
  void setJump(bool value) { jumpHeld = value; if (value && !_jumpLatch) { _velocityY = -560; _jumpLatch = true; } if (!value) _jumpLatch = false; }
  void attack() { score.value += 5; }

  void _loadLevel() {
    _scene?.removeFromParent();
    _blocks.clear(); _coinItems.forEach((c) => c.removeFromParent()); _enemyItems.forEach((e) => e.removeFromParent()); _questionItems.forEach((q) => q.removeFromParent()); _coinItems.clear(); _enemyItems.clear(); _questionItems.clear();
    _blocks.addAll(currentLevel.platforms); _worldX = 80; _velocityX = 0; _velocityY = 0; timeLeft.value = 120 - level.value * 15; _player.position = Vector2(_worldX, 540);
    _scene = SceneArt(currentLevel); add(_scene!);
    for (final c in currentLevel.coins) { final item = CollectibleCoin(c); _coinItems.add(item); add(item); }
    for (final e in currentLevel.enemies) { final item = Enemy(e); _enemyItems.add(item); add(item); }
    for (final platform in currentLevel.platforms.skip(1).take(2)) { final item = QuestionBox(Rect.fromLTWH(platform.left + platform.width / 2 - 18, platform.top - 90, 36, 36)); _questionItems.add(item); add(item); }
  }

  @override
  void update(double dt) {
    super.update(dt); if (!_loaded) return;
    timeLeft.value = math.max(0, timeLeft.value - dt).toDouble(); if (timeLeft.value <= 0) { _loseLife(); return; }
    _velocityX = (right ? 230 : 0) - (left ? 230 : 0); _worldX += _velocityX * dt; _velocityY += 1300 * dt;
    final previousBottom = _player.position.y + 58; var landed = false;
    for (final block in _blocks) { if (_worldX + 36 > block.left && _worldX < block.right && previousBottom <= block.top && _player.position.y + 58 + _velocityY * dt >= block.top) { _player.position.y = block.top - 58; _velocityY = 0; landed = true; break; } }
    if (!landed) _player.position.y += _velocityY * dt;
    _player.position.x = _worldX; camera.viewfinder.position = Vector2(_worldX + 200, 360);
    for (final box in _questionItems) { if (!box.used && _velocityY < 0 && box.rect.overlaps(Rect.fromLTWH(_worldX, _player.position.y - 6, 42, 12))) { box.used = true; score.value += 150; coins.value++; _velocityY = 80; } }
    for (final coin in _coinItems) { if (!coin.collected && coin.rect.overlaps(Rect.fromLTWH(_worldX, _player.position.y, 42, 58))) { coin.collected = true; coin.removeFromParent(); coins.value++; score.value += 100; } }
    for (final enemy in _enemyItems) { enemy.animate(dt); if (!enemy.defeated && enemy.rect.overlaps(Rect.fromLTWH(_worldX, _player.position.y, 42, 58))) { if (_velocityY > 0 && _player.position.y + 58 < enemy.rect.center.dy + 15) { enemy.defeated = true; enemy.removeFromParent(); _velocityY = -360; score.value += 250; } else { _loseLife(); return; } } }
    if (_worldX > currentLevel.goalX) { if (level.value == levels.length - 1) onStateChanged(RunState.victory); else { level.value++; onStateChanged(RunState.levelComplete); } }
    if (_player.position.y > 800) _loseLife();
  }
  void continueNext() { onStateChanged(RunState.playing); _loadLevel(); }
  void _loseLife() { lives.value--; if (lives.value <= 0) { onStateChanged(RunState.gameOver); } else { _worldX = 80; _player.position = Vector2(80, 540); _velocityY = 0; } }
}

class Player extends PositionComponent { Player() : super(size: Vector2(54, 70)); @override void render(Canvas canvas) { canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(18)), Paint()..color = const Color(0xfffff8f3)); canvas.drawCircle(const Offset(29, 23), 21, Paint()..color = const Color(0xffffaa62)); canvas.drawArc(const Rect.fromLTWH(3, -5, 48, 35), math.pi, math.pi, false, Paint()..color = const Color(0xffe5394f)..strokeWidth = 8..style = PaintingStyle.stroke); canvas.drawCircle(const Offset(21, 22), 3, Paint()..color = Colors.black); canvas.drawCircle(const Offset(37, 22), 3, Paint()..color = Colors.black); } }
class CollectibleCoin extends PositionComponent { CollectibleCoin(Offset p) : rect = Rect.fromLTWH(p.dx, p.dy, 28, 34), super(position: Vector2(p.dx, p.dy), size: Vector2(28, 34)); final Rect rect; bool collected = false; @override void render(Canvas canvas) { canvas.drawOval(size.toRect(), Paint()..color = const Color(0xffffd447)); canvas.drawOval(size.toRect().deflate(6), Paint()..color = const Color(0xffffa51f)); } }
class Enemy extends PositionComponent { Enemy(Rect r) : base = r, super(position: Vector2(r.left, r.top), size: Vector2(r.width, r.height)); final Rect base; bool defeated = false; double _phase = 0; Rect get rect => Rect.fromLTWH(position.x, position.y, size.x, size.y); void animate(double dt) { _phase += dt; position.x = base.left + math.sin(_phase * 2) * 45; } @override void render(Canvas canvas) { canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(12)), Paint()..color = const Color(0xff633b59)); canvas.drawCircle(const Offset(13, 16), 4, Paint()..color = Colors.white); canvas.drawCircle(const Offset(31, 16), 4, Paint()..color = Colors.white); } }
class QuestionBox extends PositionComponent { QuestionBox(this.rect) : super(position: Vector2(rect.left, rect.top), size: Vector2(rect.width, rect.height)); final Rect rect; bool used = false; @override void render(Canvas canvas) { final paint = Paint()..color = used ? const Color(0xffa66b3f) : const Color(0xffffb52e); canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(5)), paint); final tp = TextPainter(text: TextSpan(text: used ? '·' : '?', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)), textDirection: TextDirection.ltr)..layout(); tp.paint(canvas, Offset((size.x - tp.width) / 2, (size.y - tp.height) / 2)); } }
class SceneArt extends Component { SceneArt(this.level) : super(priority: -100); final LevelData level; @override void render(Canvas canvas) { final bg = Paint()..color = const Color(0xff8bd7e8); canvas.drawRect(Rect.fromLTWH(0, 0, level.width, 760), bg); canvas.drawCircle(const Offset(2300, 100), 70, Paint()..color = const Color(0xffffd76a)); for (final block in level.platforms) { canvas.drawRect(block, Paint()..color = const Color(0xff8b542e)); canvas.drawRect(Rect.fromLTWH(block.left, block.top, block.width, 12), Paint()..color = const Color(0xff4caf50)); } final flagX = level.goalX; canvas.drawRect(Rect.fromLTWH(flagX, 360, 8, 260), Paint()..color = const Color(0xfff4f1de)); final path = Path()..moveTo(flagX + 8, 365)..lineTo(flagX + 100, 395)..lineTo(flagX + 8, 430)..close(); canvas.drawPath(path, Paint()..color = const Color(0xffe5394f)); } }
