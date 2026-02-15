import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bank.dart';
import '../widgets/bank_card.dart';
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
  int ratingValue(String r) {
    const map = {
      "A+": 8,
      "A": 7,
      "A-": 6,
      "B+": 5,
      "B": 4,
      "B-": 3,
      "C+": 2,
      "C": 1,
      "C-": 0,
    };
    return map[r] ?? 0;
  }

  String normalize(String text) {
    const Map<String, String> diacritics = {
      'Á': 'A',
      'á': 'a',
      'Č': 'C',
      'č': 'c',
      'Ď': 'D',
      'ď': 'd',
      'É': 'E',
      'é': 'e',
      'Ě': 'E',
      'ě': 'e',
      'Í': 'I',
      'í': 'i',
      'Ň': 'N',
      'ň': 'n',
      'Ó': 'O',
      'ó': 'o',
      'Ř': 'R',
      'ř': 'r',
      'Š': 'S',
      'š': 's',
      'Ť': 'T',
      'ť': 't',
      'Ú': 'U',
      'ú': 'u',
      'Ů': 'U',
      'ů': 'u',
      'Ý': 'Y',
      'ý': 'y',
      'Ž': 'Z',
      'ž': 'z',
    };
    diacritics.forEach((k, v) {
      text = text.replaceAll(k, v);
    });
    return text.toLowerCase();
  }

  String _sortOption = 'none';
  List<Bank> banks = [];
  String searchQuery = '';

  List<Bank> get filteredBanks {
    final q = normalize(searchQuery).trim();
    if (q.isEmpty) return banks;
    return banks.where((b) => normalize(b.name).contains(q)).toList();
  }

  void sortBanks() {
    setState(() {
      if (_sortOption == "name_asc") {
        banks.sort((a, b) => normalize(a.name).compareTo(normalize(b.name)));
      } else if (_sortOption == "name_desc") {
        banks.sort((a, b) => normalize(b.name).compareTo(normalize(a.name)));
      } else if (_sortOption == "rating_best") {
        banks.sort(
          (a, b) => ratingValue(b.rating).compareTo(ratingValue(a.rating)),
        );
      } else if (_sortOption == "rating_worst") {
        banks.sort(
          (a, b) => ratingValue(a.rating).compareTo(ratingValue(b.rating)),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
    setState(() {
      banks = data.map((e) => Bank.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFiltered = filteredBanks;
    final allBanks = banks;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        appBar: AppBar(
          title: const Text(
            'Safe Banking',
            style: TextStyle(fontWeight: FontWeight.bold),
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Vyhledat', icon: Icon(Icons.search)),
              Tab(text: 'Procházet', icon: Icon(Icons.list)),
            ],
          ),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortOption,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                dropdownColor: Colors.white,
                padding: const EdgeInsets.only(right: 12),
                items: const [
                  DropdownMenuItem(
                    value: "none",
                    child: Text("Bez řazení"),
                  ),
                  DropdownMenuItem(value: "name_asc", child: Text("A–Z")),
                  DropdownMenuItem(
                    value: "name_desc",
                    child: Text("Z–A"),
                  ),
                  DropdownMenuItem(
                    value: "rating_best",
                    child: Text("Nejlepší rating"),
                  ),
                  DropdownMenuItem(
                    value: "rating_worst",
                    child: Text("Nejhorší rating"),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  _sortOption = value;
                  sortBanks();
                },
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
                            hintText: "Vyhledat banku…",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BankDetailScreen(bank: bank),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  // Browse tab (full list)
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allBanks.length,
                    itemBuilder: (context, index) {
                      final bank = allBanks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: BankCard(
                          bank: bank,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BankDetailScreen(bank: bank),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
