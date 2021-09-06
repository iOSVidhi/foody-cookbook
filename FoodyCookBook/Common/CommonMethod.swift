import UIKit
import Foundation

class CommonMethod {
    class func saveData(_ strFoodID : String){
        var arrayOfFavorite = self.getFavoriteFood()
        arrayOfFavorite.append(strFoodID)
        do {
            let data  = try NSKeyedArchiver.archivedData(withRootObject: arrayOfFavorite, requiringSecureCoding: true)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey:"FavoriteFood")
        }catch {
            
        }
    }

    class func getFavoriteFood() -> [String]{
        if let data = UserDefaults.standard.object(forKey: "FavoriteFood") as? Data
        {
            let arrayOfFavoriteFood = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String]
            return arrayOfFavoriteFood
        }
        return []
    }
    
    class func isFavoriteFood(_ mealObj : Meals) -> Bool {
        let arrayOfFavorite = self.getFavoriteFood()
        let filterOFFavorite = arrayOfFavorite.filter({$0 == mealObj.idMeal})
        return filterOFFavorite.count > 0 ? true : false
    }
}
