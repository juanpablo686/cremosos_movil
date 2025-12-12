// services/suppliers_service.dart - Servicio de gestión de proveedores

import '../models/supplier.dart';
import 'api_service.dart';

class SuppliersService {
  final ApiService _apiService;

  SuppliersService(this._apiService);

  /// Obtener lista de proveedores
  Future<List<Supplier>> getSuppliers({String? search, bool? isActive}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (isActive != null) {
        queryParams['isActive'] = isActive.toString();
      }

      final response = await _apiService.get(
        '/suppliers',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success'] == true) {
        return (response.data['data'] as List)
            .map((json) => Supplier.fromJson(json))
            .toList();
      }

      throw Exception('Error al obtener proveedores');
    } catch (e) {
      print('Error en getSuppliers: $e');
      rethrow;
    }
  }

  /// Obtener detalle de un proveedor
  Future<Supplier> getSupplierById(String supplierId) async {
    try {
      final response = await _apiService.get('/suppliers/$supplierId');

      if (response.data['success'] == true) {
        return Supplier.fromJson(response.data['data']);
      }

      throw Exception('Error al obtener proveedor');
    } catch (e) {
      print('Error en getSupplierById: $e');
      rethrow;
    }
  }

  /// Crear nuevo proveedor
  Future<Supplier> createSupplier({
    required String name,
    required String contactName,
    required String email,
    required String phone,
    required String address,
    required String city,
    List<String>? productsSupplied,
  }) async {
    try {
      final response = await _apiService.post(
        '/suppliers',
        data: {
          'name': name,
          'contactName': contactName,
          'email': email,
          'phone': phone,
          'address': address,
          'city': city,
          'productsSupplied': productsSupplied ?? [],
        },
      );

      if (response.data['success'] == true) {
        return Supplier.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Error al crear proveedor');
    } catch (e) {
      print('Error en createSupplier: $e');
      rethrow;
    }
  }

  /// Actualizar proveedor
  Future<Supplier> updateSupplier({
    required String supplierId,
    String? name,
    String? contactName,
    String? email,
    String? phone,
    String? address,
    String? city,
    List<String>? productsSupplied,
    bool? isActive,
    double? rating,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (contactName != null) data['contactName'] = contactName;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;
      if (productsSupplied != null) data['productsSupplied'] = productsSupplied;
      if (isActive != null) data['isActive'] = isActive;
      if (rating != null) data['rating'] = rating;

      final response = await _apiService.put(
        '/suppliers/$supplierId',
        data: data,
      );

      if (response.data['success'] == true) {
        return Supplier.fromJson(response.data['data']);
      }

      throw Exception(
        response.data['message'] ?? 'Error al actualizar proveedor',
      );
    } catch (e) {
      print('Error en updateSupplier: $e');
      rethrow;
    }
  }

  /// Eliminar proveedor
  Future<void> deleteSupplier(String supplierId) async {
    try {
      final response = await _apiService.delete('/suppliers/$supplierId');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Error al eliminar proveedor',
        );
      }
    } catch (e) {
      print('Error en deleteSupplier: $e');
      rethrow;
    }
  }
}
