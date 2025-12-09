import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/supplier.dart';
import '../../services/suppliers_service.dart';
import '../../providers/auth_provider.dart';

class SuppliersManagementScreen extends ConsumerStatefulWidget {
  const SuppliersManagementScreen({super.key});

  @override
  ConsumerState<SuppliersManagementScreen> createState() =>
      _SuppliersManagementScreenState();
}

class _SuppliersManagementScreenState
    extends ConsumerState<SuppliersManagementScreen> {
  final _searchController = TextEditingController();
  List<Supplier> _suppliers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);
    try {
      final apiService = ref.read(apiServiceProvider);
      final suppliersService = SuppliersService(apiService);
      final suppliers = await suppliersService.getSuppliers(
        search: _searchController.text.isEmpty ? null : _searchController.text,
      );
      setState(() {
        _suppliers = suppliers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _showSupplierDialog([Supplier? supplier]) async {
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final contactController = TextEditingController(
      text: supplier?.contactName ?? '',
    );
    final emailController = TextEditingController(text: supplier?.email ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(supplier == null ? 'Crear Proveedor' : 'Editar Proveedor'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Empresa'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contacto'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final apiService = ref.read(apiServiceProvider);
                final suppliersService = SuppliersService(apiService);

                if (supplier == null) {
                  await suppliersService.createSupplier(
                    name: nameController.text,
                    contactName: contactController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    address: 'Por definir',
                    city: 'Por definir',
                  );
                } else {
                  await suppliersService.updateSupplier(
                    supplierId: supplier.id,
                    name: nameController.text,
                    contactName: contactController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                  );
                }

                Navigator.pop(context);
                _loadSuppliers();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      supplier == null
                          ? 'Proveedor creado'
                          : 'Proveedor actualizado',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: Text(supplier == null ? 'Crear' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showSupplierDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar proveedor',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) => _loadSuppliers(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _suppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = _suppliers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(supplier.name),
                          subtitle: Text(
                            '${supplier.contactName}\n${supplier.phone}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showSupplierDialog(supplier),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
