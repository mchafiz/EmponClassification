import 'package:flutter/material.dart';

class Kandungan extends StatefulWidget {
  @override
  State createState() => new Tab2ViewState();
}

class Tab2ViewState extends State<Kandungan> with AutomaticKeepAliveClientMixin<Kandungan> {
  @override
  Widget build(BuildContext context) {
   return Container(
      padding: new EdgeInsets.all(0.0),
      child: ListView(
        
        children: <Widget>[
  new Text('Nama : Kencur Kaempferia galanga L.'
                , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold ),),
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: new Text('Famili: Zingiberaceae.'
                  , textAlign: TextAlign.justify,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                ),
               

         Padding(
           padding: const EdgeInsets.only(top:25.0),
           child: Table( border: TableBorder.all(width: 1.0,color:Colors.black),
           children: [
             TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Kandungan Kencur', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                         
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Pati', style: TextStyle(fontSize:20),),
                       
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Mineral'),
                        
                        ],
                      ),
                    )
                  ]),
               
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Sineol'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Asam metal kanil'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Pentadekaan'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Asam Cinnamic'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Ethyl Aster'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Asam Sinamic'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Borneol'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Kamphene'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Paraeumarin'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Asam Anisic'),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Text('Alkaloid'),
                        ],
                      ),
                    )
                  ]),
                  
           ],)
         ),
        ],
              
      ),
      
    );
  }

  _buildItemView(BuildContext context, var text) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = width / 3;

    return new Container(
      child: new Card(
          elevation: 3.0,
          margin: EdgeInsets.all(10.0),
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Container(
                  width: width,
                  height: height,
                  child: Image.network(
                    "https://i.pinimg.com/564x/b1/82/97/b182971dfd1fbea8f4142735b0435024.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                new Padding(padding: new EdgeInsets.only(top: 10.0)),
                new Text('Current Time $text'),
                new Padding(padding: new EdgeInsets.only(top: 10.0)),
              ],
            ),
          )
      ),
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
