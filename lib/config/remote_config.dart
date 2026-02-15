class RemoteConfig {
  static const String baseDataUrl = 'https://wallity.cz/data';

  // ✅ ručně měníš, když updatuješ JSON na serveru
  static const String dataVersion = 'v0.3.0';

  static String banksUrl() => '$baseDataUrl/banks.json?v=$dataVersion';
  static String kidsQuestionsUrl() => '$baseDataUrl/questions_kids.json?v=$dataVersion';
  static String normalQuestionsUrl() => '$baseDataUrl/questions_normal.json?v=$dataVersion';
}
