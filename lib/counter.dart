class Counter {
  // 同じクラス内からしかアクセスできないようにする
  int _counter = 0;
  // 外部からは参照のみできるようにする
  int get count => _counter;
  // カウントアップするメソッド
  void increment() {
    _counter++;
  }
  // カウントダウンするメソッド
  void decrement() {
    _counter--;
  }
  // カウントをリセットするメソッド
  void reset() {
    _counter = 0;
  }
}
