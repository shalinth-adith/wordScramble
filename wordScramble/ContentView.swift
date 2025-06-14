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
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Enter the Word ",text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWords , id :\.self ){word in
                        HStack{
                            Image(systemName:"\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform:startGame)
            .alert(errorTitle , isPresented: $showingError){ } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button {
                            restartGame()
                }label:{
                    Label("Restart" , systemImage: "arrow.clockwise.circle.fill")
                }
                
            }
        }
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isOrginal(word: answer) else {
            wordError(title: "Word used already ", message: "Be more orginal !")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible ", message: "You cant spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "word not recognized", message:"You cant just make them , you know !")
            return
        }
        
        
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    func isOrginal(word: String) -> Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool{
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word:String) -> Bool {
        let checker = UITextChecker()
        let range =  NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word ,range: range,startingAt: 0 ,wrap : false,language :"en")
        return misspelledRange.location == NSNotFound
        
    }
    func wordError(title: String , message:String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    func restartGame(){
        withAnimation{
            usedWords.removeAll()
            newWord = ""
            startGame()
        }
        
    }
}



#Preview {
    ContentView()
}
