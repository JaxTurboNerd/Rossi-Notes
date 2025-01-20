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
            viewModel.detailsData.barrierReactive ? AnyView(DetailLineView(detail: viewModel.detailsData?.barrierReactive)) : AnyView(EmptyView())
            viewModel.detailsData.dogReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.dogReactive))
            viewModel.detailsData.strangerReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.strangerReactive))
            viewModel.detailsData.leashReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.leashReactive))
            viewModel.detailsData.catReactive.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.catReactive))
        }
        .padding(.vertical, 2)
        Group {
            viewModel.detailsData.jumpyMouthy.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.jumpyMouthy))
            viewModel.detailsData.resourceGuarder.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.resourceGuarder))
            viewModel.detailsData.doorRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.doorRoutine)
            )
            viewModel.detailsData.placeRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.placeRoutine))
            viewModel.detailsData.miscNotes.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsData.miscNotes)            )
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 2)
    }
}
