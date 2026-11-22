# مغامرة الصحراء — Flutter + Flame

لعبة منصات 2D عربية للهاتف، بثلاث مراحل، شخصية مخصصة، عملات، أعداء، نقاط، حياة، مؤقت، نهاية مرحلة، فوز وGame Over. تعمل الواجهة في Portrait أو Landscape لأن أزرار التحكم موضوعة فوق مساحة اللعب باستخدام `SafeArea`.

## التشغيل محلياً

1. ثبّت Flutter stable وAndroid Studio/SDK.
2. من جذر المشروع شغّل `flutter create . --platforms=android` مرة واحدة لتوليد ملفات Android، ثم `flutter pub get` و`flutter run`.
3. جرّب أزرار اليسار/اليمين والقفز والهجوم، واجمع العملات واضرب صناديق السؤال من الأسفل واقفز فوق الأعداء.

## البناء عبر GitHub

أنشئ مستودعاً جديداً، ثم من جذر المشروع:

```bash
git init
git add .
git commit -m "إنشاء لعبة مغامرة الصحراء"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

بعد كل `push` سيعمل `.github/workflows/build_apk.yml` تلقائياً. من GitHub افتح **Actions**، اختر آخر تشغيل، ثم من **Artifacts** حمّل `arabic-runner-debug-apk` للتجربة أو `arabic-runner-release-apk` للتوزيع. قد تحتاج إلى تفعيل تثبيت التطبيقات من مصادر غير معروفة على الهاتف.

## التنظيم

- `lib/game`: الفيزياء، المراحل، اللاعب، العملات والأعداء.
- `lib/screens`: شاشة اللعب والحالات الرئيسية.
- `lib/widgets`: أزرار اللمس.
- `assets/images`: صورة الشخصية المرفقة.
- `assets/audio`: مكان المؤثرات الاختيارية، والمشروع لا يفشل إن بقي المجلد بلا ملفات صوت.
- `.github/workflows`: بناء debug وrelease ورفع APK كـ artifacts.
