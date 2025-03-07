//
//  CardView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Appwrite
import JSONCodable

struct CardView: View {
    var name: String = ""
//    var id: String = ""
//    @StateObject var viewModel: PlusViewModel
//    @State var triggerRefresh = false
    
    var body: some View {
        Group {
            Text(name)
                .font(Font.custom("ConcertOne-Regular", size: 24))
                .tracking(2)//adds letter spacing
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight:70 ,alignment: .center)
                .background(Color("AppBlue"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
//        .overlay {
//            NavigationLink(destination: DetailView(appwrite: <#Appwrite#>, collectionId: viewModel.collectionId, documentId: id, triggerRefresh: $triggerRefresh), label: {EmptyView()})
//        }
    }
}

