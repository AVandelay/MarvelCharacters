//
//  MarvelServiceTests.swift
//
//
//  Created by Ken Westdorp on 7/6/24.
//

import API
import AppUI
import Core
import Services
import XCTest

final class MarvelServiceTests: XCTestCase {

    // MARK: - Test Doubles

    private final class MarvelAPIClientSpy: MarvelAPIClientProtocol, @unchecked Sendable {
        var executeCalled = false
        var lastRequest: (any MarvelAPIRequest)?
        var stubbedResponse: Any?
        var stubbedError: Error?

        func execute<Request: MarvelAPIRequest>(_ request: Request) async throws -> Request.Response {
            executeCalled = true
            lastRequest = request

            if let error = stubbedError {
                throw error
            }

            if let response = stubbedResponse as? Request.Response {
                return response
            }

            fatalError("Stubbed response not set or doesn't match the expected type")
        }
    }

    private class ErrorAlertSpy: ErrorAlertProtocol {
        var lastAlert: DisplayableError?
        var alert: DisplayableError? {
            didSet {
                lastAlert = alert
            }
        }
    }

    // MARK: - Tests

    @MainActor
    func testGetCharacterList_Success() async throws {
        let (sut, apiClientSpy, _) = makeSUT()

        let expectedResponse: MarvelAPIResponse<APIDataContainer<Character>> = try loadMarvelAPIResponse(.characterList)
        apiClientSpy.stubbedResponse = expectedResponse

        let result = try await sut.getCharacterList(limit: 20, offset: 0)

        XCTAssertTrue(apiClientSpy.executeCalled)
        XCTAssertTrue(apiClientSpy.lastRequest is MarvelAPI.CharacterListRequest.Get)
        XCTAssertEqual(result.count, expectedResponse.data.results.count)
        XCTAssertEqual(result.first?.id, expectedResponse.data.results.first?.id)
        XCTAssertEqual(result.first?.name, expectedResponse.data.results.first?.name)
    }

    @MainActor
    func testGetCharacterList_Failure() async {
        let (sut, apiClientSpy, errorAlertSpy) = makeSUT()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        apiClientSpy.stubbedError = expectedError

        do {
            _ = try await sut.getCharacterList(limit: 20, offset: 0)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(apiClientSpy.executeCalled)
            XCTAssertTrue(apiClientSpy.lastRequest is MarvelAPI.CharacterListRequest.Get)
            XCTAssertEqual(errorAlertSpy.lastAlert?.message, "Failed to fetch character list") // Main actor-isolated property 'lastAlert' can not be referenced from a non-isolated autoclosure
        }
    }

    @MainActor
    func testGetComicsWithCharacter_Success() async throws {
        let (sut, apiClientSpy, _) = makeSUT()

        let expectedResponse: MarvelAPIResponse<APIDataContainer<Comic>> = try loadMarvelAPIResponse(.comics)
        apiClientSpy.stubbedResponse = expectedResponse

        let result = try await sut.getComicsWithCharacter(characterID: CharacterID(rawValue: 1011334), limit: 20, offset: 0)

        XCTAssertTrue(apiClientSpy.executeCalled)
        XCTAssertTrue(apiClientSpy.lastRequest is MarvelAPI.ComicsWithCharacterRequest.Get)
        XCTAssertEqual(result.count, expectedResponse.data.results.count)
        XCTAssertEqual(result.first?.id, expectedResponse.data.results.first?.id)
        XCTAssertEqual(result.first?.title, expectedResponse.data.results.first?.title)
    }

    @MainActor
    func testGetComicsWithCharacter_Failure() async {
        let (sut, apiClientSpy, errorAlertSpy) = makeSUT()
        let expectedError = NSError(domain: "TestError", code: 1, userInfo: nil)
        apiClientSpy.stubbedError = expectedError

        do {
            _ = try await sut.getComicsWithCharacter(characterID: CharacterID(rawValue: 1011334), limit: 20, offset: 0)
            XCTFail("Expected an error to be thrown")
        } catch {
            XCTAssertTrue(apiClientSpy.executeCalled)
            XCTAssertTrue(apiClientSpy.lastRequest is MarvelAPI.ComicsWithCharacterRequest.Get)
            XCTAssertEqual(errorAlertSpy.lastAlert?.message, "Failed to fetch comics for character")
        }
    }

    // MARK: - Helpers

    @MainActor
    private func makeSUT() -> (sut: MarvelService, apiClientSpy: MarvelAPIClientSpy, errorAlertSpy: ErrorAlertSpy) {
        let apiClientSpy = MarvelAPIClientSpy()
        let errorAlertSpy = ErrorAlertSpy()
        let sut = MarvelService(api: apiClientSpy, errorAlert: errorAlertSpy)
        return (sut, apiClientSpy, errorAlertSpy)
    }

    private enum TestJSONFile: String {
        case characterList = "character_list_response"
        case comics = "comics"
    }

    private func loadMarvelAPIResponse<T: Decodable>(_ file: TestJSONFile) throws -> MarvelAPIResponse<T> {
        guard let url = Bundle.module.url(forResource: file.rawValue, withExtension: "json") else {
            throw NSError(domain: "TestError", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON file \(file.rawValue) not found in the test bundle"])
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MarvelAPIResponse<T>.self, from: data)
    }
}
