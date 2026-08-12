// // ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:numynd/assets_helper/app_colors.dart';
// import 'package:numynd/assets_helper/app_fonts.dart';
// import 'package:numynd/assets_helper/app_icons.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/common_widgets/custom_textfeild.dart';
// import 'package:numynd/features/favourite_screen/model/get_favourite_song_model.dart';
// import 'package:numynd/features/favourite_screen/widget/favourite_card.dart';
// import 'package:numynd/helpers/all_routes.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'package:numynd/helpers/toast.dart';
// import 'package:numynd/helpers/ui_helpers.dart';
// import 'package:numynd/networks/api_acess.dart';
// import 'package:numynd/networks/endpoints.dart';

// /// ✅ Route Observer (global level e thaka uchit)
// final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// class FavouriteScreen extends StatefulWidget {
//   const FavouriteScreen({super.key});

//   @override
//   State<FavouriteScreen> createState() => _FavouriteScreenState();
// }

// class _FavouriteScreenState extends State<FavouriteScreen> with RouteAware {
//   final _searchCtrl = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   int _currentPage = 1;
//   int _lastPage = 1;
//   bool _isLoadingMore = false;
//   List<Favorite> _allAudios = [];

//   String limitWords(String text, int wordLimit) {
//     final words = text.split(" ");
//     if (words.length <= wordLimit) return text;
//     return words.take(wordLimit).join(" ") + "...";
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSongs(page: 1);
//     _scrollController.addListener(_scrollListener);
//   }

//   /// 🔥 Navigation theke ei screen e asle automatically API call hobe
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
//   }

