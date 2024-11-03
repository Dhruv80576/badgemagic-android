import 'package:badgemagic/constants.dart';
import 'package:badgemagic/main.dart';
import 'package:badgemagic/providers/app_localisation.dart';
import 'package:badgemagic/view/widgets/animation_container.dart';
import 'package:badgemagic/view/widgets/effects_container.dart';
import 'package:flutter/material.dart';

//effects tab to show effects that the user can select
class EffectTab extends StatefulWidget {
  const EffectTab({
    super.key,
  });

  @override
  State<EffectTab> createState() => _EffectsTabState();
}

class _EffectsTabState extends State<EffectTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EffectContainer(
          effect: effInvert,
          effectName: 'effect_invert'.tr(context),
          index: 0,
        ),
        EffectContainer(
          effect: effFlash,
          effectName: 'effect_effect'.tr(context),
          index: 1,
        ),
        EffectContainer(
          effect: effMarque,
          effectName: 'effect_marquee'.tr(context),
          index: 2,
        ),
      ],
    );
  }
}

//Animation tab to show animation choices for the user
class AnimationTab extends StatefulWidget {
  const AnimationTab({
    super.key,
  });

  @override
  State<AnimationTab> createState() => _AnimationTabState();
}

class _AnimationTabState extends State<AnimationTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AniContainer(
              animation: aniLeft,
              animationName: 'anim_left'.tr(context),
              index: 0,
            ),
            AniContainer(
              animation: aniRight,
              animationName: 'anim_right'.tr(context),
              index: 1,
            ),
            AniContainer(
              animation: aniUp,
              animationName: 'anim_up'.tr(context),
              index: 2,
            ),
          ],
        ),
        Row(
          children: [
            AniContainer(
              animation: aniDown,
              animationName: 'anim_down'.tr(context),
              index: 3,
            ),
            AniContainer(
              animation: aniFixed,
              animationName: 'anim_fixed'.tr(context),
              index: 4,
            ),
            AniContainer(
              animation: aniFixed,
              animationName: 'anim_snowflake'.tr(context),
              index: 5,
            ),
          ],
        ),
        Row(
          children: [
            AniContainer(
              animation: aniPicture,
              animationName: 'anim_picture'.tr(context),
              index: 6,
            ),
            AniContainer(
              animation: animation,
              animationName: 'anim_anim'.tr(context),
              index: 7,
            ),
            AniContainer(
              animation: aniLaser,
              animationName: 'anim_laser'.tr(context),
              index: 8,
            ),
          ],
        ),
      ],
    );
  }
}
