import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sonic_flutter/widgets/user_account/user_search.widget.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  static const route = "/search";

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.1,
        ),
        child: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.2,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: CupertinoSearchTextField(
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            suffixIcon: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.white,
            ),
            placeholderStyle: const TextStyle(
              color: Colors.white,
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            onChanged: (String text) {
              setState(() {
                _searchQuery = text == '' ? 'empty' : text;
              });
            },
          ),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget _,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;

          return connected
              ? UserSearch(
                  query: _searchQuery,
                )
              : const Text('You are offline');
        },
        child: const SizedBox(),
      ),
    );
  }
}
