import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
// import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final mapCtrl=new MapController();

  String tipoMapa='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title:Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.my_location),
            onPressed: (){
              mapCtrl.move(scan.getLatLng(), 17);
            },
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 17,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
        
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
    
        urlTemplate: tipoMapa,
        subdomains: ['a', 'b', 'c']
    );
  }
  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point:scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(Icons.location_on,size: 70.0,color: Theme.of(context).primaryColor
            ),
          ),
        )
      ]
    );
  }

 Widget _crearBotonFlotante(BuildContext context) {
   return FloatingActionButton(
     onPressed: (){
       if(tipoMapa=='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'){
         tipoMapa='https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
       }else if(tipoMapa=='https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'){
         tipoMapa='https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
       }
       setState(() {
         
       });
     },
     child: Icon(Icons.track_changes),
     backgroundColor: Theme.of(context).primaryColor,
   );
 }
}