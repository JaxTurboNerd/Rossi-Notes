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
            viewModel.detailsModel?.barrierReactive ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.barrierReactive)) : AnyView(EmptyView())
            viewModel.detailsModel?.dogReactive ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.dogReactive)) : AnyView(EmptyView())
            viewModel.detailsModel?.strangerReactive ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.strangerReactive)) : AnyView(EmptyView())
            viewModel.detailsModel?.leashReactive ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.leashReactive)) : AnyView(EmptyView())
            viewModel.detailsModel?.catReactive ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.catReactive)): AnyView(EmptyView())
        }
        .padding(.vertical, 2)
        Group {
            viewModel.detailsModel?.dragline ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.dragline)) : AnyView(EmptyView())
            viewModel.detailsModel?.chainLeash ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.chainLeash)) : AnyView(EmptyView())
            viewModel.detailsModel?.harness ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.harness)) : AnyView(EmptyView())
            viewModel.detailsModel?.gentleLeader ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.gentleLeader)) : AnyView(EmptyView())
        }
        .padding(.vertical, 2)
        Group {
            viewModel.detailsModel?.looseLeash ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.looseLeash)) : AnyView(EmptyView())
            viewModel.detailsModel?.shyFearful ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.shyFearful)) : AnyView(EmptyView())
            viewModel.detailsModel?.jumpyMouthy ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.jumpyMouthy)) : AnyView(EmptyView())
            viewModel.detailsModel?.resourceGuarder ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.resourceGuarder)) : AnyView(EmptyView())
            viewModel.detailsModel?.doorRoutine ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.doorRoutine)) : AnyView(EmptyView())
            viewModel.detailsModel?.placeRoutine ?? false ? AnyView(DetailLineView(detail: viewModel.detailsStringModel.placeRoutine)) : AnyView(EmptyView())
            viewModel.detailsModel?.miscNotes.isEmpty ?? true ? AnyView(EmptyView()) : AnyView(DetailLineView(detail: viewModel.detailsStringModel.miscNotes))
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 2)
    }
}
