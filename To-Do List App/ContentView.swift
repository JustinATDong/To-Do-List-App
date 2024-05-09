//
//  ContentView.swift
//  To-Do List App
//
//  Created by Justin Dong on 4/27/24.
// changes in this branch made by Brandon Dominguez 5/6/2024
//


import SwiftUI

enum TaskType {
    case work
    case personal
    case casual
}

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTaskName = ""
    @State private var newTaskDueDateTime = Date()
    @State private var selectedTaskType: TaskType = .work // Default task type
    @State private var trashedTasks: [Task] = [] // New state to store trashed tasks
    @State private var showTrashBin = false // State to control showing the trash bin

    var body: some View {
        VStack {
            Text("To-Do List")
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

                Picker(selection: $selectedTaskType, label: Text("Task Type")) {
                    Text("Work").tag(TaskType.work)
                    Text("Personal").tag(TaskType.personal)
                    Text("Casual").tag(TaskType.casual)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: {
                    // Add a new task
                    let task = Task(name: newTaskName, dueDate: newTaskDueDateTime, type: selectedTaskType)
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

            Spacer()

            // Trash bin
            HStack {
                Spacer()
                Button(action: {
                    showTrashBin.toggle() // Toggle trash bin view
                }) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .padding(.trailing)
            }
        }
        .sheet(isPresented: $showTrashBin) {
            TrashBinView(trashedTasks: $trashedTasks) {
                // Delete all trashed tasks
                trashedTasks.removeAll()
            }
        }
    }

    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            if tasks[index].isCompleted {
                // Move completed tasks to trash bin
                moveCompletedTasksToTrashBin()
            }
        }
    }

    func moveCompletedTasksToTrashBin() {
        let completedTasks = tasks.filter { $0.isCompleted }
        tasks.removeAll { $0.isCompleted }
        trashedTasks.append(contentsOf: completedTasks)
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
    var type: TaskType
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
            Text("Type: \(task.type)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(15)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct TrashBinView: View {
    @Binding var trashedTasks: [Task]
    let deleteAllAction: () -> Void // Action to delete all trashed tasks

    var body: some View {
        NavigationView {
            List {
                ForEach(trashedTasks) { task in
                    Text(task.name)
                }
                .onDelete { indexSet in
                    // Delete individual trashed task
                    trashedTasks.remove(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Trash Bin")
            .navigationBarItems(trailing: Button("delete all") {
                // Close the trash bin view
                deleteAllAction()
            })
        }
    }
}

