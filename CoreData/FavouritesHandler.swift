//
//  https://mczachurski.dev
//  Copyright © 2021 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import CoreData
import Foundation

class FavouritesHandler {
    func createFavouriteEntity() -> Favourite {
        let context = CoreDataHandler.shared.container.viewContext
        return Favourite(context: context)
    }

    func deleteFavouriteEntity(coinId: String) {
        let favourites = self.getFavourites()
        let filtered = favourites.filter { favourite -> Bool in
            return favourite.coinId == coinId
        }

        let context = CoreDataHandler.shared.container.viewContext
        for favourite in filtered {
            context.delete(favourite)
        }
    }

    func isFavourite(coinId: String) -> Bool {
        let favourites = self.getFavourites()

        let exists = favourites.contains { favourite -> Bool in
            return favourite.coinId == coinId
        }

        return exists
    }

    func getFavourites() -> [Favourite] {
        var favourites: [Favourite] = []

        let context = CoreDataHandler.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [ sortDescriptor ]
        
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
