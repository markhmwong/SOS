//
//  TipJarCoordinator.swift
//  Pump It Up
//
//  Created by Mark Wong on 16/1/2022.
//

import UIKit

class TipJarCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func start(_ cds: CoreDataStack?) {
        let vm = TipJarViewModel()
        let vc = TipJarViewController(viewModel: vm, coordinator: self)
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController.present(nav, animated: true, completion: nil)
    }
    
    func dismissCurrentView() {
        childCoordinators.removeAll()
        self.navigationController.dismiss(animated: true) { }
    }
}
