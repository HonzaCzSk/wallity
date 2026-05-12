class Bank {
  final int id;
  final String name;
  final String rating;
  final String logoAsset;
  final String websiteUrl;
  final String cardBlockPhone;
  final String fraudReportUrl;

  // Czech
  final List<String> phishingExamples;
  final List<String> commonScams;
  final List<String> recentIncidents;
  final List<String> recommendedActions;

  // English (optional – falls back to Czech if absent)
  final List<String>? phishingExamplesEn;
  final List<String>? commonScamsEn;
  final List<String>? recentIncidentsEn;
  final List<String>? recommendedActionsEn;

  const Bank({
    required this.id,
    required this.name,
    required this.rating,
    required this.logoAsset,
    required this.websiteUrl,
    required this.cardBlockPhone,
    required this.fraudReportUrl,
    required this.phishingExamples,
    required this.commonScams,
    required this.recentIncidents,
    required this.recommendedActions,
    this.phishingExamplesEn,
    this.commonScamsEn,
    this.recentIncidentsEn,
    this.recommendedActionsEn,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    List<String> strings(dynamic v) =>
        v == null ? [] : List<String>.from(v as List);

    List<String>? stringsOpt(dynamic v) =>
        v == null ? null : List<String>.from(v as List);

    return Bank(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      logoAsset: json['logoAsset'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      cardBlockPhone: json['cardBlockPhone'] as String? ?? '',
      fraudReportUrl: json['fraudReportUrl'] as String? ?? '',
      phishingExamples: strings(json['phishing_examples']),
      commonScams: strings(json['common_scams']),
      recentIncidents: strings(json['recent_incidents']),
      recommendedActions: strings(json['recommended_actions']),
      phishingExamplesEn: stringsOpt(json['phishing_examples_en']),
      commonScamsEn: stringsOpt(json['common_scams_en']),
      recentIncidentsEn: stringsOpt(json['recent_incidents_en']),
      recommendedActionsEn: stringsOpt(json['recommended_actions_en']),
    );
  }

  /// Returns the correct list for the requested language, falling back to Czech.
  List<String> localizedPhishingExamples(bool en) =>
      (en && phishingExamplesEn != null && phishingExamplesEn!.isNotEmpty)
          ? phishingExamplesEn!
          : phishingExamples;

  List<String> localizedCommonScams(bool en) =>
      (en && commonScamsEn != null && commonScamsEn!.isNotEmpty)
          ? commonScamsEn!
          : commonScams;

  List<String> localizedRecentIncidents(bool en) =>
      (en && recentIncidentsEn != null && recentIncidentsEn!.isNotEmpty)
          ? recentIncidentsEn!
          : recentIncidents;

  List<String> localizedRecommendedActions(bool en) =>
      (en && recommendedActionsEn != null && recommendedActionsEn!.isNotEmpty)
          ? recommendedActionsEn!
          : recommendedActions;
}
