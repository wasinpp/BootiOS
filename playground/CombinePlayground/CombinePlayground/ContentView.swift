//
//  ContentView.swift
//  CombinePlayground
//
//  Created by Wasin Passornpakorn on 7/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
import SwiftUI

class RegisterViewModel: ObservableObject {
    struct Alert: Identifiable {
        var title: String
        var id: String { self.title }
    }

    @Published var email = ""
    @Published var errorAlert: Alert?
    @Published var isRegisterd = false
    @Published var password = ""
    @Published var isRegisterRequestInFlight = false

    let register: (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>

    var cancellables: Set<AnyCancellable> = []

    init(
        register: @escaping (String, String) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    ) {
        self.register = register
    }

    func registerButtonTapped() {
        self.isRegisterRequestInFlight = true
        self.register(self.email, self.password)
            .receive(on: DispatchQueue.main)
            .map { data, _ in
                Bool(String(decoding: data, as: UTF8.self)) ?? false
            }
            .replaceError(with: false)
            .sink {
                self.isRegisterd = $0
                self.isRegisterRequestInFlight = false
                if !$0 {
                    self.errorAlert = Alert(title: "Failed to register. Please try again.")
                }
            }
            .store(in: &self.cancellables)
//            .eraseToAnyPublisher()
    }
}

func registerRequest(
    email: String,
    password: String
) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    var components = URLComponents(string: "https://www.pointfree.co/registersss")
    components?.queryItems = [
        URLQueryItem(name: "email", value: email),
        URLQueryItem(name: "password", value: password)
    ]

    return URLSession.shared
        .dataTaskPublisher(for: components!.url!)
        .eraseToAnyPublisher()
}

struct ContentView: View {
    @ObservedObject var viewModel: RegisterViewModel
    var body: some View {
        NavigationView {
            if self.viewModel.isRegisterd {
                Text("Welcome!")
            }
            else {
                Form {
                    Section(header: Text("Email")) {
                        TextField(
                            "blob@pointfree.co",
                            text: self.$viewModel.email
                        )
                    }

                    Section(header: Text("Password")) {
                        TextField(
                            "Password",
                            text: self.$viewModel.password
                        )
                    }
                    if self.viewModel.isRegisterRequestInFlight {
                        Text("Registering...")
                    }
                    else {
                        Button("Register") {
                            self.viewModel.registerButtonTapped()
                        }
                    }
                }
                .navigationBarTitle("Register")
                .alert(item: self.$viewModel.errorAlert) { errorAlert in
                    Alert(title: Text(errorAlert.title))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: RegisterViewModel(
                register: { _, _ in
                    Just((Data("true".utf8), URLResponse()))
                        .setFailureType(to: URLError.self)
                        .delay(for: 1, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
            })
        )
    }
}
