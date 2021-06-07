
import 'package:flutter/material.dart';
import 'package:smart_study/Models/Post.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String testDevice = 'ca-app-pub-3940256099942544/5224354917';

class DetailPage extends StatefulWidget {
  final Post lesson;
  const DetailPage ({ Key key, this.lesson }): super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();


}


class _DetailPageState extends State<DetailPage> {


  static final AdRequest request = AdRequest(
    testDevices: <String>[testDevice],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );



  RewardedAd _rewardedAd;
  bool _rewardedReady = false;
  bool _payedForContent = false;


  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createRewardedAd();
  }

  Future<void> createRewardedAd() async {
     _rewardedAd ??=  RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: request,
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('Add loaded.');
            _rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) async{
            print('Failed to load');
            print(error);
            ad.dispose();
            _rewardedAd = null;
            await createRewardedAd();
          },
          onAdOpened: (Ad ad) => print('Ad opened onAdOpened.'),
          onAdClosed: (Ad ad) async{
            print('Ad closed.');
            ad.dispose();
            _rewardedAd = null;
            await createRewardedAd();
          },
          onApplicationExit: (Ad ad) async=>
              print(' onApplicationExit.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) async{
            //This where to do the Navigation
            print(
              '$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})',
            );
            setState(() {
              _payedForContent =true;
            });
            _rewardedAd = null;
            await createRewardedAd();
          }),
    )..load();
  }



  @override
  Widget build(BuildContext context) {




    final coursePrice = Container(
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        // "\$20",
        "Posted By: ${widget.lesson.author} " ,
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 100.0),
        Icon(
          Icons.analytics_outlined,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          widget.lesson.title,
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[


            Expanded(flex: 1, child: coursePrice)
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image:  NetworkImage('http://10.0.2.2:3000/image/${widget.lesson.image}'),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      widget.lesson.content,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(fontSize: 18.0),
    );
    final fullContentText = Text(
      widget.lesson.content,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async=> {

            _settingModalBottomSheet(context)
          },
          child:
          Text("SHOW MORE", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            _payedForContent? fullContentText: bottomContentText,
            _payedForContent? Container(): readButton],
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[topContent, bottomContent],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                Center(
                  child: new ListTile(
                      leading: new Icon(Icons.videocam),
                      title: new Text('WATCH AD TO UNLOCK'),
                      onTap: () async => {
                        await createRewardedAd(),
                        Navigator.of(context).pop(),
                        _rewardedAd.show().catchError((e) => print("error in showing ad: ${e.toString()}"))

                      }
                  ),
                ),

              ],
            ),
          );
        }
    );
  }

}

