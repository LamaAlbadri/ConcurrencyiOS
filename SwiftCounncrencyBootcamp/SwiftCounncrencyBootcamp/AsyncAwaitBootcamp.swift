//
//  AsyncAwaitBootcamp.swift
//  SwiftCounncrencyBootcamp
//
//  Created by Lama Albadri on 08/01/2024.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.dataArray.append("Title1: \(Thread.current)")
        })
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2 , execute: {
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                let title3 = "Title3: \(Thread.current)"
                self.dataArray.append(title3)
            }
        })
    }
    
    func addAuthor1() async {
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
       try? await Task.sleep(nanoseconds: 2_000_000_000) // Sleep for 2 sec
        
//        try? await doSomething()
        let author2 = "Author2: \(Thread.current)"
        await MainActor.run { // switch to the main thread/ main actor before update your UI
            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        }
        
        await doSomething()
        
    }
    
    func doSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Sleep for 2 sec
        let something1 = "Something1: \(Thread.current)"
        
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "Something2: \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
                // run a tasks in Task doesn't mean that we wil change the Thread
                await viewModel.addAuthor1()
                // await we need first await then do the other thing
                
                await viewModel.doSomething()
                
                let finalText = "FINAL TEXT:  \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
