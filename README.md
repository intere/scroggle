# Scroggle

This is the third rewrite of [Scroggle](https://itunes.apple.com/us/app/scroggle/id994899163?mt=8):

<img src="https://is4-ssl.mzstatic.com/image/thumb/Purple62/v4/d2/73/73/d27373cd-0df0-f515-8fb8-c2d811ceec54/pr_source.png/434x0w.jpg">

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
- SceneKit (for 3D assets / animations)
- SpriteKit (for Gameplay)
- UIKit (for menus)

## TODO (MVP Features)
- [ ] Login: Game Center
- [ ] Leaderboards
- [ ] Help menu
- [ ] Introduction animation

## TODO (Roadmap)
- [ ] Realtime multiplayer
- [ ] Single player challenges
- [ ] Challenge friends (Messages Integration)


## TODO (feature/NewScenes)
- [ ] Board rotation
- [ ] Sounds
- [x] Nuke the GameTimer object and just have the Game UI manage it
    - [ ] Hook up some sort of noise cue to tell the user that time is running out
- [x] Hook up the score
    - [x] Update scoring
- [x] Hook up the Word List
- [x] Implement a "Game Over" mechanism
- [x] Hook up game loop
- [x] Fix memory leaks
- [x] Implement "Play Again"
- [x] Implement "Replay"