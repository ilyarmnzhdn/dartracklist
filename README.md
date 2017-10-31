## DarTrackList

#### DarTrackList - is a simple music player that can download .mp3 files from given json and store them in Core Data. Made for Dar ecosystems.

## Installation
1. clone this repository.
```shell
$ git clone https://github.com/Dimillian/dartracklist
```
2. Change working directory and install pods
```shell
$ cd dartracklist
$ pod init
$ pod install
```
3. open DarTrackList.xcworkspace
4. run

## Requirements

- Xcode 9
- Know a little bit of how to program in Swift with the iOS SDK

## Features
* Parse tracks from ``` https://vibze.github.io/downloadr-task/tracks.json ```
* Download parsed tracks to Core Data
* Download n tracks per time
* Cancel downloading tracks
* Delete downloaded tracks from Core Data
* Play downloaded tracks

## pods
1. SwiftyJSON ``` https://github.com/SwiftyJSON/SwiftyJSON ```
2. Alamofire ``` https://github.com/Alamofire/Alamofire ```

## faq
* Q: In which language written this project?
* A: Swift 4
* Q: Which version of iOS?
* A: iOS 11
* Q: On which devices tested this project?
* A: Hardware (iPhone 6 Plus), simulator (all version of iPhone).
* Q: Does it support iPad?
* A: No.
