//
//  HomeViewController.swift
//  networkLayer
//
//  Created by Lama Albadri on 25/12/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var cartValueLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    let api: RepositoriesAPIProtocol = RepositoriesAPI()
    
    let products: [Product] = [
      Product(idntifer: "combinePlaylist", price: 30),
      Product(idntifer: "interviewPlaylist", price: 30)
    ]
    
    var cartValue: Int = 0 {
        didSet {
            cartValueLabel.text = "$\(cartValue)"
        }
    }
    
    var walletBalance: Int = 0 {
        didSet {
            walletAmountLabel.text = "$\(walletBalance)"
        }
    }
    
    
    let purchaseQueue = DispatchQueue(label: "com.develop.icode", attributes: .concurrent)
    
    let repoNames: [String] = ["hi", "hello", "bye"]
    
    override func viewDidLoad() {
        setUp()
    }
    
    func setUp() {
        greetingLabel.font = .systemFont(ofSize: 32)
    }
    
    @IBAction func didClickOnBuyCombo() {
        for product in products {
            purchaseQueue.async(flags: .barrier) {
                self.addItemsToCart(product: product)
            }
        }
    }
    
    func addItemsToCart(product: Product) {
        if self.walletBalance > product.price {
            self.api.getRepos(username: AuthonationProvider.shared.username) { [weak self] _ in
               let isPurchaseSucessful = false
                guard let self = self else {return}
                if isPurchaseSucessful  {
                    DispatchQueue.main.async {
                        self.walletBalance -= product.price
                        self.cartValue += product.price
                    }
                } else {
                    print("show payment option")
                }
            }
        }
    }
}

struct Product {
    let idntifer: String
    let price: Int
}
