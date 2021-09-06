import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var labelFoodDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var mealObj : Meals! {
        didSet {
            if let url = URL(string: mealObj.strMealThumb ?? "") {
                imageViewFood.kf.setImage(with: url)
            }
            labelFoodDetail.text = mealObj.strMeal
        }
    }
}
