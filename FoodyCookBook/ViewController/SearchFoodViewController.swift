import UIKit

class SearchFoodViewController: UIViewController {

    @IBOutlet weak var collectionViewFood : UICollectionView!
    @IBOutlet weak var labelErrorMessage : UILabel!
    private let throttler           = Throttler(minimumDelay: 0.5)
    
    var mealsArray : [Meals] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.mealsArray.count > 0 {
                    self.labelErrorMessage.isHidden = true
                    self.collectionViewFood.isHidden = false
                }else {
                    self.labelErrorMessage.isHidden = false
                    self.collectionViewFood.isHidden = true
                }
                self.collectionViewFood.reloadData()
            }
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewFood.register(UINib.init(nibName: "FoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCollectionViewCell")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - API Call
    func callGetSearchFoodAPI(_ searchStr : String) {
        throttler.throttle {
            if let url = searchStr.count > 1 ? URL(string: "\(BASEURL)search.php?s=\(searchStr)") :  URL(string: "\(BASEURL)search.php?f=\(searchStr)") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let responseModel = try jsonDecoder.decode(Meal_Base.self, from: data)
                            if let meals = responseModel.meals {
                                self.mealsArray = meals
                            }else {
                                self.mealsArray.removeAll()
                            }
                        } catch {
                            
                        }
                    }
                }
                task.resume()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchFoodViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - UISearchBarDelegate
extension SearchFoodViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.callGetSearchFoodAPI(searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.callGetSearchFoodAPI(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.callGetSearchFoodAPI(searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.mealsArray.removeAll()
    }
}
