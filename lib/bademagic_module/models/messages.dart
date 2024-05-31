import 'package:badgemagic/bademagic_module/models/mode.dart';
import 'package:badgemagic/bademagic_module/models/speed.dart';

class Message {
  final String text;
  final bool flash;
  final bool marquee;
  final Speed speed;
  final Mode mode;

  Message({
    required this.text,
    this.flash = false,
    this.marquee = false,
    this.speed = Speed.ONE,
    this.mode = Mode.LEFT,
  });
}
