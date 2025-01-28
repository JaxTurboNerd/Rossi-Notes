//
//  DetailLineView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/5/25.
//

import SwiftUI

struct DetailLineView: View {
    var detail: String?
    var body: some View {
        Text(detail ?? "")
            .font(Font.custom("Urbanist-Medium", size: 18))
        Divider()
            .frame(width: 350, height: 0.5)
            .overlay(Color.gray)
            .padding(.vertical, 3)
    }
}

#Preview {
    DetailLineView(detail: "Resource Guarder")
}
