//
//  CoinViewController.swift
//  vcoin
//
//  Created by Marcin Czachurski on 07.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {

    public var coin:Coin?
    
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinShort: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        self.coinName.text = self.coin?.CoinName
        self.coinShort.text = self.coin?.Symbol
        self.coinPrice.text = self.getFormattedPrice()
        
        //self.loadCoinPrice()
    }
    
    private func getFormattedPrice() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en-US")
        let priceString = currencyFormatter.string(from: NSNumber(value: self.coin?.Price ?? 0.0 ))
        return priceString!
    }
    
    private func loadCoinPrice() {
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(self.coin!.Symbol!)&tsyms=USD,EUR")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                    
                    if let usdPrice = json["USD"] as? Float {
                        
                        self.coin?.Price = usdPrice
                        
                        let currencyFormatter = NumberFormatter()
                        currencyFormatter.usesGroupingSeparator = true
                        currencyFormatter.numberStyle = NumberFormatter.Style.currency
                        // localize to your grouping and decimal separator
                        currencyFormatter.locale = Locale(identifier: "en-US")
                        let priceString = currencyFormatter.string(from: NSNumber(value: usdPrice))
                        
                        DispatchQueue.main.async {
                            self.coinPrice.text = priceString
                        }
                    }

                }
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
