//
//  SearchBar.swift
//  assignment
//
//  Created by Yash Somkuwar on 07/10/23.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    
    //creating a new UISearchBar
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        return searchBar
    }
    
    //not used but required
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate { 
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }
        
        // updating texts
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText.lowercased()
        }
    }
}


