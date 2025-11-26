import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(),
      child: _SearchView(),
    );
  }
}

class _SearchView extends StatelessWidget {
  const _SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _SearchBar(),

          ],
        ),
      ),
    );
  }
}
class _SearchBar extends StatelessWidget {
  const _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (searchContext, state) {
                return TextFormField(
                  initialValue: state.searchQuery,
                  onChanged: (value) {
                    searchContext.read<SearchBloc>().add(SearchEvent.queryChanged(value));
                  },
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                        onTap: () {
                          searchContext.read<SearchBloc>().add(SearchEvent.queryChanged(''));
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[700],
                        ),
                      ),
                      suffixIcon: Icon(
                        Icons.close,
                        color: Colors.grey[700],
                      ),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0)
                      ),
                      errorStyle: TextStyle(fontSize: 12.0)
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}


