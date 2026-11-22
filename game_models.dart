import 'package:flutter/material.dart';

enum RunState { menu, playing, levelComplete, gameOver, victory }

class LevelData {
  const LevelData({required this.name, required this.width, required this.platforms, required this.coins, required this.enemies, required this.goalX});
  final String name;
  final double width;
  final List<Rect> platforms;
  final List<Offset> coins;
  final List<Rect> enemies;
  final double goalX;
}

const levels = <LevelData>[
  LevelData(
    name: 'واحة البداية', width: 2600, goalX: 2420,
    platforms: [Rect.fromLTWH(0, 620, 2600, 120), Rect.fromLTWH(300, 500, 190, 24), Rect.fromLTWH(620, 430, 180, 24), Rect.fromLTWH(960, 530, 210, 24), Rect.fromLTWH(1320, 450, 190, 24), Rect.fromLTWH(1700, 520, 220, 24), Rect.fromLTWH(2050, 410, 230, 24)],
    coins: [Offset(360, 450), Offset(675, 380), Offset(1020, 480), Offset(1380, 400), Offset(1780, 470), Offset(2130, 360), Offset(2300, 560)],
    enemies: [Rect.fromLTWH(520, 580, 44, 40), Rect.fromLTWH(1160, 580, 44, 40), Rect.fromLTWH(1900, 580, 44, 40)],
  ),
  LevelData(
    name: 'ممر النخيل', width: 3200, goalX: 3000,
    platforms: [Rect.fromLTWH(0, 620, 3200, 120), Rect.fromLTWH(240, 470, 160, 24), Rect.fromLTWH(540, 360, 170, 24), Rect.fromLTWH(850, 490, 150, 24), Rect.fromLTWH(1170, 390, 190, 24), Rect.fromLTWH(1500, 500, 160, 24), Rect.fromLTWH(1840, 350, 180, 24), Rect.fromLTWH(2200, 460, 170, 24), Rect.fromLTWH(2550, 350, 220, 24)],
    coins: [Offset(290, 420), Offset(600, 310), Offset(900, 440), Offset(1240, 340), Offset(1560, 450), Offset(1900, 300), Offset(2260, 410), Offset(2630, 300), Offset(2860, 560)],
    enemies: [Rect.fromLTWH(430, 580, 44, 40), Rect.fromLTWH(1010, 580, 44, 40), Rect.fromLTWH(1660, 580, 44, 40), Rect.fromLTWH(2370, 580, 44, 40), Rect.fromLTWH(2780, 580, 44, 40)],
  ),
  LevelData(
    name: 'قلعة الرمال', width: 3800, goalX: 3600,
    platforms: [Rect.fromLTWH(0, 620, 3800, 120), Rect.fromLTWH(260, 420, 150, 24), Rect.fromLTWH(520, 290, 160, 24), Rect.fromLTWH(800, 450, 130, 24), Rect.fromLTWH(1080, 330, 180, 24), Rect.fromLTWH(1400, 470, 150, 24), Rect.fromLTWH(1690, 300, 180, 24), Rect.fromLTWH(2010, 430, 160, 24), Rect.fromLTWH(2320, 280, 180, 24), Rect.fromLTWH(2660, 430, 170, 24), Rect.fromLTWH(3000, 320, 190, 24), Rect.fromLTWH(3330, 450, 210, 24)],
    coins: [Offset(310, 360), Offset(570, 230), Offset(840, 390), Offset(1140, 270), Offset(1450, 410), Offset(1750, 240), Offset(2070, 370), Offset(2390, 220), Offset(2720, 370), Offset(3060, 260), Offset(3400, 390)],
    enemies: [Rect.fromLTWH(440, 580, 44, 40), Rect.fromLTWH(950, 580, 44, 40), Rect.fromLTWH(1570, 580, 44, 40), Rect.fromLTWH(2180, 580, 44, 40), Rect.fromLTWH(2830, 580, 44, 40), Rect.fromLTWH(3230, 580, 44, 40)],
  ),
];
