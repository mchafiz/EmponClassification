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
  new Text('Jahe merupakan anggota keluarga Zingerberaceae  yang paling terkenal. Sejak lama jahe telah digunakan untuk menghangatkan tubuh. Masyarakat Indonesia juga menggunakan jahe untuk meningkatkan nafsu makan, mencegah mual, dan membantu meringankan reumatisme. Jahe yang ditumbuk juga dapat digunakan untuk meringankan rasa gatal dan mengobati luka.'
                , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         Padding(
           padding: const EdgeInsets.only(top:20.0),
           child: new Text('Jahe untuk menghangatkan tubuh, di antaranya dibuat minuman. Salah satunya adalah wedang jahe. Wedang dalam bahasa Jawa berarti ‘minuman’. Mengonsumsi wedang jahe selain untuk menghangatkan tubuh, juga dapat bermanfaat untuk meredakan masuk angin. Saat ini wedang jahe atau dalam bahasa Inggris disebut ginger tea menjadi popular untuk mencegah rasa mual. Jahe masuk dalam buku pengobatan herbal  di negara Barat sebagai ramuan untuk mencegah morning sickness atau rasa mual yang dialami oleh wanita pada triwulan awal kehamilan. '      , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         ),
        ],
              
      ),
      
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
