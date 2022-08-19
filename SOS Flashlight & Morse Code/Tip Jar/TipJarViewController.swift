//
//  TipJarViewController.swift
//  Pump It Up
//
//  Created by Mark Wong on 16/1/2022.
//

import UIKit
import StoreKit
import TelemetryClient

class TipJarViewController: UICollectionViewController {
    
    private var viewModel: TipJarViewModel
    
    private var coordinator: TipJarCoordinator
    
    static let sectionElementKind = "tip-jar-section"
    
    init(viewModel: TipJarViewModel, coordinator: TipJarCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(header: true, elementKind: TipJarViewController.sectionElementKind, itemSpace: NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10), groupSpacing: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), cellHeight: .estimated(40), sectionSpacing: NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TelemetryManager.send(TelemetryManager.Signal.tipDidShow.rawValue)

        view.backgroundColor = Theme.mainBackground
        collectionView.backgroundColor = view.backgroundColor
        
        self.navigationItem.title = "Tip Jar"
        let right = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismiss))
        self.navigationItem.rightBarButtonItem = right
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor]
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleFailedTransaction), name: .IAPHelperPurchaseCancelledNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessfulTransaction), name: .IAPHelperPurchaseCompleteNotification, object: nil)
        self.grabTipsProducts()
        viewModel.configureDataSource(collectionView: collectionView)
    }
    
    func grabTipsProducts() {
        
        IAPProducts.tipStore.requestProducts { [weak self](success, products) in
            
            guard let self = self else { return }
            
            if (success) {
                guard let products = products else { return }
                //update buttons
                self.viewModel.updateTipButtons(products: products)
            } else {
                // requires internet access
            }
        }
    }
    
    // unsuccessful purchase
//    @objc func handleFailedTransaction() {
//        if let indexPath = tableView.indexPathsForSelectedItems?[0] {
//            let cell = tableView.cellForItem(at: indexPath) as! TipCell
//            cell.stopLoading()
//        }
//    }
//
//    // successful purchase
//    @objc func handleSuccessfulTransaction(notification: NSNotification) {
//        let productId = notification.userInfo as? [TipSections : String]
//        let vc = ThankYouViewController(parentCoordinator: nil, product: productId?.first?.value)
//        present(vc, animated: true) { }
//    }
    
    @objc func handleDismiss() {
        self.coordinator.dismissCurrentView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = TipJarViewModel.TipJarSection.init(rawValue: indexPath.section)
        
        switch section {
//        case .crypto:
//            // copy
//            print("copy location")
//            let cell = collectionView.cellForItem(at: indexPath) as! TipJarCryptoCell
//            
//            
//            let generator = UINotificationFeedbackGenerator()
//
//            let pasteboard = UIPasteboard.general
//            pasteboard.string = cell.item?.wallet
//            generator.notificationOccurred(.success)
//
//            // copied view
//            self.navigationItem.title = "Copied Address!"
//            perform(#selector(changeTitle), with: nil, afterDelay: 5.2)
        case .fiat:
            let cell = collectionView.cellForItem(at: indexPath) as! TipJarFiatCell
            guard let p = cell.item?.product else { return }
            IAPProducts.tipStore.buyProduct(p)
            self.navigationItem.title = "Tipping.."
            perform(#selector(changeTitle), with: nil, afterDelay: 5.2)
        case .none:
            () // do nothing
        }
    }
    
    @objc func changeTitle() {
        self.navigationItem.title = "Tip Jar"
    }
}

