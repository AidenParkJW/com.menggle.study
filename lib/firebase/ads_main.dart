import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsMain extends StatefulWidget {
  const AdsMain({super.key});

  @override
  State<AdsMain> createState() => _AdsMain();
}

class _AdsMain extends State<AdsMain> {
  String _gmaSdkVersion = "확인중...";
  bool _loadingBanner = false;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  final String _key = 'count';
  int _count = 0;

  @override
  void initState() {
    super.initState();

    // AdMob 초기화
    MobileAds.instance.initialize();

    // Google Mobile Ads SDK 버전확인
    _checkGmaSdkVersion();

    // 전면광고 생성
    _createInterstitialAd();

    _loadCount();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 배너광고 생성
    if (!_loadingBanner) {
      _loadingBanner = true;
      _createBannerAd();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Mobile Ads SDK Versiion: $_gmaSdkVersion'),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          if (_bannerAd != null)
            Container(
              color: Colors.green,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text('$_count', style: TextStyle(fontSize: 50)),
                const Text(
                  '전면광고는 5배수 마다 노출 됩니다.',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _count++;
                _setCount(_count);

                // 전면광고 노출
                _showInterstitialAd();
              });
            },
            child: Icon(Icons.add_circle),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _count--;
                _setCount(_count);

                // 전면광고 노출
                _showInterstitialAd();
              });
            },
            child: Icon(Icons.remove_circle),
          ),
        ],
      ),
    );
  }

  void _setCount(int value) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setInt(_key, value);
  }

  void _loadCount() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      _count = _pref.getInt(_key) ?? 0;
    });
  }

  // 광고 SDK버잔 조회
  Future<void> _checkGmaSdkVersion() async {
    final String version = await MobileAds.instance.getVersionString();
    setState(() {
      _gmaSdkVersion = version;
    });
  }

  // 배너광고 생성
  Future<void> _createBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
          Orientation.portrait,
          MediaQuery.of(context).size.width.truncate(),
        );

    _bannerAd = BannerAd(
      size: size ?? AdSize.fullBanner,
      // https://developers.google.com/admob/android/test-ads
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$BannerAd loaded.');
          // setState(() {
          //   _bannerAd = ad as BannerAd;
          // });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          debugPrint('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          debugPrint('$BannerAd onAdClosed.');
        },
      ),
    )..load();
  }

  // 전면광고 생성
  void _createInterstitialAd() {
    InterstitialAd.load(
      // https://developers.google.com/admob/android/test-ads
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('$ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _interstitialAd?.dispose();
        },
      ),
    );
  }

  // 전면광고 노출
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }

    // count가 5배수가 아니면 광고노출 안함
    if (_count % 5 != 0) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (Ad ad) {
        debugPrint('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (Ad ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        //ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        //ad.dispose();
        _createInterstitialAd();
      },
    );

    _interstitialAd!.show();
    //_interstitialAd!.dispose();
  }
}
