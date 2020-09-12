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
  new Text('Lengkuas merupakan salah satu tanaman yang telah digunakan di dunia pengobatan sejak sekitar abad ke enam. Tanaman ini masuk ke Indonesia pertama kali di daerah Palembang, Sumatra Selatan. Menurut penjelasan Marco Pollo, orang-orang Jawa baru menanam dan memperjualbelikan lengkuas pada abad ke tiga belas. '
                , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         Padding(
           padding: const EdgeInsets.only(top:20.0),
           child: new Text('Lengkuas diolah dalam bentuk jamu yang disebut kudu laos. Jamu ini memiliki fungsi untuk masalah lambung, masuk angin, dan untuk meningkatkan nafsu makan. Ramuan kudu laos terdiri atas bawang putih, mengkudu, merica putih, buah asam, gula pasir, gula jawa, dan garam. Bawang putih memiliki fungsi sebagai antiseptik, antibakteri, dan antiinflamasi. Mengkudu direkomendasikan untuk masalah hati. Sementara itu, merica putih digunakan untuk menghangatkan tubuh, dan buah asam, yang mengandung vitamin B, baik digunakan untuk masuk angin dan diare.'  , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         ),
        ],
              
      ),
      
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
