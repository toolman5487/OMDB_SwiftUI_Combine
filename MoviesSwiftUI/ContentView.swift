//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Mohammad Azam on 10/13/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var movie:[Movie] = []
    @State private var search:String = ""
    @State private var cancellables:Set<AnyCancellable> = []
    private let httpClient: HTTPClient
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    
    init(httpClientL: HTTPClient) {
        self.httpClient = httpClientL
    }
    
    func setupSearchPublisher() {
        searchSubject.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                loadMovieData(search: searchText)
            }.store(in: &cancellables)
    }
    
    func loadMovieData(search:String) {
        httpClient.fetchMovies(search: search)
            .sink { _ in
                
            } receiveValue: { movie in
                self.movie = movie
            }.store(in: &cancellables)

    }
    
    var body: some View {
        List(movie){ movie in
            HStack{
                AsyncImage(url: movie.poster){ image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75,height: 75)
                }placeholder:{
                    ProgressView()
                }
                Text(movie.title)
            }
        }.onAppear{
            setupSearchPublisher()
        }
        .searchable(text: $search)
            .onChange(of: search) {
                searchSubject.send(search)
            }
    }
}

#Preview {
    NavigationStack {
        ContentView(httpClientL: HTTPClient())
    }
}
