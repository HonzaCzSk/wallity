/// Všechny texty aplikace v češtině a angličtině.
///
/// Použití:
///   final s = S(languageNotifier.value);
///   Text(s.emergencyMode)
class S {
  final bool en;
  const S(this.en);

  // ─── home_page ────────────────────────────────────────────────────
  String get appTitle => 'Wallity';
  String get welcomeTitle => en ? 'Welcome to Wallity' : 'Vítejte v Wallity';
  String get welcomeSubtitle =>
      en ? 'Quick and secure banking information.' : 'Rychlé a bezpečné informace o bankách.';
  String get emergencyMode => en ? 'Emergency Mode' : 'Nouzový režim';
  String get searchBank => en ? 'Search for a Bank' : 'Vyhledat banku';
  String get browseBanks => en ? 'Browse Banks' : 'Procházet banky';
  String get training => en ? 'Training' : 'Trénink';
  String get kidsTraining => en ? 'Kids Training 👶' : 'Dětský trénink 👶';
  String get about => en ? 'About' : 'O aplikaci';
  String get copyright =>
      en ? '© 2025-26 Wallity. All rights reserved.' : '© 2025-26 Wallity. Všechna práva vyhrazena.';

  // ─── home_screen ──────────────────────────────────────────────────
  String get safeBanking => en ? 'Safe Banking' : 'Safe Banking';
  String get tabSearch => en ? 'Search' : 'Vyhledat';
  String get tabBrowse => en ? 'Browse' : 'Procházet';
  String get sortTooltip => en ? 'Sort' : 'Řazení';
  String get sortNone => en ? 'No sorting' : 'Bez řazení';
  String get sortNameAsc => en ? 'A–Z' : 'A–Z';
  String get sortNameDesc => en ? 'Z–A' : 'Z–A';
  String get sortRatingBest => en ? 'Best rating' : 'Nejlepší rating';
  String get sortRatingWorst => en ? 'Worst rating' : 'Nejhorší rating';
  String get searchBankHint => en ? 'Search for a bank…' : 'Vyhledat banku…';

  // ─── bank_info_detail_screen ──────────────────────────────────────
  String get safetyHigh => en ? 'High security' : 'Vysoká bezpečnost';
  String get safetyGood => en ? 'Good security' : 'Dobrá bezpečnost';
  String get safetyCaution => en ? 'Caution' : 'Pozor';
  String get safetyHighRisk => en ? 'High risk' : 'Vysoké riziko';
  String get safetyUnknown => en ? 'Unknown' : 'Neznámé';
  String get ratingLabel => en ? 'Rating: ' : 'Hodnocení: ';
  String get sectionPhishing => en ? 'Phishing SMS / Email' : 'Podvodné SMS / Email';
  String get sectionScams => en ? 'Common Scams' : 'Časté podvody';
  String get sectionIncidents => en ? 'Recent Incidents' : 'Nedávné incidenty';
  String get sectionRecommended =>
      en ? 'Recommended Security Measures' : 'Doporučená bezpečnostní opatření';

  // ─── block_card_screen ────────────────────────────────────────────
  String get blockCardTitle => en ? 'Block Card' : 'Zablokovat kartu';
  String get bankFallback => en ? 'Bank' : 'Banka';
  String get officialContactsWarning =>
      en ? 'Use only official contacts. Do not call numbers from SMS/emails.' : 'Používejte jen oficiální kontakty. Nevolejte čísla ze SMS/e-mailů.';
  String get cardBlockNA => en ? 'Card block: not available' : 'Blokace karty: není k dispozici';
  String cardBlockPhone(String phone) => en ? 'Card block: $phone' : 'Blokace karty: $phone';
  String get callCardBlock => en ? 'Call card block line' : 'Zavolat blokaci karty';
  String get openBankWebsite => en ? 'Open bank website' : 'Otevřít web banky';
  String get reportFraud => en ? 'Security / Report fraud' : 'Bezpečnost / nahlášení podvodu';
  String get searchBankLabel => en ? 'Search bank' : 'Vyhledat banku';

  // ─── emergency_bank_select_screen ─────────────────────────────────
  String get contactBankTitle => en ? 'Contact Bank' : 'Kontaktovat banku';
  String get confirmLeaveTitle => en ? 'Are you sure you want to leave?' : 'Opravdu chcete odejít?';
  String get confirmLeaveBody =>
      en ? 'You are in emergency mode. Leaving may slow down the resolution.' : 'Jste v krizovém režimu. Odchod může zpomalit řešení situace.';
  String get stayButton => en ? 'Stay' : 'Zůstat';
  String get leaveButton => en ? 'Leave' : 'Odejít';
  String get emergencyNotice =>
      en ? 'Do not call back the number from SMS or email.\nUse only the official bank website/app or contacts from this screen.' : 'Nevolejte zpět na číslo z SMS nebo e-mailu.\nPoužijte pouze oficiální web/aplikaci banky nebo kontakt z této obrazovky.';
  String get bankPhoneNA => en ? 'Bank phone: not available' : 'Telefon banky: není k dispozici';
  String get callBankOfficial => en ? 'Call bank (official line)' : 'Zavolat bance (oficiální linka)';
  String get openOfficialContacts => en ? 'Open official contacts' : 'Otevřít oficiální kontakty';
  String get searchBankHintEmergency => en ? 'Search bank…' : 'Hledat banku…';
  String get nothingFound => en ? 'Nothing found.' : 'Nic nenalezeno.';

