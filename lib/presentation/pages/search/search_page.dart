import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/repository/search_repository_impl.dart';
import 'package:social_media_app/presentation/widget/user_card.dart';
import 'bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (searchContext) => SearchBloc(
        searchRepository: searchContext.read<SearchRepositoryImpl>()
      ),
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // search bar
                _SearchBar(),
                SizedBox(height: 10.0,),

                // search result in cards
                _SearchResult()
              ],
            ),
          ),
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
              buildWhen: (previous, current) =>
                previous.searchQuery != current.searchQuery,
              builder: (searchContext, state) {
                return TextFormField(
                  initialValue: state.searchQuery,
                  onChanged: (value) {
                    searchContext.read<SearchBloc>().add(SearchEvent.queryChanged(value));
                    searchContext.read<SearchBloc>().add(SearchEvent.searchUsers(state.searchQuery));
                  },
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          searchContext.read<SearchBloc>().add(SearchEvent.searchUsers(state.searchQuery));
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.grey[700],
                        ),
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

class _SearchResult extends StatelessWidget {
  const _SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return switch(state.status) {
          SearchStatus.idle => SizedBox(),
          SearchStatus.processing => Center( child: CircularProgressIndicator(), ),
          SearchStatus.failed => throw UnimplementedError(),
          SearchStatus.success => Expanded(
                child: ListView.builder(
                  itemCount: state.searchResult.length,
                  itemBuilder: (context, index) {
                    var user = state.searchResult.elementAt(index);

                    debugPrint('--- _SearchResult ${user.id} ${user.username}');

                    return UserCard(
                      userEntity: user,
                    );
                  },
                )
            ),
        };
      },
    );
  }
}



