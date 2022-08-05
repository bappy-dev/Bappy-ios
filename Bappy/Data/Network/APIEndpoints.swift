//
//  APIEndpoints.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/08.
//

import Foundation

// MARK: - User
struct APIEndpoints {
    static func fetchCurrentUser() -> Endpoint<FetchCurrentUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "auth/login",
            method: .get)
    }
    
    static func fetchUserProfile(with userProfileRequestDTO: FetchProfileRequestDTO) -> Endpoint<FetchProfileResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "auth/login",
            method: .get,
            queryParameters: userProfileRequestDTO)
    }
    
    static func createUser(with createUserRequestDTO: CreateUserRequestDTO) -> Endpoint<CreateUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "user/",
            method: .post,
            bodyParameters: createUserRequestDTO,
            contentType: .multipart)
    }
    
    static func deleteUser() -> Endpoint<DeleteUserResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "user",
            method: .delete)
    }
    
    static func updateProfile(with updateProfileRequestDTO: UpdateProfileRequestDTO, data: Data?) -> Endpoint<UpdateProfileResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "user",
            method: .put,
            bodyParameters: updateProfileRequestDTO,
            imageDatas: data.map { [$0] },
            contentType: .multipart)
    }
    
    static func updateGPSSetting(with gpsSettingRequestDTO: UpdateGPSSettingRequestDTO) -> Endpoint<UpdateGPSSettingResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "place/gps",
            method: .put,
            bodyParameters: gpsSettingRequestDTO,
            contentType: .urlencoded)
    }
    
    static func updateFCMToken(with updateFCMTokenRequestDTO: UpdateFCMTokenRequestDTO) -> Endpoint<UpdateFCMTokenResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "user/fcmToken",
            method: .put,
            bodyParameters: updateFCMTokenRequestDTO,
            contentType: .urlencoded)
    }
}


    
// MARK: - Map
extension APIEndpoints {
    static func searchGoogleMapList(with mapsRequestDTO: FetchMapsRequestDTO) -> Endpoint<FetchMapsResponseDTO> {
        return Endpoint(
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
    
    static func searchGoogleMapNextList(with mapsRequestDTO: FetchMapsNextRequestDTO) -> Endpoint<FetchMapsResponseDTO> {
        return Endpoint(
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/place/textsearch/json?",
            method: .get,
            queryParameters: mapsRequestDTO)
    }
    
    static func fetchGoogleMapImage(with mapImageRequestDTO: FetchMapImageRequestDTO) -> Endpoint<Data> {
        return Endpoint(
            baseURL: GOOGLE_MAP_API_BASEURL,
            path: "maps/api/staticmap?",
            method: .get,
            queryParameters: mapImageRequestDTO)
    }
}



// MARK: - Hangout
extension APIEndpoints {
    static func fetchHangouts(with hangoutsRequestDTO: FetchHangoutsRequestDTO) -> Endpoint<FetchHangoutsResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "hangouts",
            method: .get,
            queryParameters: hangoutsRequestDTO)
    }
    
    static func createHangout(with createHangoutRequestDTO: CreateHangoutRequestDTO, data: Data) -> Endpoint<CreateHangoutResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "hangout",
            method: .post,
            bodyParameters: createHangoutRequestDTO,
            imageDatas: [data],
            contentType: .multipart)
    }
    
    static func deleteHangout(id hangoutID: String) -> Endpoint<DeleteHangoutResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "hangout/\(hangoutID)",
            method: .delete)
    }
    
    static func likeHangout(id hangoutID: String, hasUserLiked: Bool) -> Endpoint<LikeHangoutResponseDTO> {
        let path = hasUserLiked ? "hangout/like/\(hangoutID)" : "hangout/nolike/\(hangoutID)"
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: path,
            method: .get)
    }
    
    static func updateHangoutParticipation(with updateHangoutParticipationRequestDTO: UpdateHangoutParticipationRequestDTO,
                            id hangoutID: String) -> Endpoint<UpdateHangoutParticipationResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "hangout/\(hangoutID)",
            method: .put,
            bodyParameters: updateHangoutParticipationRequestDTO,
            contentType: .multipart)
    }
    
    static func reportHangout(with reportHangoutRequestDTO: ReportHangoutRequestDTO, datas: [Data]?) -> Endpoint<ReportHangoutResponseDTO> {
        return Endpoint(
            baseURL: BAPPY_API_BASEURL,
            path: "report",
            method: .post,
            bodyParameters: reportHangoutRequestDTO,
            imageDatas: datas,
            contentType: .multipart)
    }
}
