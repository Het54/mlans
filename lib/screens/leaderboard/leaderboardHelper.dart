import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

int userIndex = 0, userPoint = 0;

class leaderboardHelper with ChangeNotifier {
  Widget firebaseTopList(BuildContext context, userId) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy("point", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("assets/images/leadBg.jpg"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: leaderList(context, snapshot, userId)),
                ),
                Divider(
                  color: Colors.yellow,
                  height: 1,
                ),
                winnerNameTemplate()
              ],
            );
          }
        },
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.blueGrey),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width - 60,
          child: SizedBox(width: 10,height: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}


class winnerNameTemplate extends StatelessWidget {
  const winnerNameTemplate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: userIndex == 1
          ? Color(0xE6FFCC00)
          : userIndex == 2
              ? Color(0xE68FFFFF)
              : userIndex == 3
                  ? Color(0xE6F68FFD)
                  : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text("${userIndex}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
          Container(
            width: 250,
            child: Text("You",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ),
          Expanded(child: SizedBox()),
          userIndex > 10 ? Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text("${userPoint}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
          ) :
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                ),
                onPressed: () => showCustomDialog(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget leaderList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, userId) {
  int index = 0;
  return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    index++;
    if (data["userId"] == userId) {
      userIndex = index;
      userPoint = data["point"] * 10;
    }
    ;
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            color: //Color(0xEEF68FFD),
                index == 1
                    ? Color(0xB3FFCC00)
                    : index == 2
                        ? Color(0xB38FFFFF)
                        : index == 3
                            ? Color(0xB3F68FFD)
                            : Colors.black12,
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 15),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text("${index}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: index == 1
                              ? FontWeight.w600
                              : index == 2
                                  ? FontWeight.w400
                                  : index == 3
                                      ? FontWeight.w300
                                      : FontWeight.w200)),
                ),
              ),
            ),
            Container(
              width: 250,
              child: Text(data["userId"] == userId ? "You" : data["userId"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: index == 1
                          ? FontWeight.w600
                          : index == 2
                              ? FontWeight.w400
                              : index == 3
                                  ? FontWeight.w300
                                  : FontWeight.w200)),
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("${data["point"] * 10}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: index == 1
                              ? FontWeight.w600
                              : index == 2
                                  ? FontWeight.w400
                                  : index == 3
                                      ? FontWeight.w300
                                      : FontWeight.w200)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }).toList());
}
