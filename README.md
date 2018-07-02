# Scroggle

This is the third rewrite of [Scroggle](https://itunes.apple.com/us/app/scroggle/id994899163?mt=8):
<img src="https://is4-ssl.mzstatic.com/image/thumb/Purple62/v4/d2/73/73/d27373cd-0df0-f515-8fb8-c2d811ceec54/pr_source.png/434x0w.jpg">

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

## TODO (General Features)
- [ ] Login: Game Center
- [ ] Leaderboards
- [ ] Challenge Friends (Messages)
- [ ] Help Menu
- [ ] Board Rotation

## TODO (feature/NewScenes)
- [ ] Nuke the GameTimer object and just have the Game UI manage it
    - For the moment, I've added deprecation warnings
    - [ ] Hook up some sort of noise cue to tell the user that time is running out
- [x] Hook up the score
        - [x] Update scoring
- [x] Hook up the Word List
- [x] Implement a "Game Over" mechanism
- [x] Hook up game loop
- [x] Fix memory leaks
- [ ] Implement "Play Again"
- [ ] Implement "Replay"
