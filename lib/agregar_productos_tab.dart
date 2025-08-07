import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class AgregarProductosTab extends StatefulWidget {
  final String dia;
  const AgregarProductosTab({super.key, required this.dia});

  @override
  State<AgregarProductosTab> createState() => _AgregarProductosTabState();
}

class _AgregarProductosTabState extends State<AgregarProductosTab> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  File? _imagenSeleccionada;

Future<void> _seleccionarImagen() async {
  final permisoCamara = await Permission.camera.request();

  if (!permisoCamara.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Permiso de cámara denegado')),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Tomar foto'),
            onTap: () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                setState(() {
                  _imagenSeleccionada = File(pickedFile.path);
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Elegir de galería'),
            onTap: () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _imagenSeleccionada = File(pickedFile.path);
                });
              }
            },
          ),
        ],
      ),
    ),
  );
}

  Future<String?> _subirImagen(File imagen) async {
    try {
      final nombreArchivo = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('productosDias/$nombreArchivo.jpg');
      final uploadTask = await ref.putFile(imagen);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error subiendo imagen: $e');
      return null;
    }
  }


  Future<void> _guardarProducto() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final precio = double.tryParse(_precioController.text.trim()) ?? 0;

    if (nombre.isNotEmpty && precio > 0) {
      String? imagenUrl;

      if (_imagenSeleccionada != null) {
        imagenUrl = await _subirImagen(_imagenSeleccionada!);
      }

      await FirebaseFirestore.instance.collection('productosDias').add({
        'nombre': nombre,
        'precio': precio,
        'dia': widget.dia,
        'descripcion': descripcion,
        'imagenUrl': imagenUrl ?? '',
        'fechaRegistro': FieldValue.serverTimestamp(),
      });

      _nombreController.clear();
      _precioController.clear();
      _descripcionController.clear();
      setState(() {
        _imagenSeleccionada = null;
      });

      if (!mounted) return;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Producto guardado correctamente"),
      ); 
    }
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Digita los datos del nuevo producto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del producto',
                    prefixIcon: Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  maxLines: 2,
                ),
              const SizedBox(height: 16),
              Text('Imagen del producto', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _imagenSeleccionada != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              _imagenSeleccionada!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _imagenSeleccionada = null;
                                  });
                                },
                              ),
                            )
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Seleccionar imagen"),
                            ],
                          ),
                        ),
                ),
              ),

                const SizedBox(height: 24),
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
      ),
    );
  }
}
