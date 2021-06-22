import './carWash.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  //1. 데이터 베이스 열고 참조값 얻기
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'carWash_database.db'),

    //2. 데이터 베이스 테이블 생성 (carWashs)
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE carWashes(date INTEGER PRIMARY KEY, amount REAL, memo TEXT)",
      );
    },
    //3. 버전 설정: onCreate 함수에서 수행, upgrade 와 downgrade를 수행하기 위한 경로 제공
    version: 1,
  );

  //db에 데이터 추가
  Future<void> insertMemo(CarWash carWash) async {
    // get the reference of the database
    final Database db = await database;

    // CarWash 를 올바른 테이블에 추가함
    // conflictAlgorithm : 중복 추가 방지 (여기서는 이전 데이터 갱신)
    await db.insert(
      'carWashes',
      carWash.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //db 데이터 리스트 조회
  Future<List<CarWash>> carwashes() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('carWashes');

    // List<Map<String, dynamic>> 을 List<Dog> 으로 변환
    return List.generate(maps.length, (idx) {
      return CarWash(
        date: maps[idx]['date'],
        amount: maps[idx]['amount'],
        memo: maps[idx]['memo'],
      );
    });
  }

  final wash1 = CarWash(date: 20210621, amount: 19000, memo: '외부 및 내부 손세차');

  await insertMemo(wash1);

  print(await carwashes());
}
