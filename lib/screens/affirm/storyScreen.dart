import 'package:Moneylans/services/Authentication.dart';
import 'package:Moneylans/services/FirebaseOperations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';


class storyScreeen extends StatefulWidget {
  var storyList;
  var postUserId;
  storyScreeen({Key? key,this.storyList,this.postUserId}) : super(key: key);

  @override
  State<storyScreeen> createState() => _storyScreeenState();
}

class _storyScreeenState extends State<storyScreeen> {

  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userID = Provider.of<Authentication>(context, listen: false).getUser()!.uid;
    List<StoryItem> storyItems = [
      for(int i=widget.storyList.length-1 ; i>=0 ; i--)
        StoryItem.text(
          title: widget.storyList[i]["title"],
          backgroundColor: Colors.blue,
        )
    ];
    return Scaffold(
      body: StoryView(
        inline: false,
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
        storyItems: storyItems,
        onStoryShow: (s) {
          int pos = storyItems.indexOf(s);
          List storyView = widget.storyList[widget.storyList.length-1 - pos]["views"];
          if(storyView.contains(userID) == false){
            widget.storyList[widget.storyList.length-1 - pos]["views"].add(userID);
            Provider.of<FirebaseOperations>(context, listen: false)
                .addAffirmView(
                widget.postUserId,
                {
                  "affirm" : widget.storyList
                }
            );
          }
        },
        onComplete: () {
          Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}