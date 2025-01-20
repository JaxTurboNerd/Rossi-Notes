//
//  DetailGroupView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/5/25.
//

import SwiftUI

struct DetailGroupView: View {
    
    var viewModel: DetailViewModel
    
    var body: some View {
        Group {
            viewModel.detailsModel.barrierReactive ? AnyView(DetailLineView(detail: viewModel.detailsData.barrierReactive)) : AnyView(EmptyView())
            viewModel.detailsModel.dogReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.dogReactive))
            viewModel.detailsModel.strangerReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.strangerReactive))
            viewModel.detailsModel.leashReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsModel.leashReactive))
            viewModel.detailsModel.catReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsModel.catReactive))
        }
        .padding(.vertical, 2)
        Group {
            viewModel.detailsModel.jumpyMouthy.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.jumpyMouthy))
            viewModel.detailsModel.resourceGuarder.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.resourceGuarder))
            viewModel.detailsModel.doorRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.doorRoutine)
            )
            viewModel.detailsModel.placeRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.placeRoutine))
            viewModel.detailsModel.miscNotes.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.miscNotes)            )
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 2)
    }
}
