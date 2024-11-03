import 'dart:async';
import 'package:badgemagic/bademagic_module/utils/byte_array_utils.dart';
import 'package:badgemagic/bademagic_module/utils/converters.dart';
import 'package:badgemagic/bademagic_module/utils/global_context.dart';
import 'package:badgemagic/bademagic_module/utils/image_utils.dart';
import 'package:badgemagic/badge_effect/flash_effect.dart';
import 'package:badgemagic/badge_effect/invert_led_effect.dart';
import 'package:badgemagic/badge_effect/marquee_effect.dart';
import 'package:badgemagic/constants.dart';
import 'package:badgemagic/providers/animation_badge_provider.dart';
import 'package:badgemagic/providers/app_localisation.dart';
import 'package:badgemagic/providers/badge_message_provider.dart';
import 'package:badgemagic/providers/imageprovider.dart';
import 'package:badgemagic/providers/speed_dial_provider.dart';
import 'package:badgemagic/view/special_text_field.dart';
import 'package:badgemagic/view/widgets/common_scaffold_widget.dart';
import 'package:badgemagic/view/widgets/homescreentabs.dart';
import 'package:badgemagic/view/widgets/save_badge_dialog.dart';
import 'package:badgemagic/view/widgets/speedial.dart';
import 'package:badgemagic/view/widgets/vectorview.dart';
import 'package:badgemagic/virtualbadge/view/animated_badge.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  AnimationBadgeProvider animationProvider = AnimationBadgeProvider();
  late SpeedDialProvider speedDialProvider;
  BadgeMessageProvider badgeData = BadgeMessageProvider();
  ImageUtils imageUtils = ImageUtils();
  InlineImageProvider inlineImageProvider =
      GetIt.instance<InlineImageProvider>();
  bool isPrefixIconClicked = false;
  int textfieldLength = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalContextProvider.instance.setContext(context);
    });
    _setPortraitOrientation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inlineImageProvider.setContext(context);
    });
    _startImageCaching();
    speedDialProvider = SpeedDialProvider(animationProvider);
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  void _controllerListner() {
    animationProvider.badgeAnimation(
        inlineImageProvider.getController().text, Converters());
    inlineImageProvider.controllerListener();
  }

  @override
  void dispose() {
    _resetOrientation();
    animationProvider.stopAnimation();
    inlineImageProvider.getController().removeListener(_controllerListner);
    _tabController.dispose();
    super.dispose();
  }

  void _setPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _startImageCaching() async {
    if (!inlineImageProvider.isCacheInitialized) {
      await inlineImageProvider.generateImageCache();
      setState(() {
        inlineImageProvider.isCacheInitialized = true;
      });
    }
  }

  ScrollPhysics scrollphysics = ScrollPhysics();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    InlineImageProvider inlineImageProvider =
        Provider.of<InlineImageProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnimationBadgeProvider>(
          create: (context) => animationProvider,
        ),
        ChangeNotifierProvider<SpeedDialProvider>(
          create: (context) {
            inlineImageProvider.getController().addListener(_controllerListner);
            return speedDialProvider;
          },
        ),
      ],
      child: DefaultTabController(
          length: 3,
          child: CommonScaffold(
            title: "title".tr(context),
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: scrollphysics,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120.h,
                        ),
                        Container(
                          margin: EdgeInsets.all(15.w),
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            elevation: 4,
                            child: ExtendedTextField(
                              onChanged: (value) {},
                              controller: inlineImageProvider.getController(),
                              specialTextSpanBuilder:
                                  MySpecialTextSpanBuilder(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPrefixIconClicked =
                                          !isPrefixIconClicked;
                                    });
                                  },
                                  icon: const Icon(Icons.tag_faces_outlined),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: isPrefixIconClicked,
                            child: Container(
                                height: 150.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.grey.shade100,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 15.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 10.w),
                                child: VectorGridView())),
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.red,
                          controller: _tabController,
                          splashFactory: InkRipple.splashFactory,
                          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.grey[300];
                              }
                              return null;
                            },
                          ),
                          tabs: [
                            Tab(text: "speed".tr(context)),
                            Tab(text: 'animation'.tr(context)),
                            Tab(text: 'effects'.tr(context)),
                          ],
                        ),
                        SizedBox(
                          height: 180.h, // Adjust the height dynamically
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              RadialDial(),
                              AnimationTab(),
                              EffectTab(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      logger.i(
                                          'Save button clicked, showing dialog : ${animationProvider.isEffectActive(FlashEffect())}');
                                      showDialog(
                                          context: this.context,
                                          builder: (context) {
                                            return SaveBadgeDialog(
                                              speed: speedDialProvider,
                                              animationProvider:
                                                  animationProvider,
                                              textController:
                                                  inlineImageProvider
                                                      .getController(),
                                              isInverse: animationProvider
                                                  .isEffectActive(
                                                      InvertLEDEffect()),
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 33.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        color: Colors.grey.shade400,
                                      ),
                                      child: Text('save'.tr(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 100.w,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      badgeData.checkAndTransfer(
                                          inlineImageProvider
                                              .getController()
                                              .text,
                                          animationProvider
                                              .isEffectActive(FlashEffect()),
                                          animationProvider
                                              .isEffectActive(MarqueeEffect()),
                                          speedDialProvider.getOuterValue(),
                                          modeValueMap[animationProvider
                                              .getAnimationIndex()],
                                          null,
                                          false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        color: Colors.grey.shade400,
                                      ),
                                      child: Text('transfer'.tr(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  AnimationBadge(),
                ],
              ),
            ),
            scaffoldKey: const Key(homeScreenTitleKey),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
