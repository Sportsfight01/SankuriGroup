//
//  EstateService.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 20/01/26.
//

import Foundation

// MARK: - Models
struct Estate: Decodable {
    let id: Int
    let name: String
    let logoURL: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case logoURL = "LogoURL"
    }
}


// MARK: - Network Service
final class EstateService {

    static let shared = EstateService()
    private init() {}

    private let baseURL = "https://sunkuri.azurewebsites.net/api/estate/getallestates" // 🔴 replace

    func fetchEstates(completion: @escaping (Result<[Estate], Error>) -> Void) {

        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let estates = try JSONDecoder().decode([Estate].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(estates))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getEstateDetails(
        estateId: Int,
        completion: @escaping (Result<Estate, Error>) -> Void
    ) {
        let urlString = "https://sunkuri.azurewebsites.net/api/estate/getallestates/\(estateId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data else { return }

            do {
                let estate = try JSONDecoder().decode(Estate.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(estate))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }

}

