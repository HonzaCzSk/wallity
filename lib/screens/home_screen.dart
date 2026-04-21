import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank.dart';
import '../widgets/bank_card.dart';
import '../utils/seo.dart';
import '../utils/language.dart';
import '../lang/app_strings.dart';
import 'bank_info_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool focusSearch;
  final int initialTab;

  const HomeScreen({super.key, this.focusSearch = false, this.initialTab = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchController;

  static const String _sortNone = 'none';

  int ratingValue(String r) {
    const map = {
      "A+": 8, "A": 7, "A-": 6, "B+": 5, "B": 4,
      "B-": 3, "C+": 2, "C": 1, "C-": 0,
    };
    return map[r] ?? 0;
  }

  String normalize(String text) {
    const Map<String, String> diacritics = {
      'Á': 'A', 'á': 'a', 'Č': 'C', 'č': 'c', 'Ď': 'D', 'ď': 'd',
      'É': 'E', 'é': 'e', 'Ě': 'E', 'ě': 'e', 'Í': 'I', 'í': 'i',
      'Ň': 'N', 'ň': 'n', 'Ó': 'O', 'ó': 'o', 'Ř': 'R', 'ř': 'r',
      'Š': 'S', 'š': 's', 'Ť': 'T', 'ť': 't', 'Ú': 'U', 'ú': 'u',
      'Ů': 'U', 'ů': 'u', 'Ý': 'Y', 'ý': 'y', 'Ž': 'Z', 'ž': 'z',
    };
    diacritics.forEach((k, v) => text = text.replaceAll(k, v));
    return text.toLowerCase();
  }

  String _sortOption = _sortNone;
  List<Bank> banks = [];
  String searchQuery = '';

  List<Bank> get filteredBanks {
    final q = normalize(searchQuery).trim();
    if (q.isEmpty) return banks;
    return banks.where((b) => normalize(b.name).contains(q)).toList();
  }

  List<Bank> _sortedBanks(List<Bank> input) {
    final out = List<Bank>.from(input);
    if (_sortOption == "name_asc") {
      out.sort((a, b) => normalize(a.name).compareTo(normalize(b.name)));
    } else if (_sortOption == "name_desc") {
      out.sort((a, b) => normalize(b.name).compareTo(normalize(a.name)));
    } else if (_sortOption == "rating_best") {
      out.sort((a, b) => ratingValue(b.rating).compareTo(ratingValue(a.rating)));
    } else if (_sortOption == "rating_worst") {
      out.sort((a, b) => ratingValue(a.rating).compareTo(ratingValue(b.rating)));
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    SeoHelper.set(
      title: 'Banky – Wallity',
      description: 'Vyhledejte banku, zjistěte kontakty a bezpečnostní informace.',
    );
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    loadBanks();
    if (widget.focusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!mounted) return;
          FocusScope.of(context).requestFocus(_searchFocusNode);
          SystemChannels.textInput.invokeMethod('TextInput.show');
          _searchController.selection = TextSelection.collapsed(
            offset: _searchController.text.length,
          );
        });
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadBanks() async {
    final String response = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/banks.json');
    final data = jsonDecode(response) as List<dynamic>;
    final loaded = data.map((e) => Bank.fromJson(e)).toList();
    final sorted = _sortedBanks(loaded);
    setState(() => banks = sorted);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: languageNotifier,
      builder: (context, isEn, _) {
        final s = S(isEn);
        final currentFiltered = filteredBanks;
        final allBanks = banks;

        return DefaultTabController(
          length: 2,
          initialIndex: widget.initialTab,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F9FF),
            appBar: AppBar(
              title: Text(
                s.safeBanking,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(text: s.tabSearch, icon: const Icon(Icons.search)),
                  Tab(text: s.tabBrowse, icon: const Icon(Icons.list)),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: PopupMenuButton<String>(
                    tooltip: s.sortTooltip,
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onSelected: (value) {
                      setState(() {
                        _sortOption = value;
                        banks = _sortedBanks(banks);
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: "none", child: Text(s.sortNone)),
                      PopupMenuItem(value: "name_asc", child: Text(s.sortNameAsc)),
                      PopupMenuItem(value: "name_desc", child: Text(s.sortNameDesc)),
                      PopupMenuItem(value: "rating_best", child: Text(s.sortRatingBest)),
                      PopupMenuItem(value: "rating_worst", child: Text(s.sortRatingWorst)),
                    ],
                  ),
                ),
              ],
            ),
            body: allBanks.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Search tab
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              autofocus: widget.focusSearch,
                              decoration: InputDecoration(
                                hintText: s.searchBankHint,
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) => setState(() => searchQuery = value),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: currentFiltered.length,
                              itemBuilder: (context, index) {
                                final bank = currentFiltered[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: BankCard(
                                    bank: bank,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BankDetailScreen(bank: bank),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      // Browse tab
                      ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: allBanks.length,
                        itemBuilder: (context, index) {
                          final bank = allBanks[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: BankCard(
                              bank: bank,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BankDetailScreen(bank: bank),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
