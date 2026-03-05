//
//
// PhotoCreditService.swift
// PlacePin
//
// Created by sturdytea on 06.03.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import Foundation

final class PhotoCreditService {

    static let shared = PhotoCreditService()

    let photos: [PhotoCredit] = [
        PhotoCredit(
            imageName: "TheSydneyOperaHouse",
            authorName: "Patrick Langwallner",
            authorProfileURL: URL(string: "https://unsplash.com/@patresinger?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!,
            photoURL: URL(string: "https://unsplash.com/photos/a-building-with-a-large-roof-DcEfAfRkgCY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!
        ),
        PhotoCredit(
            imageName: "XinjiangongmenSummerPalace",
            authorName: "Emma Lau",
            authorProfileURL: URL(string: "https://unsplash.com/@youbettercallmanu?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!,
            photoURL: URL(string: "https://unsplash.com/photos/a-tall-building-with-a-sky-in-the-background-62X3Lfvjw8Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!
        ),
        PhotoCredit(
            imageName: "HakoneGate",
            authorName: "Tianshu Liu",
            authorProfileURL: URL(string: "https://unsplash.com/@tianshu?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!,
            photoURL: URL(string: "https://unsplash.com/photos/torii-gate-japan-SBK40fdKbAg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!
        ),
        PhotoCredit(
            imageName: "WarsawTownHall",
            authorName: "Glib Albovsky",
            authorProfileURL: URL(string: "https://unsplash.com/@albovsky?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!,
            photoURL: URL(string: "https://unsplash.com/photos/big-ben-under-gray-sky-during-daytime-L6kppCu_fwc?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!
        ),
        PhotoCredit(
            imageName: "Bayterek",
            authorName: "Danish Prakash",
            authorProfileURL: URL(string: "https://unsplash.com/@danishprakash?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!,
            photoURL: URL(string: "https://unsplash.com/photos/bayterek-tower-stands-tall-against-a-cloudy-sky-EqUI4Ws8b7w?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText")!
        ),
    ]
}
