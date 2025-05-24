import SwiftUI
import Models

struct MovieCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fit)
                case .failure:
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack {
                    Text(movie.formattedReleaseDate.prefix(4))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(movie.rating)
                            .font(.subheadline.bold())
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4, y: 2)
    }
}

#Preview {
    MovieCard(movie: Movie(
        id: 1,
        title: "Inception",
        overview: "A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.",
        posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
        releaseDate: "2010-07-16",
        voteAverage: 8.4
    ))
    .frame(width: 180)
    .padding()
}