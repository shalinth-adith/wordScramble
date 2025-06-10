//
//  ContentView.swift
//  wordScramble
//
//  Created by shalinth adithyan on 10/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord  = ""
    @State private var newWord  = ""
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Enter the Word ",text: $newWord)
                }
                Section{
                    ForEach(usedWords , id :\.self ){word in
                            Text(word)
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
}

#Preview {
    ContentView()
}
