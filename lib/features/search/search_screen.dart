import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/repositories/search_repository.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _q = TextEditingController();
  Timer? _debounce;
  List<SearchResult> _results = const [];
  bool _busy = false;

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      setState(() => _busy = true);
      final r = await ref.read(searchRepositoryProvider).search(v);
      if (mounted && _q.text == v) {
        setState(() {
          _results = r;
          _busy = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _q.dispose();
    super.dispose();
  }

  static const _labels = {
    SearchKind.company: ('Companies', Icons.apartment),
    SearchKind.machine: ('Machines', Icons.precision_manufacturing_outlined),
    SearchKind.visit: ('Service visits', Icons.build_outlined),
    SearchKind.invoice: ('Invoices', Icons.receipt_long_outlined),
    SearchKind.part: ('Spare parts', Icons.inventory_2_outlined),
  };

  String _route(SearchResult r) => switch (r.kind) {
    SearchKind.company => '/company/${r.id}',
    SearchKind.machine => '/machine/${r.id}',
    SearchKind.visit => '/visit/${r.id}',
    SearchKind.invoice => '/invoice/${r.id}',
    SearchKind.part => '/part/${r.id}',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextField(
        controller: _q,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Company, phone, serial no., visit, invoice, part…',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          filled: false,
        ),
        onChanged: _onChanged,
      ),
      actions: [
        if (_q.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _q.clear();
              setState(() => _results = const []);
            },
          ),
      ],
    ),
    body: _q.text.trim().length < 2
        ? const EmptyState(
            icon: Icons.search,
            title: 'Search everything',
            message: 'Type at least 2 letters or digits',
          )
        : _busy && _results.isEmpty
        ? const LoadingView()
        : _results.isEmpty
        ? const EmptyState(icon: Icons.search_off, title: 'Nothing found')
        : ListView(
            children: [
              for (final kind in SearchKind.values)
                if (_results.any((r) => r.kind == kind)) ...[
                  ListHeader(_labels[kind]!.$1),
                  for (final r in _results.where((r) => r.kind == kind))
                    ListTile(
                      leading: Icon(
                        _labels[kind]!.$2,
                        color: context.colors.primary,
                      ),
                      title: Text(
                        r.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: r.subtitle.isEmpty
                          ? null
                          : Text(
                              r.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      onTap: () => context.push(_route(r)),
                    ),
                ],
            ],
          ),
  );
}
