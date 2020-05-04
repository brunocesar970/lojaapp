import 'package:cielo_ecommerce/cielo_ecommerce.dart';
import 'package:flutter_loja_app_meu/tabs/meu_cartao.dart';
import 'package:scoped_model/scoped_model.dart';

class Cielo extends Model{

  bool isLoading = false;

  makePayment() async {
    isLoading = true;
    //inicia objeto da api
    final CieloEcommerce cielo = CieloEcommerce(
        environment: Environment.production, // ambiente de desenvolvimento
        merchant: Merchant(
          merchantId: "57be18b4-e44c-4a5d-9688-e360ccc9d27a",
          merchantKey: "mebOy0Q6U4OxVghgDoXCbfP1xcNVTH6q1uDmGikP",
        ));



    print("Transação Simples");
    print("Iniciando pagamento....");
    //Objeto de venda
    Sale sale = Sale(
      merchantOrderId: "2020032601", // Numero de identificação do Pedido
      customer: Customer(
        name: "Comprador crédito simples", // Nome do Comprador
      ),
      payment: Payment(
        type: TypePayment.creditCard, // Tipo do Meio de Pagamento
        amount: 100, // Valor do Pedido (ser enviado em centavos)
        installments: 1, // Número de Parcelas
        softDescriptor: "Mensagem", // Descrição que aparecerá no extrato do usuário. Apenas 15 caracteres
        creditCard: CreditCard(
            cardNumber: numeroCartaoController.text, // Número do Cartão do Comprador
            holder:nameController.text, // Nome do Comprador impresso no cartão
            expirationDate: dataController.text, // Data de validade impresso no cartão
            securityCode: CVVController.text, // Código de segurança impresso no verso do cartão
            brand: 'Master', // Bandeira do cartão
            saveCard: true
        ),
      ),
    );

    try {
      var response = await cielo.createSale(sale);

      print('paymentId ${response.payment.paymentId}');

    } on CieloException catch (e) {
      print(e);
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
    }
    notifyListeners();
  }

}






