
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaProductosTab extends StatelessWidget {
  final String dia;
  const ListaProductosTab({super.key, required this.dia});

  void _editarProducto(BuildContext context, DocumentSnapshot doc, Map<String, dynamic> data) async {

    final TextEditingController nombreController = TextEditingController(text: data['nombre']);
    final TextEditingController descripcionController = TextEditingController(text: data['descripcion']);
    final TextEditingController precioController = TextEditingController(text: data['precio'].toString());

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Editar Producto'),
        content: Column(
          children: [
            TextField(controller: nombreController, decoration: InputDecoration(labelText: 'Nombre'),),
            TextField(controller: descripcionController, decoration: InputDecoration(labelText: 'descripcion'),),
            TextField(controller: precioController, decoration: InputDecoration(labelText: 'precio'),),
          ],
        ),
        actions: [
          TextButton(onPressed: null, child: Text('Cancelar')),
          TextButton(onPressed: () async {
            await FirebaseFirestore.instance.collection('productosDias').doc(doc.id)
            .update({
              'nombre': nombreController.text,
              'precio': precioController.text,
              'descripcion': descripcionController.text
           });

           Navigator.pop(context);

          },child: Text('Editar')),
        ],
      )
    );
  }

  void _eliminarProducto(BuildContext context, String docId) async {
    final confirm = await showDialog<bool>(
          context: context, 
          builder: (context) => AlertDialog(
          title: Text('Estas seguro de eliminar el producto!'),
          content: Text('La accion no se puede deshacer!'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
          ],
        )
      );

      if (confirm == true) {
        await FirebaseFirestore.instance.collection('productosDias').doc(docId).delete();
      }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('productosDias')
          .where('dia', isEqualTo: dia)
          .orderBy('fechaRegistro', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) return Center(child: Text('No hay productos registrados'));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = docs[index].data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(data['nombre'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Precio: L ${data['precio'] ?? 0}'),
                    Text(data['descripcion'] ?? ''),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () => _editarProducto(context, doc, data), icon: Icon(Icons.edit, color: Colors.blue,)),
                    IconButton(onPressed: () => _eliminarProducto(context, doc.id), icon: Icon(Icons.delete, color: Colors.red,)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

