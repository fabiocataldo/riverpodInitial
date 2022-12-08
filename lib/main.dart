import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  // Counter(super.state);
  Counter() : super(null);
  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class GetDate extends StateNotifier<DateTime> {
  GetDate(super.state);

  void dateTime() => state = DateTime.now();

  DateTime? get value => state;
}

final currentDate = StateNotifierProvider<GetDate, DateTime>(
  (ref) => GetDate(DateTime.now()),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Consumer(builder: ((context, ref, child) {
        final count = ref.watch(counterProvider);
        final text = count ?? 'Press the Button';
        return Text(text.toString());
      }))),
      body: Center(
        child: Column(children: [
          TextButton(
            onPressed: () {
              ref.read(counterProvider.notifier).increment();
              ref.read(currentDate.notifier).dateTime();
            },
            child: const Text('Increment Counter'),
          ),
          Consumer(builder: ((context, ref, child) {
            final date = ref.watch(currentDate);
            return Text(date.toIso8601String());
          }))
        ]),
      ),
    );
  }
}
