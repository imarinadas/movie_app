import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_flutter/screens/towatch_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app_flutter/main.dart';
import 'package:movies_app_flutter/screens/finder_screen.dart';
import 'package:movies_app_flutter/utils/constants.dart';
import 'package:movies_app_flutter/utils/file_manager.dart' as file;
import 'package:movies_app_flutter/utils/navi.dart' as navi;
import 'package:movies_app_flutter/utils/scroll_top_with_controller.dart'
    as scrollTop;
import 'package:movies_app_flutter/utils/toast_alert.dart' as alert;
import 'package:movies_app_flutter/widgets/bottom_navigation.dart';
import 'package:movies_app_flutter/widgets/bottom_navigation_item.dart';
import 'package:movies_app_flutter/widgets/custom_loading_spin_kit_ring.dart';
import 'package:movies_app_flutter/widgets/custom_main_appbar_content.dart';
import 'package:movies_app_flutter/widgets/movie_card.dart';
import 'package:movies_app_flutter/widgets/movie_card_container.dart';
import 'package:movies_app_flutter/widgets/shadowless_floating_button.dart';
import 'package:sizer/sizer.dart';
import 'package:movies_app_flutter/services/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late SharedPreferences logindata;
  late String username;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //for scroll upping
  ScrollController? _scrollController;
  bool showBackToTopButton = false;
  Color? themeColor;
  int? activeInnerPageIndex;
  List<MovieCard>? _movieCards;
  bool showSlider = true;
  String title = kHomeScreenTitleText;
  int bottomBarIndex = 1;

  @override
  void initState() {
    super.initState();
    initial();
    super.initState();
        () async {
      themeColor = await file.currentTheme();
      print(themeColor);
      _scrollController = ScrollController()
        ..addListener(() {
          setState(() {
            showBackToTopButton = (_scrollController!.offset >= 200);
          });
        });
      activeInnerPageIndex = 0;
      setState(() {
        loadData();
      });
    }();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  Future<void> loadData() async {
    MovieModel movieModel = MovieModel();
    _movieCards = (bottomBarIndex == 1)
        ? await movieModel.getMovies(
            moviesType: MoviePageType.values[activeInnerPageIndex!],
            themeColor: themeColor!)
        : await movieModel.getFavorites(
            themeColor: themeColor!, bottomBarIndex: bottomBarIndex);
    setState(() {
      scrollTop.scrollToTop(_scrollController!);
      showBackToTopButton = false;
    });
  }

  void pageSwitcher(int index) {
    setState(() {
      bottomBarIndex = (index == 2) ? 2 : 1;
      title = (index == 2) ? kFavoriteScreenTitleText : kHomeScreenTitleText;
      showSlider = !(index == 2);
      _movieCards = null;
      loadData();
    });
  }

  void movieCategorySwitcher(int index) {
    setState(() {
      activeInnerPageIndex = index;
      _movieCards = null;
      loadData();
    });
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (themeColor == null)
        ? CustomLoadingSpinKitRing(loadingColor: themeColor)
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kAppBarColor,
              shadowColor: Colors.transparent,
              bottom: PreferredSize(
                child: CustomMainAppBarContent(
                  showSlider: showSlider,
                  title: title,
                  activeButtonIndex: activeInnerPageIndex!,
                  activeColor: themeColor!,
                  buttonFistOnPressed: (index) => movieCategorySwitcher(index),
                  buttonSecondOnPressed: (index) =>
                      movieCategorySwitcher(index),
                  buttonThirdOnPressed: (index) => movieCategorySwitcher(index),
                  buttonFourthOnPressed: (index) => movieCategorySwitcher(index),
                  searchOnPressed: () => navi.newScreen(
                    context: context,
                    newScreen: () => FinderScreen(
                      themeColor: themeColor!,
                    ),
                  ),
                ),
                preferredSize:
                    Size.fromHeight((bottomBarIndex == 1) ? 16.0.h : 7.h),
              ),
            ),
            body: (_movieCards == null)
                ? CustomLoadingSpinKitRing(loadingColor: themeColor)
                : (_movieCards!.length == 0)
                    ? Center(child: Text(k404Text))
                    : MovieCardContainer(
                        scrollController: _scrollController!,
                        themeColor: themeColor!,
                        movieCards: _movieCards!,
                      ),
            bottomNavigationBar: BottomNavigation(
              activeColor: themeColor!,
              index: bottomBarIndex,
              children: [
                BottomNavigationItem(
                  icon: Icon(Icons.add_circle),
                  iconSize: 30.sp,
                  onPressed: () {
                    logindata.setBool('login', true);
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(builder: (context) => TowatchList())); },
                ),
                BottomNavigationItem(
                  icon: Icon(Icons.videocam),
                  iconSize: 25.sp,
                  onPressed: () {
                    pageSwitcher(1);
                  },
                ),
                BottomNavigationItem(
                    icon: Icon(Icons.bookmark_sharp),
                    iconSize: 20.sp,
                    onPressed: () {
                      pageSwitcher(2);
                    }),
                BottomNavigationItem(
                  icon: Icon(Icons.exit_to_app_rounded),
                  iconSize: 35.sp,
                  onPressed: () {
                    logindata.setBool('login', true);
                    Navigator.pushReplacement(context,
                        new MaterialPageRoute(builder: (context) => MyLoginPage())); },
                ),
              ],
            ),
            floatingActionButton: showBackToTopButton
                ? ShadowlessFloatingButton(
                    iconData: Icons.keyboard_arrow_up_outlined,
                    onPressed: () {
                      setState(() {
                        scrollTop.scrollToTop(_scrollController!);
                      });
                    },
                    backgroundColor: themeColor,
                  )
                : null,
          );
  }
}
