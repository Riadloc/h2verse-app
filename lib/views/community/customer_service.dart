import 'package:flutter/material.dart';

class CustomerService extends StatefulWidget {
  const CustomerService({super.key});

  static const routeName = '/customerService';

  @override
  State<CustomerService> createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('联系方式'),
      ),
      body: ListView(),
    );
  }
}
