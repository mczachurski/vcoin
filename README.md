# vCoin (Virtual Coin)

**vCoin** is lightweight application for keeping track of cryptocurrency prices.

Main features:
- more then 1000 cryptocurrencies
- 5 dynamic charts (hour, day, week, month, year)
- prices displayed in more then 100 currencies (USD, EUR, GBP, CHF, etc.)
- minimal design
- dark/white themes
- widget presenting current prices (taking into account user favorite currencies)

<img src="https://raw.githubusercontent.com/mczachurski/vcoin/master/Resources/screen-dark-01.png" width="200" > <img src="https://raw.githubusercontent.com/mczachurski/vcoin/master/Resources/screen-dark-02.png" width="200" > <img src="https://raw.githubusercontent.com/mczachurski/vcoin/master/Resources/screen-white-01.png" width="200" > <img src="https://raw.githubusercontent.com/mczachurski/vcoin/master/Resources/screen-white-02.png" width="200" >

You can downlad app from <a href="https://apps.apple.com/us/app/vcoin/id1471998515">AppStore</a>.

**vCoin** uses [https://coincap.io](https://coincap.io) API. All endpoints are described here: [https://docs.coincap.io/](https://docs.coincap.io/).

## Screenshots for App Store

After running simulator run one of the following command to change status bar icons.
 
**iPhone 6.5" Display**

```bash
xcrun simctl status_bar "iPhone 11 Pro Max" override --time 9:41 --dataNetwork wifi --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
```

**iPhone 5.5" Display**

```bash
xcrun simctl status_bar "iPhone 8 Plus" override --time 9:41 --dataNetwork wifi --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
```

**iPad Pro (3rd Gen) 12.9" Display**

```bash
xcrun simctl status_bar "iPad Pro (12.9-inch) (5th generation)" override --time 9:41 --dataNetwork wifi --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --batteryState charged --batteryLevel 100
```

## Contributing
You can fork and clone repository. Execute 'carthage update' and build. Do your changes and pull a request. Enjoy!