  // ─── emergency_screen ─────────────────────────────────────────────
  String get emergencyScreenTitle => en ? 'Emergency Mode' : 'Nouzový režim';
  String get selectSituation => en ? 'Select situation' : 'Vyber situaci';
  String get vishingTitle => en ? 'I received a call from a bank / police' : 'Volali mi z banky / policie';
  String get vishingSubtitle => en ? 'Possible vishing (fake call)' : 'Možný vishing (falešný hovor)';
  String get smishingTitle => en ? 'I clicked a link in an SMS/email' : 'Klikl/a jsem na odkaz v SMS/e-mailu';
  String get smishingSubtitle => en ? 'Possible smishing / phishing' : 'Možný smishing / phishing';
  String get highRiskTitle =>
      en ? 'I entered card details / authorization code' : 'Zadal/a jsem údaje z karty / autorizační kód';
  String get highRiskSubtitle => en ? 'High risk – act immediately' : 'Vysoké riziko – jednejte okamžitě';
  String get emergencyFooter =>
      en ? 'If you are unsure, select the scenario closest to your situation. The app will guide you through specific steps.' : 'Pokud si nejste jistí, vyberte scénář, který je nejblíže vaší situaci. Aplikace vás provede konkrétními kroky.';

  // ─── report_scam_screen ───────────────────────────────────────────
  String get reportScamTitle => en ? 'Fraud Response Guide' : 'Postup při podvodu';
  String get whatToDoNow => en ? 'What to do immediately:' : 'Co udělat ihned:';
  String get reportStep1 => en ? '• Immediately contact your bank.' : '• Okamžitě kontaktujte svou banku.';
  String get reportStep2 => en ? '• Block your card or account access.' : '• Zablokujte kartu nebo přístup k účtu.';
  String get reportStep3 => en ? '• Do not respond further to the fraudster.' : '• Neodpovídejte dále podvodníkovi.';
  String get whoToContact => en ? 'Who to contact:' : 'Koho kontaktovat:';
  String get contactStep1 => en ? '• The official customer line of your bank.' : '• Oficiální zákaznickou linku vaší banky.';
  String get contactStep2 =>
      en ? '• Czech Police (158) in case of financial loss.' : '• Policii ČR (158) v případě finanční škody.';
  String get whatToPrepare => en ? 'What to prepare:' : 'Co si připravit:';
  String get prepareStep1 => en ? '• Date and time of the incident.' : '• Datum a čas incidentu.';
  String get prepareStep2 => en ? '• Screenshots of communication.' : '• Screenshoty komunikace.';
  String get prepareStep3 => en ? '• The amount that was stolen.' : '• Částku, která byla odcizena.';
  String get watchOut => en ? 'What to watch out for:' : 'Na co si dát pozor:';
  String get watchStep1 =>
      en ? '• A bank never asks for an authorization code over the phone.' : '• Banka nikdy nevyžaduje autorizační kód po telefonu.';
  String get watchStep2 =>
      en ? "• Never transfer money to a 'safe account'." : "• Nikdy nepřevádějte peníze na 'bezpečný účet'.";
  String get watchStep3 =>
      en ? '• Do not install apps at the request of an unknown person.' : '• Neinstalujte aplikace na žádost neznámé osoby.';

  // ─── training_screen ──────────────────────────────────────────────
  String get securityTrainingTitle => en ? 'Security Training' : 'Bezpečnostní výcvik';
  String get kidsTrainingTitle => en ? 'Kids Training' : 'Dětský trénink';
  String levelLabel(int lvl) => en ? 'Level: $lvl' : 'Level: $lvl';
  String scoreLabel(int score, int total, int orig) {
    final extra = orig > 5 ? ' (max 5)' : '';
    return en ? 'Score: $score / $total$extra' : 'Skóre: $score / $total$extra';
  }

  String get loadedOnline => en ? 'Loaded: online' : 'Načteno: online';
  String get loadedOffline => en ? 'Loaded: offline' : 'Načteno: offline';
  String get changeDifficulty => en ? 'Change difficulty' : 'Změnit obtížnost';
  String questionLabel(int current, int total, int orig) {
    final extra = orig > 5 ? ' (max 5)' : '';
    return en ? 'Question $current/$total$extra' : 'Otázka $current/$total$extra';
  }

