import 'package:calendar/core/extensions/date_formatter.dart';
import 'package:calendar/core/models/event_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static const tableName = "events";
  static const eventFinalTime = "eventFinalTime";
  static const eventStartTime = "eventStartTime";
  static const eventInfo = "eventInfo";
  static const eventLocation = "eventLocation";
  static const eventName = "eventName";
  static const id = "id";
  static const createdAt = "createdAt";
  static const color = "color";

  static Database? _db;
  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, '$tableName.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
CREATE TABLE $tableName ( 
  $id INTEGER PRIMARY KEY AUTOINCREMENT, 
  $eventFinalTime TEXT,
  $eventStartTime TEXT,
  $eventInfo TEXT,
  $eventLocation TEXT,
  $eventName  TEXT NOT NULL,
  $createdAt  TEXT NOT NULL,
  $color  TEXT NOT NULL
  )
''');
    });
  }

  Future<List<EventModel>> getAllEvents() async {
    final db = await database;
    final data = await db.query(tableName);

    return data.map((e) => EventModel.fromJson(e)).toList();
  }

  Future<List<EventModel>> getEventsByDate(DateTime dateTime) async {
    final db = await database;

    final data = await db.query(
      tableName,
      where: "createdAt = ?",
      whereArgs: [dateTime.dateFormat()],
    );

    return data.map((e) => EventModel.fromJson(e)).toList();
  }

  Future<void> addNewEvent(EventModel eventModel) async {
    final db = await database;
    await db.insert(tableName, eventModel.toJson());
  }

  Future<void> delateEvent(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateEvent(EventModel eventModel) async {
    final db = await database;
    await db.update(
      tableName,
      eventModel.toJson(),
      where: "id = ?",
      whereArgs: [eventModel.id],
    );
  }
}
