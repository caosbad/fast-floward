import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
	var collection: &Artist.Collection?
	var picture:@Artist.Picture?
	prepare(account: AuthAccount)  {
	let printerRef = account
		.getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
		.borrow()
		?? panic("Couldn't borrow printer reference.")
	
		let canvas: Artist.Canvas = Artist.Canvas(
		width: width,
		height: height,
		pixels: pixels
	)

	let collectionCap = account.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)

	if collectionCap.check() == false {
		log("init collection for user")
		account.save(<- Artist.createCollection(), to: /storage/ArtistPictureCollection )
		account.link<&Artist.Collection>(/public/ArtistPictureCollection, target: /storage/ArtistPictureCollection)
	}

    self.collection = collectionCap.borrow() ?? panic("user has no collection yet")
    self.picture <- printerRef.print(canvas: canvas)
   
	}
	execute {
		self.collection!.deposit(picture: <- self.picture!)
	}
}