  String get selectDifficulty => en ? 'Select difficulty' : 'Vyber obtížnost';
  String get easyKids => en ? 'Easy 😊' : 'Lehké 😊';
  String get harderKids => en ? 'Harder 😈' : 'Těžší 😈';
  String get easyNormal => en ? 'Easy' : 'Lehké';
  String get harderNormal => en ? 'Harder' : 'Těžší';
  String get difficultyHintKids =>
      en ? 'Start with the easy level (max 5 questions). If you manage, try harder.' : 'Začni lehkým levelem (max 5 otázek). Když dáš, zkus těžší.';
  String get difficultyHintNormal =>
      en ? 'Choose your difficulty (max 5 questions per level). Questions are filtered by level.' : 'Zvol si obtížnost (max 5 otázek na level). Otázky se filtrují podle levelu.';
  String get answerCorrectKids => en ? 'Great! 🌟' : 'Super! 🌟';
  String get answerCorrectNormal => en ? 'Correct ✅' : 'Správně ✅';
  String get answerWrongKids => en ? 'Try again 🙂' : 'Zkus to znovu 🙂';
  String get answerWrongNormal => en ? 'Wrong ❌' : 'Špatně ❌';
  String get next => en ? 'Next' : 'Další';
  String get doneKids => en ? 'Done! 🎉' : 'Hotovo! 🎉';
  String get doneNormal => en ? 'Completed ✅' : 'Dokončeno ✅';
  String scoreDialog(int score, int total) =>
      en ? 'Score: $score / $total' : 'Skóre: $score / $total';
  String get playAgainKids => en ? 'Again' : 'Znovu';
  String get playAgainNormal => en ? 'Restart' : 'Spustit znovu';
  String get back => en ? 'Back' : 'Zpět';
  String get tipKids =>
      en ? 'Tip: never share your password or SMS code with anyone.' : 'Tip: nikdy nikomu neposílej heslo ani kód z SMS.';
  String get tipNormal =>
      en ? 'Tip: never share your authorization code or login credentials.' : 'Tip: nikdy nesděluj autorizační kód z SMS ani přihlašovací údaje.';

  // ─── about_page ───────────────────────────────────────────────────
  String get aboutTitle => en ? 'About' : 'O aplikaci';
  String get aboutDescription =>
      en ? 'Offline security guide: quick bank contacts, emergency steps, and short fraud prevention training.' : 'Offline průvodce bezpečností: rychlé kontakty bank, nouzové kroky a krátké tréninky proti podvodům.';
  String get versionLabel => en ? 'Version' : 'Verze';
  String get devBuild => en ? 'App: dev build' : 'Aplikace: dev build';
  String appVersion(String v, String b) => en ? 'App: $v (build $b)' : 'Aplikace: $v (build $b)';
  String get howItWorks => en ? 'How it works' : 'Jak to funguje';
  String get howItWorksBody =>
      en ? 'The app works offline. When internet is available, it may download updated data (e.g. questions and bank database).' : 'Aplikace funguje offline. Když je internet k dispozici, může si stáhnout novější data (např. otázky a databázi bank).';
  String get onlineData => en ? 'Online data' : 'Online data';
  String get importantNotice => en ? 'Important Notice' : 'Důležité upozornění';
  String get noticeBody =>
      en ? '• Wallity is not a bank or government institution.\n• Never send SMS codes or login credentials.\n• In emergencies, use only official contacts and web addresses.' : '• Wallity není banka ani státní instituce.\n• Nikdy neposílejte kódy z SMS ani přihlašovací údaje.\n• V nouzi používejte pouze oficiální kontakty a webové adresy.';
  String get openWebsite => en ? 'Open wallity.cz' : 'Otevřít wallity.cz';
  String get githubRepo => en ? 'GitHub repository' : 'GitHub repozitář';
  String get license => en ? 'License: MIT' : 'Licence: MIT';

  // ─── panic_scenario_screen ────────────────────────────────────────
  String get panicNoticeText =>
      en ? 'Use only official contacts.\nDo not call back numbers from SMS/email and do not click any links.' : 'Používejte jen oficiální kontakty.\nNevolejte zpět na čísla z SMS/e-mailu a neklikejte na odkazy.';

  // Scenario titles (AppBar)
  String get vishingScenarioTitle => en ? 'Call from bank / police' : 'Volali mi z banky / policie';
  String get smishingScenarioTitle => en ? 'Clicked a link' : 'Kliknutí na odkaz';
  String get highRiskScenarioTitle => en ? 'Compromised card' : 'Kompromitovaná karta';

