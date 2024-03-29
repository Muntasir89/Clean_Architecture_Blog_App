import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnectionChecker internetConnectionChecker;

  ConnectionCheckerImpl(this.internetConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async =>
      await internetConnectionChecker.hasConnection;
}
