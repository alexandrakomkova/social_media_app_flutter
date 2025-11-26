import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/domain/model/user_entity.dart';
import 'package:social_media_app/presentation/widget/user_card.dart';
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
            // search bar
            _SearchBar(),
            SizedBox(height: 10.0,),

            // search result in cards
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Expanded(
                    child: ListView.builder(
                      itemCount: 2, // state.searchResult.length,
                      itemBuilder: (context, index) {
                        // var user = state.searchResult.elementAt(index);

                        var user = UserEntity(
                          username: 'kikiki',
                          bio: 'nobody scares me more than people',
                          photoUrl: 'https://media.4-paws.org/d/2/5/f/d25ff020556e4b5eae747c55576f3b50886c0b90/cut%20cat%20serhio%2002-1813x1811-720x719.jpg'
                        );

                        return UserCard(
                          userEntity: user,
                        );
                      },
                    )
                );
              },
            ),
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


