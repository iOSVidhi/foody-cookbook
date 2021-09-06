import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var collectionViewFood : UICollectionView!
    var mealsArray : [Meals] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewFood.register(UINib.init(nibName: "FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCollectionViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealsArray.removeAll()
        self.collectionViewFood.reloadData()
        let arrayOfFavorite = CommonMethod.getFavoriteFood()
        for favoriteID in arrayOfFavorite {
            self.callGetFoodDetailAPI(favoriteID)
        }
    }
    
    // MARK: - API Call
    func callGetFoodDetailAPI(_ favoriteID : String) {
        if let url = URL(string: "\(BASEURL)lookup.php?i=\(favoriteID)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(Meal_Base.self, from: data)
                        if let meals = responseModel.meals {
                            self.mealsArray.append(contentsOf: meals)
                        }
                        DispatchQueue.main.async {
                            self.collectionViewFood.reloadData()
                        }
                    }catch {
                        
                    }
                }
            }
            task.resume()
        }
    }
}
// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mealsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCollectionViewCell", for: indexPath) as! FoodCollectionViewCell
        cell.mealObj = self.mealsArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FoodListViewController") as? FoodListViewController {
            vc.screenFrom = .search
            vc.mealObj = self.mealsArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size
        return CGSize(width: (size.width-30)/2, height: 150)
    }
}
