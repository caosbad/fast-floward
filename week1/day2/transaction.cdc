import Artist from 0x01

transaction() {
  
  let pixels: String
  let picture: @Artist.Picture?
  let collection: &Artist.Collection
  prepare(authAccount: AuthAccount) {
    // get Artist resource
    let account = getAccount(0x01)
    let printerRef = account
      .getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
      .borrow()
      ?? panic("Couldn't borrow printer reference.")
    
    let collectionCap = authAccount.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)

    if collectionCap.check() == false {
      log("init collection for user")
      authAccount.save(<- Artist.createCollection(), to: /storage/ArtistPictureCollection )
      authAccount.link<&Artist.Collection>(/public/ArtistPictureCollection, target: /storage/ArtistPictureCollection)
    }
    self.collection = collectionCap.borrow() ?? panic("user has no collection yet")
    
    // Replace with your own drawings.
    self.pixels = "*   * * *   *   * * *  **"
    let canvas = Artist.Canvas(
      width: printerRef.width,
      height: printerRef.height,
      pixels: self.pixels
    )
    
    self.picture <- printerRef.print(canvas: canvas)
  }

  execute {
    if (self.picture == nil) {
      log("Picture with ".concat(self.pixels).concat(" already exists!"))
      destroy self.picture
    } else {
      self.collection.deposit(picture:<-self.picture!)
      log("Picture printed and sotre to the collections")
    }
  }
}