import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AgregarProductosTab extends StatefulWidget {
  const AgregarProductosTab({super.key});

  @override
  State<AgregarProductosTab> createState() => _AgregarProductosTabState();
}

class _AgregarProductosTabState extends State<AgregarProductosTab> {
 final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  Future<void> _guardarProducto() async {

    final nombre = _nombreController.text;
    final precio = _precioController.text;
    final descripcion = _descripcionController.text;
    final fechaRegistro = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance.collection('productos')
    .add({
      "descripcion": descripcion,
      "fechaRegistro": fechaRegistro,
      "nombre": nombre,
      "precio": precio
    });

    if (!mounted) {
      return;
    }

    showTopSnackBar(Overlay.of(context),
    CustomSnackBar.success(
      message: "Producto guardado correctamente!")
    );

    _nombreController.clear();
    _descripcionController.clear();
    _precioController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.all(16.0),
  child: Card(
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          Text(
            'Digita los datos del nuevo producto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre del producto',
              prefixIcon: Icon(Icons.shopping_bag),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          TextField(
            controller: _precioController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Precio',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          TextField(
            controller: _descripcionController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Guardar producto'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _guardarProducto,
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}