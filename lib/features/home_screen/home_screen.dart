// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:numynd/assets_helper/app_colors.dart';
import 'package:numynd/assets_helper/app_fonts.dart';
import 'package:numynd/assets_helper/app_icons.dart';
import 'package:numynd/assets_helper/app_image.dart';
import 'package:numynd/common_widgets/custom_textfeild.dart';
import 'package:numynd/constants/app_constants.dart';
import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
import 'package:numynd/features/home_screen/model/get_today_model.dart';
import 'package:numynd/features/home_screen/widget/feeling_card.dart';
import 'package:numynd/features/notification/notification_service.dart';
import 'package:numynd/helpers/all_routes.dart';
import 'package:numynd/helpers/di.dart';
import 'package:numynd/helpers/navigation_service.dart';
import 'package:numynd/helpers/toast.dart';
import 'package:numynd/helpers/ui_helpers.dart';
import 'package:numynd/navigation_screen.dart';
import 'package:numynd/networks/api_acess.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _todayScrollController = ScrollController();

  // ✅ ONLY ADDED
  final TextEditingController _searchController = TextEditingController();
  List<Audio> _filteredAudios = [];

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;
  List<Audio> _allAudios = [];
  List<TodaysPick> _allTodayAudios = [];

  String limitWords(String text, int wordLimit) {
    final words = text.split(" ");
    if (words.length <= wordLimit) return text;
    return words.take(wordLimit).join(" ") + "...";
  }

  @override
  void initState() {
    super.initState();
    _fetchSongs(page: 1);
    _fetchTodaySongs(page: 1);
    _scrollController.addListener(_scrollListener);
    _todayScrollController.addListener(_todayScrollListener);
    NotificationService().initNotification();

    // ✅ ONLY ADDED
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();

      if (query.isEmpty) {
        setState(() {
          _filteredAudios.clear();
        });
        return;
      }

      final results = _allAudios.where((song) {
        final title = (song.title ?? '').toLowerCase();
        final desc = (song.description ?? '').toLowerCase();
        return title.contains(query) || desc.contains(query);
      }).toList();

      setState(() {
        _filteredAudios = results;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose(); // ✅ ONLY ADDED
    super.dispose();
  }

  Future<void> _fetchSongs({required int page}) async {
    try {
      setState(() {
        _isLoadingMore = true;
      });

      GetAllMusic? musicData = await getAllSongRXObj.getAllSongs(page: page);

      if (musicData != null && musicData.data?.audios != null) {
        final newAudios = musicData.data!.audios!;
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
    // ✅ ONLY ADDED
    if (_searchController.text.isNotEmpty) return;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _currentPage < _lastPage) {
      _fetchSongs(page: _currentPage + 1);
    }
  }

  Future<void> _fetchTodaySongs({required int page}) async {
    try {
      setState(() {
        _isLoadingMore = true;
      });

      GetTodaySongModel? musicData =
          await getTodaySongRXObj.getAllTodaySongs(page: page);

      if (musicData != null && musicData.data?.todaysPicks != null) {
        final newTodayAudios = musicData.data!.todaysPicks!;
        final pagination = musicData.data!.pagination;

        setState(() {
          if (page == 1) {
            _allTodayAudios = newTodayAudios;
          } else {
            _allTodayAudios.addAll(newTodayAudios);
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

  void _todayScrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _currentPage < _lastPage) {
      _fetchTodaySongs(page: _currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ONLY ADDED
    final displayList =
        _searchController.text.isNotEmpty ? _filteredAudios : _allAudios;

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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Let’s Shift ',
                                style:
                                    TextFontStyle.textStyle12w400Lato.copyWith(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Your Spiral',
                                style: TextFontStyle
                                    .textStyle12w400LatoThinItalic
                                    .copyWith(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'What’s on your mind right now?',
                            style: TextFontStyle.textStyle12w400Lato.copyWith(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          BottomNavController.index.value = 3;
                        },
                        child: ClipOval(
                          child: Image.asset(
                            AppImages.appLogo,
                            height: 50.h,
                            width: 50.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceMedium,
                  CustomTextField(
                    // ✅ ONLY CHANGED
                    controller: _searchController,
                    hintText: 'Search spirals…',
                    obscureText: false,
                    bRadius: 52,
                    prefixIcon: AppIcons.searchIcon,
                    borderColor: AppColor.cFFFFFF.withOpacity(0.3),
                    fieldColor: AppColor.c1B2630.withOpacity(0.3),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Today’s Pick',
                      style: TextFontStyle.textStyle12w400Lato.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(15.h),
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _allTodayAudios.length.clamp(0, 5),
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final song = _allTodayAudios[index];

                        return GestureDetector(
                          onTap: () {
                            final bool isLoggedIn =
                                appData.read(kKeyIsLoggedIn) ?? false;

                            if (isLoggedIn) {
                              NavigationService.navigateToWithArgs(
                                Routes.audioScreen,
                                {
                                  'id': song.id.toString(),
                                  'title': song.title,
                                  'description': song.description,
                                  'audioURL': song.fileUrl,
                                  'imageURL': song.thumbnailUrl,
                                },
                              );
                            } else {
                              ToastUtil.showShortToast(
                                  'Please log in to access this content.');
                              NavigationService.navigateToUntilReplacement(
                                Routes.loginScreen,
                              );
                            }
                          },
                          child: Container(
                            height: 197.h,
                            width: 180.w,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: song.thumbnailUrl ?? "",
                                  height: 197.h,
                                  width: 180.w,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey.shade300,
                                    child: Icon(Icons.music_note,
                                        color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.3),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song.title ?? "N/A",
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        limitWords(
                                            song.description ?? "N/A", 5),
                                        style: TextFontStyle.textStyle12w400Lato
                                            .copyWith(
                                          color: Colors.black.withOpacity(0.7),
                                          fontSize: 12.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 80.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.playIcon,
                                            height: 34.h,
                                            width: 34.w,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  UIHelper.verticalSpace(15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'For you',
                      style: TextFontStyle.textStyle12w400Lato.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                  UIHelper.verticalSpace(15.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    // ✅ ONLY CHANGED
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      // ✅ ONLY CHANGED
                      final song = displayList[index];

                      return GestureDetector(
                        onTap: () {
                          final bool isLoggedIn =
                              appData.read(kKeyIsLoggedIn) ?? false;

                          if (isLoggedIn) {
                            NavigationService.navigateToWithArgs(
                              Routes.audioScreen,
                              {
                                'id': song.id.toString(),
                                'title': song.title,
                                'description': song.description,
                                'audioURL': song.fileUrl,
                                'imageURL': song.thumbnailUrl,
                              },
                            );
                          } else {
                            ToastUtil.showShortToast(
                                'Please log in to access this content.');
                            NavigationService.navigateToUntilReplacement(
                              Routes.loginScreen,
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: FeelingCard(
                            title: song.title ?? "N/A",
                            subtitle: song.description ?? "N/A",
                            assetImage: song.thumbnailUrl ?? '',
                            onBellTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
                  if (_isLoadingMore)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.cEAF3FB,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
                  UIHelper.verticalSpace(50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// * ------------ Previous Main Code -------------
// // ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:numynd/assets_helper/app_colors.dart';
// import 'package:numynd/assets_helper/app_fonts.dart';
// import 'package:numynd/assets_helper/app_icons.dart';
// import 'package:numynd/assets_helper/app_image.dart';
// import 'package:numynd/common_widgets/custom_textfeild.dart';
// import 'package:numynd/constants/app_constants.dart';
// import 'package:numynd/features/home_screen/model/get_all_song_model.dart';
// import 'package:numynd/features/home_screen/model/get_today_model.dart';
// import 'package:numynd/features/home_screen/widget/feeling_card.dart';
// import 'package:numynd/features/notification/notification_service.dart';
// import 'package:numynd/helpers/all_routes.dart';
// import 'package:numynd/helpers/di.dart';
// import 'package:numynd/helpers/navigation_service.dart';
// import 'package:numynd/helpers/toast.dart';
// import 'package:numynd/helpers/ui_helpers.dart';
// import 'package:numynd/navigation_screen.dart';
// import 'package:numynd/networks/api_acess.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final ScrollController _todayScrollController = ScrollController();

//   int _currentPage = 1;
//   int _lastPage = 1;
//   bool _isLoadingMore = false;
//   List<Audio> _allAudios = [];
//   List<TodaysPick> _allTodayAudios = [];

//   // Helper to shorten text
//   String limitWords(String text, int wordLimit) {
//     final words = text.split(" ");
//     if (words.length <= wordLimit) return text;
//     return words.take(wordLimit).join(" ") + "...";
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchSongs(page: 1);
//     _fetchTodaySongs(page: 1);
//     _scrollController.addListener(_scrollListener);
//     _todayScrollController.addListener(_todayScrollListener);
//     NotificationService().initNotification();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchSongs({required int page}) async {
//     try {
//       setState(() {
//         _isLoadingMore = true;
//       });

//       // 🔹 API Call (you must support "page" parameter in getAllSongs)
//       GetAllMusic? musicData = await getAllSongRXObj.getAllSongs(page: page);

//       if (musicData != null && musicData.data?.audios != null) {
//         final newAudios = musicData.data!.audios!;
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

//   Future<void> _fetchTodaySongs({required int page}) async {
//     try {
//       setState(() {
//         _isLoadingMore = true;
//       });

//       // 🔹 API Call (you must support "page" parameter in getAllSongs)
//       GetTodaySongModel? musicData =
//           await getTodaySongRXObj.getAllTodaySongs(page: page);

//       if (musicData != null && musicData.data?.todaysPicks != null) {
//         final newTodayAudios = musicData.data!.todaysPicks!;
//         final pagination = musicData.data!.pagination;

//         setState(() {
//           if (page == 1) {
//             _allTodayAudios = newTodayAudios;
//           } else {
//             _allTodayAudios.addAll(newTodayAudios);
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

//   void _todayScrollListener() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore &&
//         _currentPage < _lastPage) {
//       _fetchTodaySongs(page: _currentPage + 1);
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
//           child: SingleChildScrollView(
//             controller: _scrollController,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 'Let’s Shift ',
//                                 style:
//                                     TextFontStyle.textStyle12w400Lato.copyWith(
//                                   color: Colors.white,
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 'Your Spiral',
//                                 style: TextFontStyle
//                                     .textStyle12w400LatoThinItalic
//                                     .copyWith(
//                                   color: Colors.white,
//                                   fontSize: 20.sp,
//                                   fontWeight: FontWeight.w800,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             'What’s on your mind right now?',
//                             style: TextFontStyle.textStyle12w400Lato.copyWith(
//                               color: Colors.white,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       GestureDetector(
//                         onTap: () {
//                           BottomNavController.index.value = 3;
//                         },
//                         child: ClipOval(
//                           child: Image.asset(
//                             AppImages.appLogo,
//                             height: 50.h,
//                             width: 50.w,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   UIHelper.verticalSpaceMedium,
//                   CustomTextField(
//                     controller: TextEditingController(),
//                     hintText: 'Search spirals…',
//                     obscureText: false,
//                     bRadius: 52,
//                     prefixIcon: AppIcons.searchIcon,
//                     borderColor: AppColor.cFFFFFF.withOpacity(0.3),
//                     fieldColor: AppColor.c1B2630.withOpacity(0.3),
//                   ),
//                   UIHelper.verticalSpaceMedium,
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Today’s Pick',
//                       style: TextFontStyle.textStyle12w400Lato.copyWith(
//                         color: Colors.white,
//                         fontSize: 18.sp,
//                       ),
//                     ),
//                   ),
//                   UIHelper.verticalSpace(15.h),

//                   // * 🔹 Today’s Pick Carousel
//                   SizedBox(
//                     height: 200.h,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _allTodayAudios.length.clamp(0, 5),
//                       separatorBuilder: (context, index) =>
//                           SizedBox(width: 12.w),
//                       itemBuilder: (context, index) {
//                         final song = _allTodayAudios[index];

//                         return GestureDetector(
//                           onTap: () {
//                             final bool isLoggedIn =
//                                 appData.read(kKeyIsLoggedIn) ?? false;

//                             if (isLoggedIn) {
//                               NavigationService.navigateToWithArgs(
//                                 Routes.audioScreen,
//                                 {
//                                   'id': song.id.toString(),
//                                   'title': song.title,
//                                   'description': song.description,
//                                   'audioURL': song.fileUrl,
//                                   'imageURL': song.thumbnailUrl,
//                                 },
//                               );
//                             } else {
//                               ToastUtil.showShortToast(
//                                   'Please log in to access this content.');
//                               NavigationService.navigateToUntilReplacement(
//                                 Routes.loginScreen,
//                               );
//                             }
//                           },
//                           child: Container(
//                             height: 197.h,
//                             width: 180.w,
//                             clipBehavior: Clip.hardEdge,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25.r),
//                             ),
//                             child: Stack(
//                               children: [
//                                 CachedNetworkImage(
//                                   imageUrl: song.thumbnailUrl ?? "",
//                                   height: 197.h,
//                                   width: 180.w,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) => Container(
//                                     color: Colors.grey.shade200,
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2),
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       Container(
//                                     color: Colors.grey.shade300,
//                                     child: Icon(Icons.music_note,
//                                         color: Colors.grey),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(12.w),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.transparent,
//                                         Colors.white.withOpacity(0.3),
//                                       ],
//                                     ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         song.title ?? "N/A",
//                                         style: TextFontStyle.textStyle12w400Lato
//                                             .copyWith(
//                                           color: Colors.black,
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       Text(
//                                         limitWords(
//                                             song.description ?? "N/A", 5),
//                                         style: TextFontStyle.textStyle12w400Lato
//                                             .copyWith(
//                                           color: Colors.black.withOpacity(0.7),
//                                           fontSize: 12.sp,
//                                         ),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(height: 80.h),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           SvgPicture.asset(
//                                             AppIcons.playIcon,
//                                             height: 34.h,
//                                             width: 34.w,
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 8.h),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   UIHelper.verticalSpace(15.h),

//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'For you',
//                       style: TextFontStyle.textStyle12w400Lato.copyWith(
//                         color: Colors.white,
//                         fontSize: 18.sp,
//                       ),
//                     ),
//                   ),
//                   UIHelper.verticalSpace(15.h),

//                   // * 🔹 Paginated List
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.zero,
//                     itemCount: _allAudios.length,
//                     itemBuilder: (context, index) {
//                       final song = _allAudios[index];
//                       return GestureDetector(
//                         onTap: () {
//                           final bool isLoggedIn =
//                               appData.read(kKeyIsLoggedIn) ?? false;

//                           if (isLoggedIn) {
//                             NavigationService.navigateToWithArgs(
//                               Routes.audioScreen,
//                               {
//                                 'id': song.id.toString(),
//                                 'title': song.title,
//                                 'description': song.description,
//                                 'audioURL': song.fileUrl,
//                                 'imageURL': song.thumbnailUrl,
//                               },
//                             );
//                           } else {
//                             ToastUtil.showShortToast(
//                                 'Please log in to access this content.');
//                             NavigationService.navigateToUntilReplacement(
//                               Routes.loginScreen,
//                             );
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(bottom: 16),
//                           child: FeelingCard(
//                             title: song.title ?? "N/A",
//                             subtitle: song.description ?? "N/A",
//                             assetImage: song.thumbnailUrl ?? '',
//                             onBellTap: () {},
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   // 🔹 Loader for pagination
//                   if (_isLoadingMore)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: AppColor.cEAF3FB,
//                           strokeWidth: 2.5,
//                         ),
//                       ),
//                     ),

//                   UIHelper.verticalSpace(50.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// File: lib/features/home_screen/view/home_screen.dart