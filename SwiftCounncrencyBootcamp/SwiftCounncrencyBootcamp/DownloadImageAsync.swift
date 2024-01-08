//
//  DownloadImageAsync.swift
//  SwiftCounncrencyBootcamp
//
//  Created by Lama Albadri on 08/01/2024.
//

import SwiftUI
import Combine

class DownloadImageAsyncLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else
        {
            return nil
        }
        return image
    }
    
    // MARK: COMPLETION
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    // MARK: COMBINE
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
        // we need to map URLError to the normal error which is the Error it's self it's confirm to the same protocal
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    // MARK: AYNC AND AWAIT
    func downloadImageWithAsync() async throws -> UIImage? {
        // await -> we may wating for the response then continue
        do {
            let (data, response ) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data: data, response: response)
            return image
        } catch  {
            throw error
        }
    }
    
}
class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncLoader()
    var cancablle = Set<AnyCancellable>()
    
    func fetchImage() async {
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                if let image = image {
//                    self?.image = image
//                }
//            }
//        }
        
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] image in
//                    self?.image = image
//            }.store(in: &cancablle)
        
        // we call async func so each time we need to await
        let image = try? await loader.downloadImageWithAsync()
        await MainActor.run { // main actor is like the main thread
            self.image = image
        }
    }
}
struct DownloadImageAsync: View {
    
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            Task {
                // MUCH CLEARNER
                // MUCH SAFER WITH CALL
                // better we don't need to manage the weak self
                // maybe we make mistake and don't return a completion handler
                // will give us an error and tell us when we don't return anything from async
                await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
