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
            viewModel.detailsModel.barrierReactive ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.barrierReactive)) : AnyView(EmptyView())
            viewModel.detailsModel.dogReactive ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.dogReactive))
            viewModel.detailsModel.strangerReactive ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.strangerReactive))
            viewModel.detailsModel.leashReactive ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.leashReactive))
            viewModel.detailsModel.catReactive ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.catReactive))
        }
        .padding(.vertical, 2)
        Group {
            viewModel.detailsModel.jumpyMouthy ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.jumpyMouthy))
            viewModel.detailsModel.resourceGuarder ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.resourceGuarder))
            viewModel.detailsModel.doorRoutine ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.doorRoutine)
            )
            viewModel.detailsModel.placeRoutine ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.placeRoutine))
            viewModel.detailsModel.miscNotes.isEmpty ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.miscNotes)            )
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 2)
    }
}
