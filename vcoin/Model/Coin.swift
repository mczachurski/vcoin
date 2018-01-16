//
//  Coin.swift
//  vcoin
//
//  Created by Marcin Czachurski on 06.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Coin {
    
    public var Algorithm:String?
    public var CoinName:String?
    public var FullName:String?
    public var FullyPremined:String?
    public var Id:String?
    public var ImageUrl:String?
    public var Name:String?
    public var PreMinedValue:String?
    public var ProofType:String?
    public var SortOrder:String?
    public var Sponsored:Bool?
    public var Symbol:String
    public var TotalCoinSupply:String?
    public var TotalCoinsFreeFloat:String?
    public var Url:String?
    
    public var Price:Double?
    public var ChangePercentagePerDay:Double?
    
    init(data:[String:Any]) {
        FullName = data["FullName"] as? String
        Url = data["Url"] as? String
        ImageUrl = data["ImageUrl"] as? String
        Name = data["Name"] as? String
        SortOrder = data["SortOrder"] as? String
        Symbol = data["Symbol"] as! String
        CoinName = data["CoinName"] as? String
    }
}
