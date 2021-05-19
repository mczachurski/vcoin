//
//  Activator.swift
//  VirtualCoin
//
//  Created by Marcin Czachurski on 18/05/2021.
//

import Foundation

public class Activator {
    public static func create<T>(_ type: T.Type) -> T where T:Initializable {
        return type.init()
    }
}
