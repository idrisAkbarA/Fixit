class Endpoint {
  static const baseUrl = "http://192.168.1.16:8000";
  static const login = "$baseUrl/api/auth/login";
  static String getServices(idService) {return "$baseUrl/api/partner/get-partners-by-service/$idService";}
  static String getPartner(idPartner) {return "$baseUrl/api/partner/get-partner/$idPartner";}
  static String previewBooking(idPartner,idService){return "$baseUrl/api/partner/$idPartner/service/$idPartner";}
  static const register = "$baseUrl/api/auth/register";
}