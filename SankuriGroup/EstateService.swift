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
    let backgroundImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case logoURL = "LogoURL"
        case backgroundImageURL = "BackgroundImageURL"
    }
}


// MARK: - Estate Details Models

struct EstateDetailsResponse: Decodable {
    let name: String
    let estateStages: [EstateStage]

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case estateStages = "EstateStages"
    }
}

// MARK: - Stage Gallery Models

struct StageGalleryImage: Decodable {
    let id: Int
    let galleryURL: String
    let description: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case galleryURL = "GalleryURL"
        case description
        case date
    }
}


struct EstateStage: Decodable {
    let stageId: Int
    let stage: StageDetails

    enum CodingKeys: String, CodingKey {
        case stageId = "StageId"
        case stage = "Stage"
    }
}

struct StageDetails: Decodable {
    let number: Int
    let description: String?

    enum CodingKeys: String, CodingKey {
        case number = "Number"
        case description = "Description"
    }
}



// MARK: - Network Service
final class EstateService {

    static let shared = EstateService()
    private init() {}

    private let baseURL = "https://sunkuri.azurewebsites.net/api/estate/getallestates"

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
    
    // Get Estate & Stages count by estate ID
    func getEstateById(
        estateId: Int,
        completion: @escaping (Result<EstateDetailsResponse, Error>) -> Void
    ) {
        let urlString = "https://sunkuri.azurewebsites.net/api/estate/getbyid/\(estateId)"
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
                let response = try JSONDecoder().decode(EstateDetailsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

        }.resume()
    }


}

// MARK: - Stage Details Models

struct StageDetailResponse: Decodable {
    let phases: [StagePhase]

    enum CodingKeys: String, CodingKey {
        case phases = "Phases"
    }
}

struct StagePhase: Decodable {
    let name: String
    let phaseWorkItems: [PhaseWorkItem]

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case phaseWorkItems = "PhaseWorkItems"
    }
}

struct PhaseWorkItem: Decodable {
    let name: String
    let isCompleted: Bool?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case isCompleted = "IsCompleted"
    }
}

// MARK: - API

extension EstateService {

    func fetchStageDetails(
        estateId: Int,
        stageId: Int,
        completion: @escaping (Result<StageDetailResponse, Error>) -> Void
    ) {
        let urlString =
        "https://sunkuri.azurewebsites.net/api/estate/getstageDetails/\(estateId)/\(stageId)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode(StageDetailResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getStageDetails(
        estateId: Int,
        stageId: Int,
        completion: @escaping (Result<StageDetailResponse, Error>) -> Void
    ) {
        let urlString = "https://sunkuri.azurewebsites.net/api/estate/getstageDetails/\(estateId)/\(stageId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(StageDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    

    func getStageGalleryImages(
        estateId: Int,
        stageId: Int,
        completion: @escaping (Result<[StageGalleryImage], Error>) -> Void
    ) {
        let urlString =
        "https://sunkuri.azurewebsites.net/api/estate/GetStageGalleryImage/\(estateId)/\(stageId)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else { return }

            do {
                let response = try JSONDecoder().decode([StageGalleryImage].self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}


