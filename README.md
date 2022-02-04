# Matrix Homeserver Recommendations

Find, filter and benchmark public Matrix homeservers

## Features

- Dart native
- only three dependencies
- extensible
- predefined providers
- easily compare benchmarks

## Usage

```dart
Future<int> main() async {
  print('Loading homeservers from joinMatrix.org...');
  var joinMatrixParser = JoinmatrixOrgParser();
  final homeservers = await joinMatrixParser.fetchHomeservers();

  print('Found the following homeservers:');
  for (var server in homeservers) {
    print(server);
  }

  print('Performing response time benchmark...');
  final result = await HomeserverListProvider.benchmarkHomeserver(
    homeservers,
    timeout: Duration(seconds: 10),
    includeFailed: false,
  );
  print('The following response times were captured:');
  for (var benchmark in result) {
    print(benchmark);
  }
  print('Example completed.');
  return 0;
}
```

Alternatively, you can simply implement your own server list by extending `HomeserverListProvider`. Please don't forget
to [contribute](CONTRIBUTING.md) your own implementation.

## Additional information

Licensed under the terms and conditions of the [EUPL 1.2](LICENSE).