import 'package:flutter/material.dart';
import 'package:libraryproject/services/utils/utilApis.dart';
import 'package:libraryproject/view/onBoard/widgets/pageOne.dart';
import 'package:libraryproject/view/onBoard/widgets/pageThree.dart';
import 'package:libraryproject/view/onBoard/widgets/pageTwo.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setAppView() async {
    await UtilsService.setUserView();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: [const PageOne(), const PageTwo(), const PageThree()],
          ),
          Positioned(
            bottom: 5,
            right: 5,
            left: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () => setState(() {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOut);
                        }),
                    child: Text('Previous',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700))),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      expansionFactor: 4.0,
                      dotHeight: 12,
                      dotWidth: 12,
                      dotColor: Colors.grey.shade400,
                      activeDotColor: Colors.blueAccent),
                ),
                TextButton(
                    onPressed: () {
                      if (currentPage < 2) {
                        setState(() {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.easeInOut);
                        });
                      } else if (currentPage == 2) {
                        setAppView();
                      }
                    },
                    child: Text('Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)))
              ],
            ),
          )
        ],
      ),
    );
  }
}
