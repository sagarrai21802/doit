import Foundation

// MARK: - API Configuration
struct APIConfig {
    // Change this to your Mac's IP if testing on real device
    // Use localhost for simulator
    static let baseURL = "http://localhost:8000"
}

// MARK: - API Response Models
struct UserResponse: Codable {
    let id: String
    let phone_number: String
    let created_at: String
}

struct GoalResponse: Codable {
    let id: String
    let user_id: String
    let title: String
    let description: String
    let target_date: String
    let created_at: String
    let streak: Int
    let progress: Double
    let roadmap: Roadmap?
    let today_tasks: DayTask?
}

struct Roadmap: Codable {
    let total_days: Int
    let summary: String
    let days: [DayTask]
}

struct DayTask: Codable {
    let day: Int
    let date: String
    let title: String
    let tasks: [Task]
    let tips: String
}

struct Task: Codable {
    let task: String
    let duration_minutes: Int
    let resources: [String]
}

// MARK: - Network Service
class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    // MARK: - Register User
    func registerUser(phoneNumber: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/auth/register") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["phone_number": phoneNumber]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Create Goal
    func createGoal(userId: String, title: String, description: String, targetDate: Date, completion: @escaping (Result<GoalResponse, Error>) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/goals/") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dateFormatter = ISO8601DateFormatter()
        let body: [String: Any] = [
            "user_id": userId,
            "title": title,
            "description": description,
            "target_date": dateFormatter.string(from: targetDate)
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let goal = try JSONDecoder().decode(GoalResponse.self, from: data)
                completion(.success(goal))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Get User Goals
    func getUserGoals(userId: String, completion: @escaping (Result<[GoalResponse], Error>) -> Void) {
        guard let url = URL(string: "\(APIConfig.baseURL)/goals/user/\(userId)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let goals = try JSONDecoder().decode([GoalResponse].self, from: data)
                completion(.success(goals))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Network Errors
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
