import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guild_model.dart';

class GuildService {
  static final GuildService instance = GuildService._();
  GuildService._();

  final _guilds = FirebaseFirestore.instance.collection("guilds");

  Future<void> initializeGuilds() async {
    final defaults = ["GLACIER", "THUNDERSTORM", "EMBER"];

    for (final g in defaults) {
      final doc = await _guilds.doc(g).get();
      if (!doc.exists) {
        await _guilds.doc(g).set({
          "name": g,
          "weeklySteps": 0,
          "members": [],
        });
      }
    }
  }

  Future<void> joinGuild(String guild, String uid) async {
    await _guilds.doc(guild).update({
      "members": FieldValue.arrayUnion([uid]),
    });
  }

  Future<List<GuildModel>> getLeaderboard() async {
    final snap =
    await _guilds.orderBy("weeklySteps", descending: true).get();

    return snap.docs
        .map((e) => GuildModel.fromMap(e.data()))
        .toList();
  }

  Future<void> resetWeeklySteps() async {
    final snap = await _guilds.get();

    for (final guild in snap.docs) {
      await _guilds.doc(guild.id).update({
        "weeklySteps": 0,
      });
    }
  }
}
