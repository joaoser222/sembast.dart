library sembast_test.codec_test;

import 'package:sembast/timestamp.dart';
import 'package:sembast_test/base64_codec.dart';

import 'test_common.dart';

void main() {
  defineTests(memoryDatabaseContext);
}

void defineTests(DatabaseTestContext ctx) {
  var factory = ctx.factory;
  group('codec', () {
    Database db;

    setUp(() async {
      db = await setupForTest(ctx, 'codec.db');
    });

    tearDown(() {
      return db.close();
    });

    test('export', () async {
      var codec =
          SembastCodec(signature: 'base64', codec: SembaseBase64Codec());
      var store = StoreRef<String, dynamic>.main();
      var record = store.record('key');
      var recordTimestamp = store.record('timestamp');
      await factory.deleteDatabase('test');
      var db = await factory.openDatabase('test', codec: codec);
      expect(await record.get(db), isNull);
      await record.put(db, 'value');
      await recordTimestamp.put(db, Timestamp(1, 2));
      expect(await record.get(db), 'value');
      await db.close();

      db = await factory.openDatabase('test', codec: codec);
      expect(await record.get(db), 'value');
      await recordTimestamp.put(db, Timestamp(1, 2));
      await record.put(db, 'value2');
      expect(await record.get(db), 'value2');
      await db.close();
    });
  });
}