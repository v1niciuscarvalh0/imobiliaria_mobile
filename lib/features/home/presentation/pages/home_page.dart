import 'package:flutter/material.dart';
import '../../../imoveis/presentation/pages/imoveis_page.dart';
import '../../../clientes/presentation/pages/clientes_page.dart';
import './widgets/menu_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Inicial'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              titulo: 'Imóveis',
              icone: Icons.house_outlined,
              cor: Colors.green.shade600,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaginaImoveis()),
                );
              },
            ),
            SizedBox(height: 20),
            MenuButton(
              titulo: 'Clientes',
              icone: Icons.person_outline,
              cor: Colors.blue.shade600,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaginaClientes()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
