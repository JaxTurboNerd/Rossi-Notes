//
//  DeleteAlertButton.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 5/14/25.
//

import SwiftUI
import Appwrite

struct DeleteAlertButton: View {
    @StateObject private var viewModel: DetailViewModel
    @Binding var noteDeleted: Bool
    @Binding var showAlert: Bool
    private var appwrite: Appwrite
    var collectionId: String
    var documentId: String
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    init(appwrite: Appwrite, collectionId: String, documentId: String, noteDeleted: Binding<Bool>, showAlert: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(appwrite: appwrite))
        self.appwrite = appwrite
        self.collectionId = collectionId
        self.documentId = documentId
        _noteDeleted = noteDeleted
        _showAlert = showAlert
    }
    
    var body: some View {
        Button("Delete", role: .destructive){
            Task {
                do {
                    try await viewModel.deleteNote(collectionId: collectionId, documentId: documentId)
                    noteDeleted = true
                } catch {
                    print("Deleting note error: \(error.localizedDescription)")
                    showAlert = true
                }
            }
            dismiss.callAsFunction()
        }
        Button("Cancel", role: .cancel){
            //action:
        }
    }
}

#Preview {
    @Previewable var previewAppwrite = Appwrite()
    DeleteAlertButton(appwrite: previewAppwrite, collectionId: "11l1jlj1l", documentId: "lakdoiuldj", noteDeleted: .constant(false), showAlert: .constant(false))
}
