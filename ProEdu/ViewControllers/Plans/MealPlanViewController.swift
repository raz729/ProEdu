//
//  MealPlanViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/9/20.
//

import UIKit

class MealPlanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchButton: UIBarButtonItem!
    private var infoButton: UIBarButtonItem!
    
    private var isSearchSelected: Bool = false
    private var searchView: UIView = UIView()
    
    @IBOutlet weak var stageView: CustomView!
    @IBOutlet weak var recomendationsView: UIView!
    @IBOutlet weak var stageTitleLabel: UILabel!
    @IBOutlet weak var currentWeekLabel: UILabel!
    
    var plan: Plan?
    var session: Session?
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isFiltering: Bool = false
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
        
        getSession()
        getProducts()
        
        dispatchGroup.notify(queue: .main) {
            self.updateView()
            self.stageView.isHidden = false
            self.recomendationsView.isHidden = false
            LoadingView.shared.hideLoading()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        LoadingView.shared.frame = view.bounds
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: ProductCell.name, bundle: nil), forCellReuseIdentifier: ProductCell.identifier)
        tableView.contentInset.bottom = 30
    }
    
    private func updateView() {
        if let session = session {
            stageTitleLabel.text = session.currentStage?.stage?.title
            currentWeekLabel.text = "\(session.currentWeek?.progress?.current ?? 0)"
        }
        
        tableView.reloadData()
    }
    
    @objc
    func backAction() {
        if navigationItem.titleView != nil {
            UIView.animate(withDuration: 0.3) {
                self.searchView.frame.origin.x = self.searchView.frame.width
            } completion: { (_) in
                self.navigationItem.rightBarButtonItems = [self.infoButton, self.searchButton]
                self.navigationItem.titleView = nil
            }
            isFiltering = false
            tableView.reloadData()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func searchAction() {
        isSearchSelected = true
        
        showSeacrhBar()
        navigationItem.rightBarButtonItems = [infoButton]
    }
    
    @objc
    func infoAction() {
        let planVC = Constants.Storyboards.plans.instantiateViewController(withIdentifier: Constants.VCIdentifiers.planVC) as! PlanViewController
        planVC.plan = plan
        planVC.isSelectbale = false
        navigationController?.pushViewController(planVC, animated: true)
    }
    
    @IBAction func stageInfoAction() {
        //
    }
    
}

// MARK: - NavigationBar
extension MealPlanViewController {
    
    func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back_white"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        searchButton = UIBarButtonItem(image: UIImage(named: "ic_nav_search"), style: .plain, target: self, action: #selector(searchAction))
        infoButton = UIBarButtonItem(image: UIImage(named: "ic_nav_info"), style: .plain, target: self, action: #selector(infoAction))
        
        navigationItem.rightBarButtonItems = [infoButton, searchButton]
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func showSeacrhBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = Constants.Strings.searchProducts
        searchBar.tintColor = Constants.Colors.accentColor
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.gray
            }
            textfield.textColor = Constants.Colors.titleColor
            textfield.clearButtonMode = .never
            textfield.addTarget(self, action: #selector(searchChanged(_:)), for: .editingChanged)
        }
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.72, height: 34))
        searchView = UIView(frame: v.bounds)
        searchView.frame.origin.x = searchView.frame.width
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        searchBar.frame = CGRect(x: 0, y: 0, width: v.frame.width, height: v.frame.height)
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        searchBar.center.y = v.center.y
        searchView.addSubview(searchBar)
        v.addSubview(searchView)
        
        navigationItem.titleView = v
        
        UIView.animate(withDuration: 0.4) {
            self.searchView.frame.origin.x = 0
        } completion: { (_) in
            searchBar.becomeFirstResponder()
        }
    }
    
    @objc
    func searchChanged(_ sender: UITextField) {
        filteredProducts = []
        let searchText = sender.text ?? ""
        isFiltering = !searchText.isEmpty
        
        products.forEach { (product) in
            if let title = product.detail?.title, title.contains(searchText) {
                filteredProducts.append(product)
            }
        }
        
        tableView.reloadData()
    }
}

extension MealPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredProducts.count
        } else {
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        if isFiltering {
            cell.set(product: filteredProducts[indexPath.section])
        } else {
            cell.set(product: products[indexPath.section])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var title: String? = nil
        var description: String? = nil
        if isFiltering {
            title = filteredProducts[indexPath.section].detail?.title
            description = filteredProducts[indexPath.section].detail?.description
        } else {
            title = products[indexPath.section].detail?.title
            description = products[indexPath.section].detail?.description
        }
        
        let detailVC = ProductDetailViewController(name: title, description: description)
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
}

// MARK: - Network
extension MealPlanViewController {
    
    func getSession() {
        if let id = plan?.session?.id {
            LoadingView.shared.showLoading(in: self.view, bottomPadding: 0, with: 0.0)
            dispatchGroup.enter()
            NetworkManager.shared.getSession(with: id) { [weak self] (sessionResult) in
                switch sessionResult {
                case .success(let session):
                    self?.session = session
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.dispatchGroup.leave()
            }
        }
    }
    
    func getProducts() {
        if let id = plan?.session?.id {
            dispatchGroup.enter()
            NetworkManager.shared.getProducts(with: id) { [weak self] (productsResult) in
                switch productsResult {
                case .success(let result):
                    self?.products = result.products ?? []
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.dispatchGroup.leave()
            }
        }
    }
}
