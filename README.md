## DarTrackList

#### DarTrackList - is sample media player application that can download mp3 files from given json file and store it in Core Data. Made for Dar ecosystems.

## installation
1. clone this repository.
```shell
$ git clone https://github.com/Dimillian/dartracklist
```
2. Change working directory and install pods
```shell
$cd dartracklist
$pod init
$pod install
```
3. open DarTrackList.xcworkspace
4. run

## features
* Parse tracks from ``` https://vibze.github.io/downloadr-task/tracks.json ```
* Download parsed tracks to Core Data
* Play downloaded tracks

## pods
1. SwiftyJSON ``` https://github.com/SwiftyJSON/SwiftyJSON ```
2. Alamofire ``` https://github.com/Alamofire/Alamofire ```

### general info
Writeen in Swift 4
iOS 11
Tested on iPhone 6 Plus
