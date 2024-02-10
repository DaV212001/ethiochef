import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/services/recipe_service.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/submitted_recipe.dart';
import '../../utils/screen_utils.dart';
class SubmittedCard extends StatelessWidget {
  MySubmittedRecipe recipe;
  String name;
  bool isApproved;
  SubmittedCard({super.key,
    required this.recipe,
    required this.name,
    required this.isApproved
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r)),
                  child: SizedBox(
                    height: isTablet ? 80.h : 100.h,
                    width: isTablet ? 85.w : 110.w,
                    child: Image.network(
                      recipe.image,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(width: 10,),
              Text(recipe.title,
                style: TextStyle(
                    fontSize: isTablet ? 11.sp : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondaryContainer),),
            ],
          ),
          Align(child: isApprovedChip(context, isApproved), alignment: Alignment.bottomLeft),
          MainButton(text: 'delete'.tr(), onPress: () async {
            RecipeService service = RecipeService();
            await service.deleteUserFoodRecipe(recipe.id);
          })
        ],
      ),
    );
  }
  Widget isApprovedChip(BuildContext context, bool isApproved){
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isApproved==true?theme.colorScheme.primary:theme.colorScheme.tertiaryContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child:isApproved==true? Text(
      'approved'.tr(),
            style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary)
        ):Text(
          'pending'.tr(),
            style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondaryContainer)
          )
      ),
    );
  }
}
