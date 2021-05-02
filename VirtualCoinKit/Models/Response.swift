//
//  Response.swift
//  VirtualCoinKit
//
//  Created by Marcin Czachurski on 02/05/2021.
//

import Foundation

public class Response<T: Decodable>: Decodable {
    public var data: [T] = []
}
