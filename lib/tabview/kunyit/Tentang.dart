import 'package:flutter/material.dart';

class Tentang extends StatefulWidget {
  @override
  State createState() => new Tab1ViewState();
}

class Tab1ViewState extends State<Tentang> with AutomaticKeepAliveClientMixin<Tentang>{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(0.0),
      child: ListView(
        
        children: <Widget>[
  new Text('Kunyit merupakan jenis tanaman yang telah digunakan sejak lama di Indonesia. Ribuan tahun yang lalu masyarakat telah menggunakan kunyit sebagai bahan memasak. Kunyit memiliki fungsi sebagai pewarna alami, yaitu warna kuning. Sebagai salah satu bahan untuk membuat jamu,  kunyit memiliki khasiat antibakteri, antijamur, dan antivirus. Kunyit memiliki kandungan senyawa kimia curcumin yang memiliki khasiat untuk meredakan inflamasi, seperti bengkak dan nyeri. Pengolahan kunyit yang paling terkenal adalah jamu kunyit asam.', textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         Padding(
           padding: const EdgeInsets.only(top:20.0),
           child: new Text('Ramuan kunyit asam terdiri atas kunyit, asam, dan gula jawa. Masyarakat mengonsumsi kunyit asam dalam kehidupan sehari-hari meskipun tidak sedang sakit. Jamu ini dipercaya memiliki khasiat untuk menjaga kesehatan lambung. Jamu kunyit asam juga biasa dikonsumsi oleh perempuan saat masa menstruasi. Kandungan curcumin membantu meredakan nyeri.' , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         ),
        ],

      ),
      
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
