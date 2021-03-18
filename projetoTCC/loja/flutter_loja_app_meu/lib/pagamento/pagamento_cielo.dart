import 'package:cielo_ecommerce/cielo_ecommerce.dart';
import 'package:flutter/material.dart';

class Cielo {

  static Future<String> makePayment({
    @required String cardNumber,
    @required String nameController,
    @required String dataController,
    @required String cvvController,
    @required double valor,
    @required String ordem,
  }) async {

     final CieloEcommerce _cielo = CieloEcommerce(
      environment: Environment.sandbox,
      merchant: Merchant(
        merchantId: "547a44c7-db7e-4ce6-8de2-bd27929022b9SSS",
        merchantKey: "FGRHHWBZFCLNSJDBGJUZRXRVHAXBKKOQYJHSDPUCPSSS",
      ),
    );


    print('Transação Simples\nIniciando pagamento....');
    Sale sale = Sale(
      merchantOrderId: ordem,
      customer: Customer(
        name: "Bruno cesar",
      ),
      payment: Payment(
        type: TypePayment.creditCard,
        amount: (valor * 100).toInt(),
        installments: 1,
        softDescriptor: "hjdjd",
        creditCard: CreditCard(
          cardNumber: cardNumber,
          holder: nameController,
          expirationDate: dataController,
          securityCode: cvvController,
          brand: 'Master',
          saveCard: false,
        ),
      ),
    );
    try {
      Sale response = await _cielo.createSale(sale);
      print("ORDEMDOPEDIDO===  >>>>>>>  " + ordem);
      print('Payment Id:${response.payment.paymentId}');
      print("Status:${response.payment.status}");
      print("ReturnCOD ${response.payment.returnCode}");
      print("Mensagem ${response.payment.returnMessage}");
      print("authorizationCode ${response.payment.authorizationCode}");

      if (response.payment.authorizationCode != null){
        return response.payment.paymentId;
      } else {
        return null;
      }

    } on CieloException catch (e) {
      print(e);
      print('erroCath>  ${e.message}');
      print('erroCath>  ${e.errors[0].message}');
      print('erroCath>  ${e.errors[0].code}');
      return null;
    }
  }
}
