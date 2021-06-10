//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski. All rights reserved.
//

import Foundation

public class Response<T: Decodable>: Decodable {
    public var data: T
}
