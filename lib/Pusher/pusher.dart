import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';

class PusherService {
    /// Init Pusher Listener
  LaravelFlutterPusher initPusher(String appKey, String host, int port, String cluster) {
    return LaravelFlutterPusher(
        appKey,
        PusherOptions(
            host: host,
            port: port,
            encrypted: false,
            cluster: cluster
        ),
        enableLogging: true,
        onConnectionStateChange: (status){ print(status); }
    );
  }
  /// Subscribe to Channel & Event
  void listen(LaravelFlutterPusher pusher, String channel, String event){
    pusher.subscribe(channel).bind(event, (event) {
      print("SocketID: ");
      print(pusher.getSocketId());
      print(event);
    });
  }
}