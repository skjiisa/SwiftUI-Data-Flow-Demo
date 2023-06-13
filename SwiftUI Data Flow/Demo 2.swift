//
//  Demo 2.swift
//  SwiftUI Data Flow
//
//  Created by Elaine Lyons on 6/12/23.
//

import SwiftUI

// MARK: - Demo 2

struct Demo_2: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var debug = false
    
    var body: some View {
        List {
            ForEach(self.viewModel.items) { item in
                Cell(item: item)
                    .overlay(alignment: .center) {
                        if debug {
                            Text("\(item.title) $\(item.price)")
                                .foregroundColor(.red)
                                .padding(2)
                                .background(in: Rectangle())
                                .border(Color.red)
                        }
                    }
            }
            .onMove { indices, offset in
                self.viewModel.items.move(fromOffsets: indices, toOffset: offset)
            }
            
            Section {
                /*
                Button("Sort") {
                    self.viewModel.sortByPrice()
                }
                 */
                
                Button("Randomize") {
                    self.viewModel.randomize()
                }
            }
            
            Section {
                Toggle("Debug", isOn: $debug)
            }
        }
        .task {
            await self.viewModel.loadItems()
        }
    }
}

// MARK: Cell

extension Demo_2 {
    struct Cell: View {
        @StateObject private var viewModel: CellViewModel
        
        init(item: Item) {
            self._viewModel = .init(wrappedValue: .init(item: item))
        }
        
        var body: some View {
            LabeledContent {
                Text(self.viewModel.content)
            } label: {
                Label(
                    self.viewModel.labelTitle,
                    systemImage: self.viewModel.labelSystemImage
                )
            }

        }
    }
    
    class CellViewModel: ObservableObject {
        private var item: Item
        
        var content: String {
            "$\(self.item.price)"
        }
        var labelTitle: String {
            self.item.title
        }
        var labelSystemImage: String {
            self.item.symbol
        }
        
        init(item: Item) {
            self.item = item
        }
    }
}

// MARK: Model

extension Demo_2 {
    struct Item: Codable, Identifiable {
        var title: String
        var price: Int
        var symbol: String
        
        var id: String {
            self.symbol
        }
    }
}

// MARK: View Model

extension Demo_2 {
    @MainActor class ViewModel: ObservableObject {
        @Published var items: [Item] = []
        
        func loadItems() async {
            // try? await Task.sleep(for: .seconds(1))
            self.items = Demo_2.mockItems
        }
        
        /*
        func sortByPrice() {
            self.items.sort { $0.price > $1.price }
        }
        
        func randomize() {
            self.items.shuffle()
        }
         */
        
        func randomize() {
            let index = self.items.firstIndex { $0.price == 99999 }
            guard let index else { return }
            self.items[index].title = String(UUID().uuidString.prefix(8))
        }
    }
}

// MARK: Mock

extension Demo_2 {
    static let mockItems: [Item] = [
        Item(title: "Mouse", price: 40, symbol: "computermouse"),
        Item(title: "Keyboard", price: 200, symbol: "keyboard"),
        Item(title: "Dice", price: 4, symbol: "dice"),
        Item(title: "Puzzle Cube", price: 10, symbol: "cube"),
        Item(title: "Vision Pro", price: 3500, symbol: "dollarsign.circle"),
        Item(
            title: String(UUID().uuidString.prefix(8)),
            price: 99999,
            symbol: "infinity.circle"
        ),
    ]
}

// MARK: - Previews

struct Demo_2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Demo_2()
        }
    }
}
