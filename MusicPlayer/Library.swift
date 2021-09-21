//
//  Library.swift
//  MusicPlayer
//
//  Created by Andrey on 07.05.2021.
//

import SwiftUI
import URLImage
struct Library: View {
    var tracks = UserDefaults.standard.savedTracks()
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {print("1234")}, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10 , height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {print("54321")}, label: {
                            Image(systemName: "arrow.2.circlepath").frame(width: geometry.size.width / 2 - 10 , height: 50)
                        })
                        .accentColor(Color.init(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)))
                        .background(Color.init(#colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)))
                        .cornerRadius(10)
                    
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List(tracks) { track in
                    LibraryCell(cell: track)
                    Text("second")
                    Text("third")
                }
            }
         
       
            .navigationBarTitle("Library")
                
        }
        
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
   
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image.resizable().frame(width: 60, height: 60).cornerRadius(2)
                
            }
           
            
                
              
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
      }
        }
  
 }


struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
}
