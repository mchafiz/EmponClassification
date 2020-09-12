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
  new Text('Kencur merupakan tanaman yang juga memiliki fungsi untuk menghangatkan tubuh. Selain itu, kencur bermanfaat untuk meredakan demam, encok, sakit perut, dan bengkak. Ramuan yang terdiri atas kencur, serai, dan garam dapat digunakan untuk mengobati bengkak. Kencur juga digunakan masyarakat Indonesia untuk meredakan batuk. '
                , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         Padding(
           padding: const EdgeInsets.only(top:20.0),
           child: new Text('Selain untuk meredakan batuk, jamu beras kencur juga memiliki fungsi untuk menambah nafsu makan sehingga jamu ini juga sering dikonsumsi oleh anak-anak. Saat ini para ilmuan juga sedang meneliti kencur  sebagai insektisida untuk membasmi nyamuk Aedes aegypti yang menularkan penyakit demam berdarah dengue (DBD). '
                  , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0),),
         ),
        ],
              
      ),
      
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
