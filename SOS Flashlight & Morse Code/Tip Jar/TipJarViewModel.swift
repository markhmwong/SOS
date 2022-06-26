//
//  TipJarViewModel.swift
//  Pump It Up
//
//  Created by Mark Wong on 18/1/2022.
//

import UIKit
import StoreKit

class TipJarViewModel: NSObject {
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    struct CryptoTipItem: Hashable {
        let name: String
        let wallet: String
        let color: UIColor
    }
    
    struct FiatTipItem: Hashable {
        let name: String
        let price: String
        let color: UIColor
        let tipDescription: String
        let product: SKProduct?
    }
    
    enum TipJarItem: Hashable {

        case fiat(FiatTipItem)
//        case crypto(CryptoTipItem)
    }
    
    enum TipJarSection: Int {
        case fiat
//        case crypto
    }
    
    struct CryptoWallets {
        static let btc = "bc1qu2hd55vx84l7w927lgjwtqkhpwsyl3hnn6h2t7"
        static let ltc = "LZMiz5U5sVq9doMLYE3gfLJrxCQDKuyCmU"
        static let rvn = "RGHffRogeMkoX5BCQTqWxF12ZVqZuYiJEt"
        static let doge = "DRNVBU9bQA96Sw6U7PTqMaYDvMjyYS6mPW"
    }
        
    private var diffableDataSource: UICollectionViewDiffableDataSource<TipJarSection, TipJarItem>! = nil

    var tipProducts: [SKProduct]? {
        didSet {
            self.tipProducts?.sort(by: { (a, b) -> Bool in
                return Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: a.price)) < Unicode.CanonicalCombiningClass(rawValue: UInt8(truncating: b.price))
            })
        }
    }
    
    func configureDataSource(collectionView: UICollectionView) {
//        let cryptoRego = self.configureCryptoCellRegistration()
        let fiatRego = self.configureFiatCellRegistration()
        diffableDataSource = UICollectionViewDiffableDataSource<TipJarSection, TipJarItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in

            switch item {
                case .fiat(let item):
                    let cell = collectionView.dequeueConfiguredReusableCell(using: fiatRego, for: indexPath, item: item)
                    return cell
//                case .crypto(let item):
//                    let cell = collectionView.dequeueConfiguredReusableCell(using: cryptoRego, for: indexPath, item: item)
//                    return cell

            }
        }
        
        // section header
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <SectionTitleSupplementaryView>(elementKind: TipJarViewController.sectionElementKind) {
            (supplementaryView, string, indexPath) in
            
//            print(indexPath.section)
            let section = TipJarViewModel.TipJarSection.init(rawValue: indexPath.section)
            
            switch section {
//                case .crypto:
//                    supplementaryView.label.text = "Tip in Crypto"
                case .fiat:
                    supplementaryView.label.text = "Support my work by tipping below"
                case .none:
                    ()
            }
        }
        
        diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
        
        diffableDataSource.apply(configureSnapshot())
    }
    
    
    private func configureSnapshot() -> NSDiffableDataSourceSnapshot<TipJarSection, TipJarItem> {
        var snapshot = NSDiffableDataSourceSnapshot<TipJarSection, TipJarItem>()
        snapshot.appendSections([.fiat])
        snapshot.appendItems([TipJarItem.fiat(FiatTipItem(name: "loading tips...", price: "", color: Theme.Font.DefaultColor, tipDescription: "", product: nil))], toSection: .fiat)
//        for obj in self.data() {
//            snapshot.appendItems([obj], toSection: .crypto)
//        }
        return snapshot
    }
    
    func updateTipButtons(products: [SKProduct]) {
        self.tipProducts = products
        guard let tp = tipProducts else { return }
        var fiat: [TipJarItem] = []
        for p in tp {
            priceFormatter.locale = p.priceLocale
            let price = priceFormatter.string(from: p.price)
            fiat.append(TipJarItem.fiat(FiatTipItem(name: p.localizedTitle, price: price ?? "x.xx", color: Theme.Font.DefaultColor, tipDescription: p.localizedDescription, product: p)))
        }
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.fiat])
        snapshot.appendSections([.fiat])
//        snapshot.insertSections([.fiat], beforeSection: .crypto)
        snapshot.appendItems(fiat, toSection: .fiat)
        DispatchQueue.main.async {
            self.diffableDataSource.apply(snapshot)
        }
        
    }
    
    // temporarily disabled
//    func data() -> [TipJarItem] {
//        return [
//            TipJarItem.crypto(CryptoTipItem(name: "Bitcoin", wallet: CryptoWallets.btc, color: UIColor.systemOrange)),
//            TipJarItem.crypto(CryptoTipItem(name: "Litcoin", wallet: CryptoWallets.ltc, color: UIColor.systemGray2)),
//            TipJarItem.crypto(CryptoTipItem(name: "Dogecoin", wallet: CryptoWallets.doge, color: UIColor.systemYellow)),
//            TipJarItem.crypto(CryptoTipItem(name: "Ravencoin", wallet: CryptoWallets.rvn, color: UIColor.systemRed)),
//        ]
//    }
    
    private func configureCryptoCellRegistration() -> UICollectionView.CellRegistration<TipJarCryptoCell, CryptoTipItem> {
        let cellConfig = UICollectionView.CellRegistration<TipJarCryptoCell, CryptoTipItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }
    
    private func configureFiatCellRegistration() -> UICollectionView.CellRegistration<TipJarFiatCell, FiatTipItem> {
        let cellConfig = UICollectionView.CellRegistration<TipJarFiatCell, FiatTipItem> { (cell, indexPath, item) in
            cell.item = item
        }
        return cellConfig
    }    
    
}

