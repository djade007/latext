# latext

Render scientific LaTeX equations using the LaTexT library.

- **Mathematics / Maths Equations** (Algebra, Calculus, Geometry, Geometry etc...)
- **Physics Equations**
- **Signal Processing Equations**
- **Chemistry Equations**
- **Statistics / Stats Equations**
- **Inherit text style from parent widgets**

LaTeX rendering is done using **[flutter_math_fork](https://pub.dev/packages/flutter_math_fork)** and using RichText.

**latext** is working on Android, iOS, the Web and the Desktop platform.


## What's the difference to flutter_math_fork library?

flutter_math_fork is simply taking any input for Math rendering.
We split up into Text and Math parts. You can use a separator (eg. the common "$" or "$$").
Content between these separators is rendered as math while anything outside of these separators
is rendered as normal Flutter Text. This makes Text containing only some single formula parts much easier.

## Use this package as a library

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  latext: ^0.0.1
```
You can install packages from the command line with Flutter:

```shell
flutter pub get
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Now in your Dart code, you can use:

```
import 'package:latext/latext.dart';

...

// A static LaTeX block which may not change on `setState()`
return LaTexT(laTeXCode: Text("\\alpha", style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red)))

// A dynamic LaTeX block which is rebuilt on `setState()` (less efficient but required sometimes)
return Builder(builder: (context) => LaTexT(laTeXCode: Text("\\alpha", style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.red))))
```



This package was adapted from **[KaTexFlutter](https://gitlab.com/testapp-system/katex_flutter)**.
