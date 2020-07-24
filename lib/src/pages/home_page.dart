import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;
// import 'package:qrreaderapp/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc=new ScansBloc();
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: scansBloc.borrarScansTodos,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=> _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex=index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
          BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Direcciones')
        )
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
        break;
      case 1:
        return DireccionesPage();
        break;
      default:
      return MapasPage();
    }
  }

  _scanQR(BuildContext context) async{
    //https:google.com
    //geo:40.724233047051705,-74.00731459101564

    String futureString;
    
    try {
      futureString = await BarcodeScanner.scan();

    } catch(e) {
      // futureString = e.toString();
      Navigator.pushNamed(context, 'home');
    }

    if ( futureString != null ) {
      final scan=ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      utils.abrirScan(context,scan);
    }else{
      Navigator.pushNamed(context, 'home');
      return;
    }
  }
}