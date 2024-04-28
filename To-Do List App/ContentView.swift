//
//  ContentView.swift
//  To-Do List App
//
//  Created by Justin Dong on 4/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [String] = []

    var body: some View {
        VStack {
            Text("To-Do List")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            List {
                ForEach(tasks, id: \.self) { task in
                    Text(task)
                }
            }

            Spacer()

            Button(action: {
                // Add a new task
                tasks.append("New Task")
            }) {
                Text("Add Task")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
