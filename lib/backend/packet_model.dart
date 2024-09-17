part of 'models.dart';

/// [PacketModel] encapsulates fields of a Firebase Packet Document found in the 'packets' Collection
/// It also contains many helpful static methods for packet-related databse operations
///
/// Instantiate [PacketModel] using a [DocumentSnapshot] with [PacketModel.fromDocumentSnapshot] to easily
/// read fields from the document. When an update to the document is required, use [toMap] to
/// quickly transform the object into a [Map] and then write to the [DocumentReference]
class PacketModel {
  /// the unique id of the packet
  final String id;

  /// the name of the packet
  final String name;

  ///  **⚠️ UNDER CONSTRUCTION ⚠️**
  /// Not used at all...
  final String startDate;

  /// **⚠️ UNDER CONSTRUCTION ⚠️**
  /// Not used at all...
  final String endDate;

  /// **⚠️ UNDER CONSTRUCTION ⚠️**
  /// This needs to be changed to be used as a hex rather than a base 10...
  final int color;

  /// the url to be launched by the packet
  final String url;

  PacketModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.url,
  });

  /// Utility constructor to easily make a [PacketModel] from a [DocumentSnapshot]
  ///
  /// Queries the [DocumentSnapshot] for each field and instantiates [PacketModel] accordingly
  PacketModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc)
      : id = doc.id,
        name = doc.get('name') as String,
        startDate = doc.get('startDate') as String,
        endDate = doc.get('endDate') as String,
        color = doc.get('color') as int,
        url = doc.get('url') as String;

  /// Utility method to easily make a [Map] from [PacketModel]
  ///
  /// Invoke [toMap] when writing a [PacketModel] object to an event's Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'color': color,
      'url': url,
    };
  }

  /// Writes the provided [PacketModel] object to the database
  ///
  /// This will overwrite all fields!
  static Future<void> writePacket(PacketModel packet) async {
    AppInfo.database.collection('packets').doc(packet.id).set(packet.toMap());
  }

  /// Updates the specified packet with provided [updates]
  ///
  /// Firebase will merge target fields with incoming fields
  static Future<void> updatePacketById(
      String id, Map<String, dynamic> updates) async {
    AppInfo.database.collection('packets').doc(id).update(updates);
  }

  /// Deletes a packet from the database as specified by the [id]
  ///
  ///
  static void deletePacketById(String id) {
    AppInfo.database.collection('packets').doc(id).delete();
  }

  /// Gets the packet specified by the provided [id]
  ///
  ///
  static Future<PacketModel> getPacketById(String id) async {
    DocumentSnapshot packetQuery =
        await AppInfo.database.collection('packets').doc(id).get();
    return PacketModel.fromDocumentSnapshot(packetQuery);
  }

  /// Gets a [List] of the current packets as [PacketModel] objects
  ///
  ///
  static Future<List<PacketModel>> getPackets() async {
    QuerySnapshot packetQuery =
        await AppInfo.database.collection('packets').get();
    return packetQuery.docs
        .map((snapshot) => PacketModel.fromDocumentSnapshot(snapshot))
        .toList();
  }
}
