//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI

struct DetailView: View {
    var name = ""
    var body: some View {
        Text(name)
            .font(.title)
    }
}

#Preview {
    DetailView()
}
