//
//  PlansViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/1/20.
//

import UIKit

class PlansViewController: UIViewController {
    
    private let itemHeight: CGFloat = 128
    private let padding: CGFloat = 20
    private let itemPdding: CGFloat = 6
    private let sectionPadding: CGFloat = 60
    private let divideLineColor: UIColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 0.1)

    @IBOutlet weak var plansTableView: UITableView!
    
    var plans: [Plan] = []
    var purchasedPlans: [Plan] = []
    
    var lineView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plansTableView.contentInset.top = padding
        plansTableView.contentInset.bottom = padding
        plansTableView.register(UINib(nibName: PlanViewCell.name, bundle: nil), forCellReuseIdentifier: PlanViewCell.identifier)
        
        getPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Statics.updatePlans {
            Statics.updatePlans = false
            getPlans()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        LoadingView.shared.frame = view.bounds
    }
}

// MARK: - TableView
extension PlansViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return plans.count + purchasedPlans.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanViewCell.identifier) as! PlanViewCell
        cell.isOdd = indexPath.section % 2 != 0
        if indexPath.section < purchasedPlans.count {
            cell.set(plan: purchasedPlans[indexPath.section], isActive: true)
        } else {
            cell.set(plan: plans[indexPath.section - purchasedPlans.count], isActive: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < purchasedPlans.count {
            let mealPlanVC = storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.mealPlanVC) as! MealPlanViewController
            mealPlanVC.plan = purchasedPlans[indexPath.section]
            navigationController?.pushViewController(mealPlanVC, animated: true)
        } else {
            let planVC = storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.planVC) as! PlanViewController
            planVC.plan = plans[indexPath.section - purchasedPlans.count]
            navigationController?.pushViewController(planVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !purchasedPlans.isEmpty && section == purchasedPlans.count {
            return sectionPadding
        } else if section == 0 {
            return 0
        }
        return itemPdding
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !purchasedPlans.isEmpty && section == purchasedPlans.count {
            let headerView = UIView()
            let height: CGFloat = 1
            lineView = UIView(frame: CGRect(x: padding, y: sectionPadding/2 - height/2, width: tableView.frame.width - padding*2, height: height))
            lineView?.backgroundColor = divideLineColor
            headerView.addSubview(lineView!)
            headerView.backgroundColor = .clear
            
            return headerView
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > CGFloat(purchasedPlans.count) * itemHeight + CGFloat(purchasedPlans.count - 1) * itemPdding {
            lineView?.isHidden = true
        } else {
            lineView?.isHidden = false
        }
    }
}

// MARK: Network
extension PlansViewController {
    func getPlans() {
        LoadingView.shared.showLoading(in: self.view, bottomPadding: 0, with: 0.0)
        NetworkManager.shared.getPlans { (plansResult) in
            switch plansResult {
            case .success(let result):
                if let plans = result.plans {
                    self.sort(plans: plans)
                }
            case .failure(let error):
                if error.value?.isTokenError ?? false {
                    self.openRootVCIfNeeded()
                } else {
                    DispatchQueue.main.async {
                        self.showErrorAlert(with: Constants.Strings.error, message: NetworkManager.handle(error: error))
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                LoadingView.shared.hideLoading()
            }
        }
    }
    
    func sort(plans: [Plan]) {
        self.plans = []
        self.purchasedPlans = []
        plans.forEach { (plan) in
            if plan.session != nil {
                purchasedPlans.append(plan)
            } else {
                self.plans.append(plan)
            }
        }
        
        DispatchQueue.main.async {
            self.plansTableView.reloadData()
        }
    }
}
