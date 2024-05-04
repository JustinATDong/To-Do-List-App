//
//  ContentView.swift
//  To-Do List App
//
//  Created by Justin Dong on 4/27/24.
//


import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTaskName = ""
    @State private var newTaskDueDateTime = Date()

    var body: some View {
        VStack {
            Text("CasualTasks")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(tasks) { task in
                        if !task.isCompleted {
                            TaskView(task: task, toggleTaskCompletion: toggleTaskCompletion)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(spacing: 10) {
                TextField("Enter task name", text: $newTaskName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Due Date and Time", selection: $newTaskDueDateTime, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())

                Button(action: {
                    // Add a new task
                    let task = Task(name: newTaskName, dueDate: newTaskDueDateTime)
                    tasks.append(task)
                    // Reset fields
                    newTaskName = ""
                    newTaskDueDateTime = Date()
                }) {
                    Text("Add Task")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            if tasks[index].isCompleted {
                withAnimation {
                    tasks.remove(at: index)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Task: Identifiable {
    let id = UUID()
    let name: String
    var dueDate: Date
    var isCompleted: Bool = false
}

struct TaskView: View {
    let task: Task
    let toggleTaskCompletion: (Task) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Button(action: {
                    toggleTaskCompletion(task)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.square" : "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(task.isCompleted ? .green : .secondary)
                }
                Text(task.name)
                    .font(.headline)
            }
            Text("Due: \(task.dueDate, style: .date) at \(task.dueDate, style: .time)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(15)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
