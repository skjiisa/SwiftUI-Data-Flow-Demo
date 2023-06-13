//
//  Demo 1.swift
//  SwiftUI Data Flow
//
//  Created by Elaine Léon on 6/12/23.
//

import SwiftUI

// MARK: - Demo 1

struct Demo_1: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: 36) {
            VStack {
                Text("Parent @StateObject")
                Stepper(
                    "Count: \(self.viewModel.count)",
                    value: self.$viewModel.count
                )
                
                TextField("Subtitle", text: self.$viewModel.subtitle)
                    .textFieldStyle(.roundedBorder)
            }
            .distinguish()
            
            // Do not do this. Initializing the view model
            // in the view body without an autoclosure will
            // create a new instance on every view refresh.
            ObservableObjectView(
                viewModel: ViewModel(subtitle: self.viewModel.subtitle)
            )
            .padding(.horizontal, 36)
            
            // Once the autoclosure view model is created for the first
            // time, we can never modify it from the parent again. Only
            // use when you are sure the parent view will have the data
            // needed to load the child at its first body call.
            StateObjectView(
                viewModel: ViewModel(subtitle: self.viewModel.subtitle)
            )
            .padding(.horizontal, 36)
        }
        .padding()
    }
}

extension Demo_1 {
    
    // MARK: ObservableObjectView
    
    struct ObservableObjectView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                Text("@ObservableObject")
                Stepper(
                    "Count: \(self.viewModel.count)",
                    value: self.$viewModel.count
                )
                Text(viewModel.subtitle)
            }
            .distinguish()
        }
    }
    
    // MARK: StateObjectView
    
    struct StateObjectView: View {
        @StateObject private var viewModel: ViewModel
        
        init(viewModel: @escaping @autoclosure () -> ViewModel) {
            self._viewModel = .init(wrappedValue: viewModel())
        }
        
        var body: some View {
            VStack {
                Text("@StateObject")
                Stepper(
                    "Count: \(self.viewModel.count)",
                    value: self.$viewModel.count
                )
                Text(viewModel.subtitle)
            }
            .distinguish()
        }
    }
}

// MARK: View Model

extension Demo_1 {
    class ViewModel: ObservableObject {
        @Published var count: Int = 0
        @Published var subtitle: String
        
        init(
            subtitle: String = "Subtitle",
            line: UInt = #line
        ) {
            self.subtitle = subtitle
            print("Line \(line): Demo_1.ViewModel.init \(Date().timeIntervalSince1970)")
        }
    }
}

// MARK: - Previews

struct Demo_1_Previews: PreviewProvider {
    static var previews: some View {
        Demo_1()
    }
}
