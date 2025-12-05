import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const MenuButton({
    required this.titulo,
    required this.icone,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, color: Colors.white, size: 40),
              SizedBox(width: 12),
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
