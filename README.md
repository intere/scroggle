# Scroggle

This is the third rewrite of [Scroggle](https://itunes.apple.com/us/app/scroggle/id994899163?mt=8):

[![App Store](https://9zzt1vsuo7-flywheel.netdna-ssl.com/wp-content/uploads/2018/06/app-store-button.png)](https://itunes.apple.com/us/app/scroggle/id994899163?mt=8)

<img src="https://user-images.githubusercontent.com/2284832/48391952-44623500-e6c6-11e8-93dc-c69c52da507b.gif">

[![Build Status](https://travis-ci.org/intere/scroggle.svg?branch=develop)](https://travis-ci.org/intere/scroggle) [![Documentation](https://cdn.rawgit.com/intere/scroggle/master/docs/badge.svg)](https://intere.github.io/scroggle/docs/index.html)

## What is it?
Scroggle is a word game that's based on Boggle, Scrabble and some other popular word games.

## Why?
- I enjoy building games and this one is pretty straight forward.  
    - I've authored similar games to it in various platforms and in this case, it's for iOS.  
- It's an opportunity for me to play with SpriteKit, SceneKit and some other things I don't normally get to play with.
- I also like the idea of making games available for free, and without annoying Ads

## Tech Stack
- Apple's GameCenter (for scorekeeping)
- Fabric (for Crashlogs / Analytics)
- Cartography (for constraintsa)
- SceneKit (for 3D assets / animations)
- SpriteKit (for Gameplay)
- UIKit (for menus)

## TODO (MVP Features)
- [x] Setup Swiftlint / Address findings
- [x] Login: Game Center
- [x] Leaderboards
- [x] Help menu
    - [x] Add [Privacy Policy](http://intere.github.io/scroggle-support/#/privacy)
    - See related [Scroggle Support](https://github.com/intere/scroggle-support) project, which is the source for the [Scroggle Support Site](http://intere.github.io/scroggle-support/)
- [x] Game Introduction Animation
- [x] Board rotation
- [x] Sounds

## TODO (Roadmap)
- [ ] Challenge friends (Messages Integration)
- [ ] Single player challenges
- [ ] Realtime multiplayer

## License
- MIT

## Credits
- [Digital-7 Font](https://www.1001fonts.com/digital-7-font.html)