  // Scenario subtitles / descriptions
  String get vishingDesc =>
      en ? 'Probably vishing – someone is pushing you into quick action.' : 'Pravděpodobně vishing – někdo vás tlačí do rychlé akce.';
  String get smishingDesc =>
      en ? 'Smishing/phishing – credentials may have been stolen or malicious content installed.' : 'Smishing/phishing – mohlo dojít ke krádeži přístupů nebo instalaci škodlivého obsahu.';
  String get highRiskDesc =>
      en ? 'High risk – you need to act now, minutes matter.' : 'Vysoké riziko – je potřeba jednat hned, minuty rozhodují.';

  // Action buttons in scenario
  String get selectBankAndAct => en ? 'Select bank and act' : 'Vybrat banku a jednat';
  String get fraudGuide => en ? 'Fraud response guide' : 'Postup při podvodu';
  String get callPolice => en ? 'Call 158 (Police)' : 'Zavolat 158 (Policie)';
  String get copyTextForBank => en ? 'Copy text for bank/police' : 'Kopírovat text pro banku/policii';
  String get copyIncidentSummary => en ? 'Copy incident summary' : 'Kopírovat souhrn incidentu';
  String get noteHint => en ? 'Note (optional)' : 'Poznámka (volitelné)';
  String get whatToDoNowSection => en ? 'What to do now' : 'Co dělat teď';
  String get copiedToClipboard => en ? 'Copied to clipboard' : 'Zkopírováno do schránky';

  // Vishing checklist steps
  List<String> get vishingSteps => en
      ? [
          'End the call immediately.',
          'Do not install anything (AnyDesk/TeamViewer) and do not confirm anything.',
          'Block your card / internet banking in your banking app if you can.',
          'Do not share any codes, passwords, or card details.',
          'Contact your bank on its official number (from the back of your card or the official website).',
        ]
      : [
          'Okamžitě ukončete hovor.',
          'Nic neinstalujte (AnyDesk/TeamViewer), nic nepotvrzujte.',
          'Zablokujte kartu / internetové bankovnictví v aplikaci banky, pokud můžete.',
          'Nesdělujte žádné kódy, hesla ani údaje z karty.',
          'Kontaktujte svou banku na oficiálním čísle (ze zadní strany karty nebo z webu).',
        ];

  // Smishing checklist steps
  List<String> get smishingSteps => en
      ? [
          'Close the page immediately and do not fill in anything else.',
          'If you entered login credentials: change your password right now.',
          'Check your email (forwarding rules, sign-ins, connected devices).',
          'Contact your bank and report the incident.',
          'Run a malware scan on your device.',
        ]
      : [
          'Okamžitě zavřete stránku a nic dalšího nevyplňujte.',
          'Pokud jste zadal/a přihlašovací údaje: změňte heslo hned teď.',
          'Zkontrolujte e-mail (změny pravidel přeposílání, přihlášení, zařízení).',
          'Kontaktujte svou banku a nahlaste incident.',
          'Spusťte kontrolu zařízení na malware.',
        ];

  // High risk checklist steps
  List<String> get highRiskSteps => en
      ? [
          'Immediately block your card / payment tokens in your banking app.',
          'Call your bank on the official number and report the compromise.',
          'Check and cancel suspicious transactions or payees if possible.',
          'Report the incident to the police (158) — financial damage has likely occurred.',
          'Document all communication (screenshots, call log).',
        ]
      : [
          'Okamžitě zablokujte kartu / platební tokeny v aplikaci banky.',
          'Zavolejte do banky přes oficiální číslo a nahlaste kompromitaci.',
          'Zkontrolujte a zrušte podezřelé transakce / příjemce (pokud to jde).',
          'Nahlaste incident policii (158) – pravděpodobně došlo k finanční škodě.',
          'Zdokumentujte veškerou komunikaci (screenshoty, výpis hovorů).',
        ];

  // Copy text template for bank/police
  String panicCopyText(String scenarioName, String note) {
    if (en) {
      return 'INCIDENT REPORT – Wallity\n'
          'Scenario: $scenarioName\n'
          'Note: ${note.isEmpty ? "(none)" : note}\n\n'
          'Please investigate and take appropriate action.';
    }
    return 'HLÁŠENÍ INCIDENTU – Wallity\n'
        'Scénář: $scenarioName\n'
        'Poznámka: ${note.isEmpty ? "(žádná)" : note}\n\n'
        'Prosím o prošetření a přijetí opatření.';
  }

  // ─── shared ───────────────────────────────────────────────────────
  String get errorPrefix => en ? 'Error: ' : 'Chyba: ';
  String get noBanks => en ? 'No banks in database.' : 'Žádné banky v databázi.';
  String get loading => en ? 'Loading…' : 'Načítání…';
  String get noQuestions => en ? 'No questions available.' : 'Žádné otázky.';
}
