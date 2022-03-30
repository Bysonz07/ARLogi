//
//  BrowseView.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import SwiftUI
import CoreMedia

struct BrowseView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false) {
                //Gridviews for thumbnails
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationTitle(Text("Browse"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button {
                    print("Done press")
                    self.showBrowse.toggle()
                } label: {
                    HStack {
                        
                        Text("Done").bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                        
                    }
                    .background(Color("krem"))
                    .cornerRadius(10)
                    
                }

            }
        }
    }
}

struct ModelsByCategoryGrid: View {
    @Binding var showBrowse: Bool
    let models = Models()
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self){
                category in
                //Only Display if category contains item
                if let modelsByCategory = models.get(category: category) {
                    HorizontalGrid(showBrowse: $showBrowse, title: category.label, items: modelsByCategory)
                }
            }
        }
    }
}

//MARK: - Horizontal List Grid
struct HorizontalGrid: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    //Setting Max Height 150
    private let gridItemLayout = [GridItem(.fixed(150))]
    var title: String
    var items: [Model]
    
    var body: some View {
        VStack(alignment: .leading) {
            Separator()
            Text(title)
                .font(.title2)
                .bold()
                .padding(.top, 10)
                .padding(.leading, 22)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 20) {
                    ForEach(0..<items.count ) {
                        index in

                        let model = items[index]
                        NavigationLink(destination: CollectionDetailView(model: model, showBrowse: $showBrowse)) {
                            VStack(alignment:.leading) {
                                Image(uiImage:  model.thumbnail)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .aspectRatio(1/1, contentMode: .fit)
                                    .background(Color(UIColor.secondarySystemFill))
                                    .cornerRadius(8.0)
                                Text("\(model.title)")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                            }
                            .contentShape(Rectangle())
                        }

                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}

//MARK: - Item PalceHolder
struct ItemButton: View {
    let model : Model
    let action: () -> Void
    var body: some View {
        Button {
            print("Item \(self.model.name) Button Pressed")
            self.action()
        } label: {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8.0)
        }

    }
}

//MARK: - Custom Separator
struct Separator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

//struct BrowseView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrowseView(showBrowse: Binding.constant(true))
//    }
//}
