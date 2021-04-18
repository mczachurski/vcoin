//
//  FavouritesHandler.swift
//  vcoin
//
//  Created by Marcin Czachurski on 18.01.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import CoreData
import Foundation

class FavouritesHandler {
    func createFavouriteEntity() -> Favourite {
        let context = CoreDataHandler.shared.container.viewContext
        return Favourite(context: context)
    }

    func deleteFavouriteEntity(symbol: String) {
        let favourites = self.getFavourites()
        let filtered = favourites.filter { favourite -> Bool in
            return favourite.coinSymbol == symbol
        }

        let context = CoreDataHandler.shared.container.viewContext
        for favourite in filtered {
            context.delete(favourite)
        }
    }

    func isFavourite(symbol: String) -> Bool {
        let favourites = self.getFavourites()

        let exists = favourites.contains { favourite -> Bool in
            return favourite.coinSymbol == symbol
        }

        return exists
    }

    func getFavourites() -> [Favourite] {
        var favourites: [Favourite] = []

        let context = CoreDataHandler.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        do {
            if let list = try context.fetch(fetchRequest) as? [Favourite] {
                favourites = list
            }
        } catch {
            print("Error during fetching favourites")
        }

        return favourites
    }
}
