import 'package:galaxy_im/Clients/IChatMessage.dart';
import 'package:galaxy_im/Clients/Xmpp/Models/ChatMessage.dart';

typedef ChatMessageHandler = Future<void> Function(IChatMessage message);
