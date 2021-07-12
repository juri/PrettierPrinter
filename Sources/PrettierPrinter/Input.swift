func readInput() -> String {
    sequence(
        first: readLine(strippingNewline: false) ?? "",
        next: { _ in readLine(strippingNewline: false) }
    )
    .joined()
}
