class AppHelperFunctions {
  static String getFlagUrl(String countryCode) {
    // Convert country code to lowercase as the URL requires lowercase
    return 'https://flagcdn.com/${countryCode.toLowerCase()}.svg';
  }
}
