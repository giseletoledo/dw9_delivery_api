import 'dart:developer';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/pages/home/home_state.dart';
import 'package:dw9_delivery_app/app/repositories/products/products_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<RegisterState> {
  final ProductsRepository _productsRepository;

  HomeController(this._productsRepository)
      : super(const RegisterState.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));

    try {
      final products = await _productsRepository.findAllProducts();
      //throw Exception();
      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } on Exception catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: HomeStateStatus.error,
            errorMessage: 'Erro ao buscar produtos'),
      );
    }
  }

  void addOrUpdateCart(OrderProductDto orderProduct) {
    final shoppingBag = [...state.shoppingBag]; //faz uma cópia do array antigo
    final orderIndex = shoppingBag
        .indexWhere((element) => element.product == orderProduct.product);
    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      shoppingBag.add(orderProduct);
    }
    emit(
      state.copyWith(shoppingBag: shoppingBag),
    );
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
