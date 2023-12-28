//
//  SplashViewController.swift
//  networkLayer
//
//  Created by Lama Albadri on 25/12/2023.
//

import UIKit


class SplashViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var launchDataDispatchGroup: DispatchGroup = DispatchGroup()
    let api: RepositoriesAPIProtocol = RepositoriesAPI()
    
    
    override func viewDidLoad() {
        
        DispatchQueue.global().async { [weak self] in
            self?.getAppLaunchData()
        }
    }
    
    func getAppLaunchData() {
           // 1st enter
           launchDataDispatchGroup.enter()
           // API call 1
        api.getRepos(username: AuthonationProvider.shared.username) { [weak self] completion in
            print("Received first response")
            self?.launchDataDispatchGroup.leave()// 1st leave
            switch completion {
            case .success(let sucess):
                print(sucess)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
           
           // 2nd enter
           launchDataDispatchGroup.enter()
           // API call 2
        api.getRepos(username: AuthonationProvider.shared.username) { [weak self] completion in
            print("Received first response")
            self?.launchDataDispatchGroup.leave()// 2st leave
            switch completion {
            case .success(let sucess):
                print(sucess)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
  // wait till it's excute
//    launchDataDispatchGroup.wait()
//        DispatchQueue.main.async { [weak self] in
//            self?.activityIndicator.stopAnimating()
//            self?.navigateToSignupVC()
//        }
        
        // the wait for the result it's with some time of seconds
        let waitResult: DispatchTimeoutResult = launchDataDispatchGroup.wait(timeout: .now() + .seconds(2))
        DispatchQueue.main.async { [weak self] in
            switch waitResult {
            case .success:
                print("API calls completed before timeout")
            case .timedOut:
                print("APIs timed out")
            }
            self?.activityIndicator.stopAnimating()
            self?.navigateToSignupVC()
        }
           // System Notifies after all leave() are executed
        // when both calls are completed
//           launchDataDispatchGroup.notify(queue: .main) { [weak self] in
//               print("Launch calls complete, navigate to next screen")
//               self?.activityIndicator.stopAnimating()
//               self?.navigateToSignupVC()
//           }
        
        
       }
    
    
       
    func navigateToSignupVC() {
           guard let signupVC: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
           UIApplication.shared.windows.first?.rootViewController = signupVC
           UIApplication.shared.windows.first?.makeKeyAndVisible()
           
       }
    
}
