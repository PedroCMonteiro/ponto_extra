import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:masked_text/masked_text.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Usuarios'),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => PaginaUsuarios(title: 'Usuarios'),
        '/Cadastro': (BuildContext context) =>
            PaginaCadastro(title: 'Cadastro'),
      },
    );
  }
}

class Usuario {
  String _nome;
  String _dataNascimento;

  Usuario(this._nome, this._dataNascimento);

  String getNome() {
    return _nome;
  }

  String getDataNascimento() {
    return _dataNascimento;
  }
}

class PaginaUsuarios extends StatefulWidget {
  PaginaUsuarios({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaginaUsuariosState createState() => _PaginaUsuariosState();
}

class PaginaCadastro extends StatefulWidget {
  PaginaCadastro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PaginaCadastroState createState() => _PaginaCadastroState();
}

class _PaginaUsuariosState extends State<PaginaUsuarios> {
  List<Usuario> usuarios = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  child: ListTile(
                    title: Center(
                      child: Text(
                          '${usuarios[index].getNome()} ${usuarios[index].getDataNascimento()}'),
                    ),
                  ),
                  key: Key(index.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      usuarios.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cadastroNovoUsuario(context);
        },
        child: new LayoutBuilder(builder: (context, constraint) {
          return new Icon(Icons.add_rounded,
              size: constraint.biggest.height * 0.75);
        }),
      ),
    );
  }

  void _cadastroNovoUsuario(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/Cadastro');
    if (result != null) {
      setState(() {
        usuarios.add(result);
      });
    }
  }
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  TextEditingController _nome = TextEditingController();
  TextEditingController _data = TextEditingController();

  bool isValidDate(String data) {
    print(data);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: _nome,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                maxLength: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: MaskedTextField(
                maskedTextFieldController: _data,
                mask: 'xx/xx/xxxx',
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Data de Nascimento',
                  counterText: '',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_nome.text != '' && isValidDate(_data.text))
                            Navigator.pop(
                                context, Usuario(_nome.text, _data.text));
                        },
                        child: Text(
                          'Salvar',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors
                                  .grey; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        child: Text(
                          'Voltar',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
