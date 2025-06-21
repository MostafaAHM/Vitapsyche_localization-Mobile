import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'player_screen.dart';
import 'music_track.dart';

class Intertainment_Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    final List<MusicTrack> musicTracks = [
      MusicTrack(
        title: localizations.oceanWavesTitle,
        subtitle: localizations.oceanWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/ocean.jpg',
        audioPath: 'assets/entertainment/audio/rain.mp3',
      ),
      MusicTrack(
        title: localizations.birdsWavesTitle,
        subtitle: localizations.birdsWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/birds.jpeg',
        audioPath: 'assets/entertainment/audio/birds.mp3',
      ),
      MusicTrack(
        title: localizations.forestWavesTitle,
        subtitle: localizations.forestWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/Forest.jpeg',
        audioPath:
            'assets/entertainment/audio/forest-bird-harmonies-258412.mp3',
      ),
      MusicTrack(
        title: localizations.rainWavesTitle,
        subtitle: localizations.rainWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/rain.jpeg',
        audioPath: 'assets/entertainment/audio/rain.mp3',
      ),
      MusicTrack(
        title: localizations.thunderstormWavesTitle,
        subtitle: localizations.thunderstormWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/thunderstorm.jpeg',
        audioPath: 'assets/entertainment/audio/rain.mp3',
      ),
      MusicTrack(
        title: localizations.whiteNoiseWavesTitle,
        subtitle: localizations.whiteNoiseWavesSubtitle,
        icon: Icons.waves,
        image: 'assets/entertainment/images/white_noise.jpeg',
        audioPath: 'assets/entertainment/audio/white_noise.mp3',
      ),
    ];

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            localizations.therapeuticMusicTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textMainColor,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, whiteColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.star, color: textMainColor),
              onPressed: () {
                Navigator.pushNamed(context, '/daily_challenge');
              },
            ),
            IconButton(
              icon: Icon(Icons.mood, color: textMainColor),
              onPressed: () {
                Navigator.pushNamed(context, '/mood_tracker');
              },
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: textMainColor),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.mood, color: primaryColor),
                    title: Text(
                      localizations.moodTrackerTitle,
                      style: TextStyle(color: textMainColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/mood_tracker');
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.star, color: primaryColor),
                    title: Text(
                      localizations.dailyChallengeTitle,
                      style: TextStyle(color: textMainColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/daily_challenge');
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.videogame_asset, color: primaryColor),
                    title: Text(
                      localizations.gamesTitle,
                      style: TextStyle(color: textMainColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/games');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 16),
              itemCount: musicTracks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            musicTrack: musicTracks[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'music_image_${musicTracks[index].title}',
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  )
                                ],
                                image: DecorationImage(
                                  image: AssetImage(musicTracks[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  musicTracks[index].title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textMainColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  musicTracks[index].subtitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.play_arrow_rounded,
                            size: 30,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
