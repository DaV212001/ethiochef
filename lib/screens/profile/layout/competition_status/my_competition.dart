import 'dart:async';

import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/models/recipe.dart';
import 'package:ethio_chef/screens/profile/layout/recipe_status/recipe_description.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../widgets/profile/my_competition_card.dart';
import '../../../upload_recipe/upload_recipe_screen.dart';
import 'my_comp_description.dart';


class MyCompetition extends StatefulWidget {
  const MyCompetition({super.key});

  @override
  State<MyCompetition> createState() => _MyCompetitionState();
}

class _MyCompetitionState extends State<MyCompetition> {
  bool isLoading = true;

  late Timer timer;
  void getRecipes() async {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!mounted) {
        timer.cancel();
        // Stop the timer if the widget is not mounted
        return;
      }
      Competition.savedCompetitions =
      await Competition.loadCompetitionsFromSharedPrefs();
      setState(() {
        isLoading = false;
      });
      if(Competition.savedCompetitions.length == 0){
        setState(() {
          isLoading = true;
        });
      }
    });

  }
  @override
  void initState() {
    getRecipes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Competition(s)",style: TextStyle(
            color: theme.colorScheme.primary
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
            )),
      ),
      body: Competition.savedCompetitions.length==0?Center(
        child: Column(
          children: [
            Text("Add competition")
          ],
        ),
      ):isLoading ==true?
      Center(
        child: CircularProgressIndicator(),
      )
          :
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: Competition.savedCompetitions.length,
        itemBuilder: (BuildContext context, int index) {
          var comp = Competition.savedCompetitions[index];
          return GestureDetector(
            onTap: (){
              print("tap");
              pushNewScreen(
                context,
                screen: CompetitionDescription(comp: comp),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: MyCompCard(
              comp: comp,
            ),
          );
        },),
        floatingActionButton: FloatingActionButton(
          backgroundColor:  theme.colorScheme.primary,
          onPressed: () {
            pushNewScreen(context,
                screen: UploadRecipeScreen(type: "competition"), withNavBar: false);
          },
          child: Icon(
              Icons.add,
              color:Colors.white
          ),
        )
    );
  }
}
/*
* Column(
          children: [
            GestureDetector(

            ),
            Text(resp.name.toString()),
            Text(resp.description.toString()),
            Text(resp.prepTime.toString()),
            Text(resp.servingSize.toString()),
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: resp.steps?.length,
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Text(resp.steps![index].toString()),
                    ],
                  );
                }
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
              shrinkWrap: true,
                itemCount: resp.ingredient?.length,
                itemBuilder: (context, index){
                var ing = resp.ingredient![index];
                return Column(
                  children: [
                    Text(ing['ingredient'].toString()),
                    Text(ing['quantity'].toString()),
                  ],
                );
                }
            ),

            Text("==============================="),
            SizedBox(height: 50,)
          ],
        )
* */