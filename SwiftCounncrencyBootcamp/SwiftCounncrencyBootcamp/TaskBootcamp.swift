//
//  TaskBootcamp.swift
//  SwiftCounncrencyBootcamp
//
//  Created by Lama Albadri on 08/01/2024.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
//        for x in array {
        // if we have a lng task and we want to cancel it 
//            try Task.checkCancellation()
//        }
        do {
            guard let url =  URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCESSFULLY")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url =  URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCESSFULLY")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
}


struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click ME!🤓") {
                    TaskBootcamp()
                }
            }
        }
    }
}
struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        // powerful modifer which is task modifer
        .task {
            // If we have a long task it may take long time to complete it maybe do some process before actually cancel
            // Add async task when view is appeear
            // SwiftUI auto cancel the task if the view is dissapear before the action complete
            await viewModel.fetchImage()
        }
//        .onDisappear(perform: {
//            fetchImageTask?.cancel()
//        })
//        .onAppear(perform: {
//            fetchImageTask = Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                // If you call async func inside the block the implemnation will happend in order
//                await viewModel.fetchImage()
//            }
            // it's as-sync code for the Task if you have seprate Task{} it will counnrency happend and call
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
            
            // Priorites first but not nesccary to finish first

//            Task(priority: .high) {
////               try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield() // wait till this task is complete
//                print("high: \(Thread.current): \(Task.currentPriority)")
//            }
//            
//
//            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current): \(Task.currentPriority)")
//            }
//            
//            Task(priority: .medium) {
//                print("medium: \(Thread.current): \(Task.currentPriority)")
//            }
//          
//            
//            Task(priority: .low) {
//                print("Low: \(Thread.current): \(Task.currentPriority)")
//            }
//            
//            
//            Task(priority: .utility) {
//                print("utility: \(Thread.current): \(Task.currentPriority)")
//            }
//            
//         
//            Task(priority: .background) {
//                print("background: \(Thread.current): \(Task.currentPriority)")
//            }
         
            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current): \(Task.currentPriority)")
//                // If we make a child task inside the parent task it will inherint the data from the Parent Task
//
//                // How About if we wanna to attach a Task inisde the parent but we didn't want it to inherint from the parent ? We can use detached Task
//                
//                Task.detached {// Don't use a detached task if it's possible (Not recommnded to use it)
//                    print("detached: \(Thread.current): \(Task.currentPriority)")
//                }
//                
//            }
            
            
//        })
    }
}

#Preview {
    TaskBootcampHomeView()
}
