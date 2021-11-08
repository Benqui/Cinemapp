import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' hide State, Size;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cinema mark06',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mark06 cinema paradiso'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<movies>> _getMovies() async {
    var db = await Db.create(
        'mongodb+srv://benqui:plicky01@cluster0.ya5qn.mongodb.net/cine?retryWrites=true&w=majority');
    await db.open();
    var coll = db.collection('cartelera');
    var peliculas = await coll.find().toList();
    //var jsonData = json.decode(peliculas);
    List<movies> pelis = [];
    for (var m in peliculas) {
      movies mov = movies(m['titulo'], m['poster'], m['sinopsis'], m['generos'],
          m['actores'], m['directores'], m['duracion']);
      pelis.add(mov);
    }
    return pelis;
    //print(pelis.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://drive.google.com/uc?export=view&id=18UynPDubPgYeBmMyQaDHv3GrVSZQEo37'),
                    fit: BoxFit.fill)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://drive.google.com/uc?export=view&id=1jZeWv4gsolyqhW6rS87bPXI5MnD-UPmB'),
                fit: BoxFit.fill)),
        child: FutureBuilder(
          future: _getMovies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: const Center(
                  child: Text(
                    'Cargando...',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image(
                      image: NetworkImage(snapshot.data[index].poster),
                    ),
                    title: Text(
                      snapshot.data[index].titulo,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final movies peli;

  DetailPage(this.peli);

  @override
  Widget build(BuildContext context) {
    final List<String> actors = peli.actores.map((e) => e as String).toList();
    final List<String> directors =
        peli.directores.map((e) => e as String).toList();
    final List<String> gens = peli.generos.map((e) => e as String).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(peli.titulo),
      ),
      body: ListView(
        //padding: const EdgeInsets.all(10),
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: Text(
              'Duracion: ' + peli.duracion.toString() + ' minutos',
              style: const TextStyle(fontSize: 25, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: 200,
                width: 100,
                child: Image.network(peli.poster),
              ),
              Flexible(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  peli.sinopsis,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              )),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Creditos y Reparto',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          Column(
            children: [
              const Text(
                'Actores:',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.start,
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: actors.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    actors[index],
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              const Text(
                'Directores:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: directors.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    directors[index],
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ],
          ),
          const Text(
            'Generos: ',
            style: TextStyle(fontSize: 25, color: Colors.white),
            textAlign: TextAlign.start,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: gens.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                gens[index],
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}

class movies {
  //final int id;
  final String titulo;
  final String poster;
  final String sinopsis;
  final List<dynamic> generos;
  final List<dynamic> actores;
  final List<dynamic> directores;
  final int duracion;

  movies(this.titulo, this.poster, this.sinopsis, this.generos, this.actores,
      this.directores, this.duracion);
}
