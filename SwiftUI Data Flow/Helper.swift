//
//  Helper.swift
//  SwiftUI Data Flow
//
//  Created by Elaine Lyons on 6/12/23.
//

import SwiftUI

private struct Distinguish: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemFill))
            .cornerRadius(8)
    }
}

extension View {
    func distinguish() -> some View {
        self
            .modifier(Distinguish())
    }
}

struct Helper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Top text")
            Text("Bottom text")
        }
        .modifier(Distinguish())
    }
}
