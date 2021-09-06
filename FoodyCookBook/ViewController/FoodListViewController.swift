import UIKit
import Foundation
import Kingfisher
import SVProgressHUD

enum ScreenFrom {
    case tabBar
    case search
    case favorite
}

class FoodListViewController: UIViewController {

    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var labelFoodDetail: UILabel!
    @IBOutlet weak var buttonFavorite : UIButton!
    
    var screenFrom : ScreenFrom = .tabBar
    var mealObj : Meals?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if screenFrom == .tabBar {
            self.callGetRandomFoodAPI()
        }
        if mealObj != nil {
            self.setPropery()
        }
        // Do any additional setup after loading the view.
    }

    // MARK: -  UIButton tap
    @IBAction func didTapOnFavoriteButton() {
        self.buttonFavorite.isSelected = !self.buttonFavorite.isSelected
        CommonMethod.saveData(mealObj?.idMeal ?? "")
    }
    
    // MARK: - API Call
    func callGetRandomFoodAPI() {
        SVProgressHUD.show()
        if let url = URL(string: "\(BASEURL)random.php") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                SVProgressHUD.dismiss()
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(Meal_Base.self, from: data)
                        if let meals = responseModel.meals?.first {
                            self.mealObj = meals
                        }
                        self.setPropery()
                    }catch {
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - setDetail
    func setPropery() {
        DispatchQueue.main.async {
            if let mealObj = self.mealObj {
                self.title = mealObj.strMeal
                if let url = URL(string: mealObj.strMealThumb ?? "") {
                    self.imageViewFood.kf.setImage(with: url)
                }
                var strIngredient : String = ""
                if let strIngredient1 = mealObj.strIngredient1, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure1, strMeasure1.count > 0  {
                    strIngredient += "\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient2, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure2, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient3, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure3, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient4, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure4, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient5, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure5, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient6, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure6, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient7, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure7, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient8, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure8, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient9, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure9, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient10, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure10, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient11, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure11, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                if let strIngredient1 = mealObj.strIngredient12, strIngredient1.count > 0, let strMeasure1 = mealObj.strMeasure12, strMeasure1.count > 0 {
                    strIngredient += "\n\(strIngredient1) : \(strMeasure1)"
                }
                self.labelFoodDetail.text = "Category : \(mealObj.strCategory ?? "")\n\nArea : \(mealObj.strArea ?? "")\n\nInterdient :\n\(strIngredient)\n\nInstructions :\n\(mealObj.strInstructions ?? "")"
                
                self.buttonFavorite.isSelected = CommonMethod.isFavoriteFood(mealObj)
            }
        }
    }
}
