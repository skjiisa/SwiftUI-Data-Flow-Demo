//
//  Demo 3.swift
//  SwiftUI Data Flow
//
//  Created by Elaine Léon on 6/12/23.
//

import SwiftUI
import Combine

// MARK: - Demo 2

struct Demo_3: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Text("Top section")
                Text("Child content is\(self.viewModel.childViewModel.loaded ? "" : " not") loaded")
                
                ChildView(viewModel: self.viewModel.childViewModel)
            }
            .navigationTitle("Demo 3")
            .task {
                try? await self.viewModel.childViewModel.loadData()
            }
            .refreshable {
                try? await self.viewModel.childViewModel.loadData()
            }
        }
    }
}

// MARK: Parent view model

extension Demo_3 {
    @MainActor class ViewModel: ObservableObject {
        // Changes to childViewModel do not reflect to the parent view
        let childViewModel = ChildViewModel()
        
        // You might be inclined to mark it as @Published,
        // but property wrappers can't be used on a `let`.
        /*
        @Published let childViewModel = ChildViewModel()
         */
        
        // Changing it to `var` doesn't work either. That's because
        // this `childViewModel` property is merely a reference to an
        // object. When that object changes, this instance of ViewModel
        // itself does not change because the reference stayed the same.
        /*
        @Published var childViewModel = ChildViewModel()
         */
        
        /*
        // The solution is to have this ObservableObject listen for changes to
        // the child ObservableObject through its objectWillChange publisher.
        var subscriptions = Set<AnyCancellable>()
        
        init() {
            self.childViewModel.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &self.subscriptions)
        }
         */
    }
}

// MARK: Child view

extension Demo_3 {
    struct ChildView: View {
        @ObservedObject var viewModel: ChildViewModel
        
        var body: some View {
            Section("Child content") {
                if self.viewModel.loaded {
                    Text("Item 0")
                    Text("Item 1")
                    Text("...")
                } else {
                    ProgressView()
                }
            }
        }
    }
    
    @MainActor class ChildViewModel: ObservableObject {
        @Published var loaded = false
        
        func loadData() async throws {
            self.loaded = false
            try await Task.sleep(for: .seconds(1))
            self.loaded = true
        }
    }
}

// MARK: - Previews

struct Demo_3_Previews: PreviewProvider {
    static var previews: some View {
        Demo_3()
    }
}
