## June

June is a product analytics tool that allows you to capture data on how users use your product.

This package is Dart wrapper around the June HTTP API - which allows you to easily track data on June in your Dart projects and Flutter apps. Check out the official [June documention](https://www.june.so/docs) for more information on using June. 

## Getting started

### Steps

#### Depend on it
Add the `june_flutter` dependency to your `pubspec.yaml` and run `flutter pub get`.
```yaml
dependencies:
    june_flutter: ^0.x.x # set this to the latest version
```

#### Import it
Now in your Dart code, you can use:
```dart
import 'package:june_flutter/june_flutter.dart';
```

## Usage

## 1. Initialize June
To start tracking with the SDK you must first initialize with your June write key. First add `import 'package:june_flutter/june_flutter.dart';` and call `June.instance.init(writeKey: writeKey);`. You can find your write key on the [June dashboard](https://analytics.june.so/).

```dart
import 'package:june_flutter/june_flutter.dart';
...
class _YourClassState extends State<YourClass> {

  @override
  void initState() {
    super.initState();
    June.instance.init(writeKey: "June Write Key");
  }
...
```

## 3. Send Data
Once you've initialized the SDK, you can simply call the June instance to track events and identify users/companies.

### Identify
```dart
// Identify user with optional traits
June.instance.identifyUser(userId: 'User ID', properties: {'type': 'admin'});

// Identify company
June.instance.identifyGroup(groupId: 'Company ID', userId: 'User ID', properties: {'plan': 'enterprise'});
```

### Track
```dart
// Track event and optional properties
June.instance.track('Recipe Tapped', properties: {'location': 'home_feed'});
```