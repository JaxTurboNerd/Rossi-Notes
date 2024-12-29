//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Appwrite
import JSONCodable
import Foundation

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    
    var body: some View {
        VStack{
            Text("test")
//            Text(document.data["name"]?.description ?? "")
//                .font(.title)
//            Text("Notes: \(document.data["misc_notes"]?.description ?? "")")   
        }
    }
}

//#Preview {
//    DetailView()
//}