//   /// 🔥 Back / navigate kore ei screen e asle hit hobe
//   @override
//   void didPopNext() {
//     _currentPage = 1;
//     _lastPage = 1;
//     _allAudios.clear();
//     _fetchSongs(page: 1);
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     _scrollController.dispose();
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchSongs({required int page}) async {
//     try {
//       setState(() {
//         _isLoadingMore = true;
//       });

//       GetFavouriteSong? musicData =
//           await getFavouriteSongRXObj.getAllSongs(page: page);

//       if (musicData != null && musicData.data?.favorites != null) {
//         final newAudios = musicData.data!.favorites!;
//         final pagination = musicData.data!.pagination;

//         setState(() {
//           if (page == 1) {
//             _allAudios = newAudios;
//           } else {
//             _allAudios.addAll(newAudios);
//           }

//           _currentPage = pagination?.currentPage ?? 1;
//           _lastPage = pagination?.lastPage ?? 1;
//         });
//       }
//     } catch (e) {
//       debugPrint("Pagination fetch error: $e");
//     } finally {
//       setState(() {
//         _isLoadingMore = false;
//       });
//     }
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore &&
//         _currentPage < _lastPage) {
//       _fetchSongs(page: _currentPage + 1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(AppImages.homeBg),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Text(
//                   'Favorite',
//                   style: TextFontStyle.textStyle12w400Lato.copyWith(
//                     color: Colors.white,
//                     fontSize: 20.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 UIHelper.verticalSpaceMedium,
//                 CustomTextField(
//                   controller: _searchCtrl,
//                   hintText: 'Search your favorite…',
//                   obscureText: false,
//                   bRadius: 52,
//                   prefixIcon: AppIcons.searchIcon,
//                   borderColor: AppColor.cFFFFFF.withOpacity(0.3),
//                   fieldColor: AppColor.c1B2630.withOpacity(0.3),
//                   validator: (_) => null,
//                 ),
//                 UIHelper.verticalSpaceMedium,
//                 Expanded(
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     padding: EdgeInsets.zero,
//                     itemCount: _allAudios.length,
//                     itemBuilder: (context, index) {
//                       final song = _allAudios[index];
//                       return GestureDetector(
//                         onTap: () {
//                           NavigationService.navigateToWithArgs(
//                             Routes.audioScreen,
//                             {
//                               'id': song.id,
//                               'title': song.title,
//                               'description': song.description,
//                               'audioURL': song.fileUrl,
//                             },
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: FavouriteCard(
//                             title: song.title ?? 'Unknown Title',
//                             subtitle: song.description != null
//                                 ? limitWords(song.description!, 5)
//                                 : 'No Description',
//                             assetImage:
//                                 baseUrl + "/" + (song.thumbnailPath ?? ''),
//                             onBellTap: () async {
//                               bool result = await postFavouriteRXObj
//                                   .postFavouriteRX(id: song.id);
//                               if (result) {
//                                 setState(() {
//                                   _allAudios.removeAt(index);
//                                 });
//                                 ToastUtil.showShortToast(
//                                   'Removed from Favourite',
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 UIHelper.verticalSpace(50.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// File: lib/features/favourite_screen/view/favourite_screen.dart

// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/common_widgets/custom_textfeild.dart';
import 'package:numynd/features/favourite_screen/model/get_favourite_song_model.dart';
import 'package:numynd/features/favourite_screen/widget/favourite_card.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/networks/api_acess.dart';
import 'package:numynd/networks/endpoints.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with RouteAware {
  final _searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;

  List<Favorite> _allAudios = [];
  List<Favorite> _filteredAudios = [];

  bool _isSearching = false;

  String limitWords(String text, int wordLimit) {
    final words = text.split(" ");
    if (words.length <= wordLimit) return text;
    return words.take(wordLimit).join(" ") + "...";
  }

  @override
  void initState() {
    super.initState();
    _fetchSongs(page: 1);
    _scrollController.addListener(_scrollListener);

    /// 🔍 Search listener
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase().trim();

    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredAudios.clear();
      });
    } else {
      setState(() {
        _isSearching = true;
        _filteredAudios = _allAudios.where((song) {
          final title = (song.title ?? '').toLowerCase();
          final desc = (song.description ?? '').toLowerCase();
          return title.contains(query) || desc.contains(query);
        }).toList();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    _currentPage = 1;
    _lastPage = 1;
    _allAudios.clear();
    _fetchSongs(page: 1);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchSongs({required int page}) async {
    try {
      setState(() {
        _isLoadingMore = true;
      });

      GetFavouriteSong? musicData =
          await getFavouriteSongRXObj.getAllSongs(page: page);

      if (musicData != null && musicData.data?.favorites != null) {
        final newAudios = musicData.data!.favorites!;
        final pagination = musicData.data!.pagination;

        setState(() {
          if (page == 1) {
            _allAudios = newAudios;
          } else {
            _allAudios.addAll(newAudios);
          }

          _currentPage = pagination?.currentPage ?? 1;
          _lastPage = pagination?.lastPage ?? 1;
        });
      }
    } catch (e) {
      debugPrint("Pagination fetch error: $e");
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _currentPage < _lastPage &&
        !_isSearching) {
      _fetchSongs(page: _currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _isSearching ? _filteredAudios : _allAudios;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.homeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Favorite',
                  style: TextFontStyle.textStyle12w400Lato.copyWith(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                CustomTextField(
                  controller: _searchCtrl,
                  hintText: 'Search your favorite…',
                  obscureText: false,
                  bRadius: 52,
                  prefixIcon: AppIcons.searchIcon,
                  borderColor: AppColor.cFFFFFF.withOpacity(0.3),
                  fieldColor: AppColor.c1B2630.withOpacity(0.3),
                  validator: (_) => null,
                ),
                UIHelper.verticalSpaceMedium,
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final song = displayList[index];

                      return GestureDetector(
                        onTap: () {
                          NavigationService.navigateToWithArgs(
                            Routes.audioScreen,
                            {
                              'id': song.id,
                              'title': song.title,
                              'description': song.description,
                              'audioURL': song.fileUrl,
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FavouriteCard(
                            title: song.title ?? 'Unknown Title',
                            subtitle: song.description != null
                                ? limitWords(song.description!, 5)
                                : 'No Description',
                            assetImage:
                                baseUrl + "/" + (song.thumbnailPath ?? ''),
                            onBellTap: () async {
                              bool result = await postFavouriteRXObj
                                  .postFavouriteRX(id: song.id);
                              if (result) {
                                setState(() {
                                  _allAudios.remove(song);
                                  _filteredAudios.remove(song);
                                });
                                ToastUtil.showShortToast(
                                  'Removed from Favourite',
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                UIHelper.verticalSpace(50.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
