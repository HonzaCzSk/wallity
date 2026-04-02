import 'package:flutter/material.dart';
import '../models/bank.dart';
import 'bank_logo.dart';

class BankCard extends StatelessWidget {
  final Bank bank;
  final VoidCallback onTap;

  const BankCard({super.key, required this.bank, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFe3f2fd), Color(0xFFbbdefb)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              BankLogo(
                name: bank.name,
                assetPath: bank.logoAsset,
                websiteUrl: bank.websiteUrl,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  bank.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const Icon(Icons.arrow_forward_ios, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
