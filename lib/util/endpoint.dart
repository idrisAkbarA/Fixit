class Endpoint {
  static const baseUrl = "http://192.168.1.10:8000";
  static const login = "$baseUrl/api/auth/login";
  static const register = "$baseUrl/api/auth/register";
  static const registerAsPartner = "$baseUrl/api/partner/create";
  static String storePartnerServices = "$baseUrl/api/partner-service/store";
  static String updateUser = "$baseUrl/api/user/update";
  static String logout= "$baseUrl/api/auth/logout";


  static String getPartnerServices(idPartner){return "$baseUrl/api/service/get-services-by-partner/$idPartner";}
  static String getServices(idService) {return "$baseUrl/api/partner/get-partners-by-service/$idService";}
  static String getPartner(idPartner) {return "$baseUrl/api/partner/get-partner/$idPartner";}
  static String previewBooking(idPartner,idService){return "$baseUrl/api/partner/get-partner/$idPartner/service/$idService";}
  static String bookJasa(){return "$baseUrl/api/order/create";}
  static String transactionHistory(userId){return "$baseUrl/api/transaction/get-transactions-by-user/$userId";}
  static String partnerTransactionHistory(partnerId){return "$baseUrl/api/transaction/get-transactions-by-partner/$partnerId";}
  static String transaction(transactionId){return "$baseUrl/api/transaction/get-transaction/$transactionId";}
  static const confirmOrder =  "$baseUrl/api/transaction/accept/";
  static const rejectOrder  = "$baseUrl/api/transaction/reject/";
  static const finishOrder = "$baseUrl/api/transaction/finish/";
}