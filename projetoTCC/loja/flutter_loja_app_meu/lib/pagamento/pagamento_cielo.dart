import 'package:cielo_ecommerce/cielo_ecommerce.dart';
import 'package:flutter/material.dart';

class Cielo {
  static final CieloEcommerce _cielo = CieloEcommerce(
    environment: Environment.production,
    merchant: Merchant(
      merchantId: "57be18b4-e44c-4a5d-9688-e360ccc9d27a",
      merchantKey: "mebOy0Q6U4OxVghgDoXCbfP1xcNVTH6q1uDmGikP",
    ),
  );

  static Future<void> makePayment({
    @required String cardNumber,
    @required String nameController,
    @required String dataController,
    @required String cvvController,
    @required double valor,
  }) async {
    print('Transação Simples\nIniciando pagamento....');
    Sale sale = Sale(
      merchantOrderId: "2020032601",
      customer: Customer(
        name: "Comprador crédito simples",
      ),
      payment: Payment(
        type: TypePayment.creditCard,
        amount: (valor * 100).toInt(),
        installments: 1,
        softDescriptor: "Mensagem",
        creditCard: CreditCard(
          cardNumber: cardNumber,
          holder: nameController,
          expirationDate: dataController,
          securityCode: cvvController,
          brand: 'Master',
          saveCard: true,
        ),
      ),
    );
    try {
      Sale response = await _cielo.createSale(sale);
      print('Payment Id:${response.payment.paymentId}');
    } on CieloException catch (e) {
      print(e);
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
    }
  }
}
