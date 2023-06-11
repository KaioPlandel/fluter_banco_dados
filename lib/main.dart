import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBanco() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");
    var bd = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      //
      String sql =
          "CREATE TABLE usuarios ( id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      db.execute(sql);
    });
    return bd;
  }

  _salvar() async {
    Database db = await _recuperarBanco();
    Map<String, dynamic> dadosUsuario = {"nome": "Kaio Plandel", "idade": 27};

    db.insert(
        "usuarios", dadosUsuario); // toda vez q salvar este cara volta o id
  }

  _listarUsuarios() async {
    Database db = await _recuperarBanco();
    var sql = "SELECT * FROM usuarios";
    List usuarios = await db.rawQuery(sql);

    //exemplo para ver os dados no print
    for (var usuario in usuarios) {
      print("usuario: ${usuario["id"]} +"
          "nome: ${usuario["nome"]} +"
          "idade: ${usuario["idade"]}");
    }
  }

  _recuperarUsuario(int id) async {
    Database db = await _recuperarBanco();
    List usuarios = await db.query("usuarios",
        columns: ["id", "nome", "idade"], where: "id = ?", whereArgs: [id]);
    print("usuario ${usuarios}");
  }

  _deletarUsuario(int id) async {
    Database db = await _recuperarBanco();
    db.delete("usuarios", where: "id = ?", whereArgs: [id]);
  }

  _atualizarUsuario(int id) async {
    Database db = await _recuperarBanco();
    Map<String, dynamic> dadosUsuario = {"nome": "Kaio Plandel", "idade": 27};
    db.update("usuarios", dadosUsuario, where: "id = ?", whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    _recuperarUsuario(2);
    return const Placeholder();
  }
}
