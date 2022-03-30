//
//  CollectionDetailView.swift
//  ARF
//
//  Created by Difa N Pratama on 24/01/22.
//

import SwiftUI

struct CollectionDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let model : Model
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    
    var findData: Koleksi {
        if let i = koleksis.firstIndex(where: { $0.image == "\(model.name)" }) {
            return koleksis[i]
        }
        return koleksis[1]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                DetailView(batu: findData)
                Scene3D(name: "\(findData.image)")
                
                Button {
                    // Call model method to async load modelEntity
                    model.asyncLoadEntity()
                    // Select model for placement
                    self.placementSettings.selectedModel = model
                    
                    print("Model selected : \(model.name)")
                    self.showBrowse = false
                } label: {
                    HStack {
                        Spacer()
                        Image(colorScheme == .dark ? "ingress_light" : "ingress_dark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        Text(" View in AR ")
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Spacer()
                    }
                    .padding()
                    .background(Color("krem"))
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
                }
                .padding(.vertical, 5)
            }
            
        }
        .navigationBarTitle("\(findData.name)", displayMode: .inline)

    }
}
//
//struct CollectionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionDetailView()
//    }
//}

struct DetailView: View {
    var batu: Koleksi
    var body: some View {
        VStack(alignment: .leading) {
            Image("\(batu.image)")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
                .frame(maxHeight: 400)
            Text("Description")
                .fontWeight(.medium)
                .font(.title2)
                .padding(10)
            Divider()
            Text("\(batu.description)")
                .padding(.leading, 10)
            Divider()
            HStack {
                Image(systemName: "rotate.3d")
                Text("3D Model \(batu.name) ")
            }
            .padding(.leading, 10)
            .padding(.vertical, 5)
            Divider()
            
        }
        
    }
}

struct Task: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let image: String
    let subtask: Subtask
}

struct Subtask: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let height: Float
}

struct SubtaskCell: View {
    let task: Subtask
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "viewfinder")
                Text(task.title)
                    .padding(.trailing, 25)
            }
            .frame( height: CGFloat(task.height * 1.5))
        }
        
    }
}

struct TaskCell: View {
    @State private var isExpanded: Bool = false
    
    let task: Task
    
    var body: some View {
        content
            .padding(.leading)
            .frame(maxWidth: .infinity)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 5) {
            header
            if isExpanded {
                SubtaskCell(task: task.subtask)
                    .padding(.leading)
            }
            Divider()
        }
    }
    
    private var header: some View {
        HStack {
            Image(systemName: task.image)
            Text(task.title)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(Color.primary.opacity(0.2))
            Spacer()
                .frame(width:20)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
        .onTapGesture {
            withAnimation { isExpanded.toggle() }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TextView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
