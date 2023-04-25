//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Welliton da Conceicao de Araujo on 24/04/23.
//
import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "your key here :)")
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
 }

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
            VStack(alignment: .leading) {
                ForEach(models, id: \.self) { string in
                    Text(string)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                HStack {
                    TextField("Digite aqui...", text: $text)
                    Button("Enviar") {
                        send()
                    }
                }
            }
        .onAppear {
            viewModel.setup()
        }
        .padding()
        .foregroundColor(.purple)
    }
    
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Eu: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: "+response)
                self.text = ""
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
