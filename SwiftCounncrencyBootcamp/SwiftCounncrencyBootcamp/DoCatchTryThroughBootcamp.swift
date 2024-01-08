//
//  DoCatchTryThroughBootcamp.swift
//  SwiftCounncrencyBootcamp
//
//  Created by Lama Albadri on 08/01/2024.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchThroughBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title:String?, error: Error?) {
        if isActive {
            return ("NEW TITLE", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    // JUST ADD A THROWS MEANS THIS FUNC WILL THROWS AN ERROR
    func getTitle3() throws -> String {
//        if isActive {
//            return "NEW Text"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL Text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}
class DoCatchThroughBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchThroughBootcampDataManager()
    
    func fetchTitles() {
//        let returnedValue = manager.getTitle()
//        if let returnedValue = returnedValue.title {
//            self.text = returnedValue
//        } else if let error = returnedValue.error {
//            self.text = error.localizedDescription
//        }
//        
//        let result = manager.getTitle2()
//        
//        switch result {
//        case .success(let newTitle):
//            self.text = newTitle
//        case .failure(let error):
//            self.text = error.localizedDescription
//        }
        
        // optional try will be nil if it's error
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
      
        // error is throws so we need do catch
        do {
            // we can add as more as try func here but if one of them is failed the catch will capture
            // make try? optional if it's failed you will set value to nil
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    
    }
}

struct DoCatchTryThroughBootcamp: View {
    
    @StateObject private var viewModel = DoCatchThroughBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitles()
            }
    }
}

#Preview {
    DoCatchTryThroughBootcamp()
}
