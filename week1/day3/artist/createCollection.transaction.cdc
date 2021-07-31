import Artist from "./contract.cdc"

// Create a Picture Collection for the transaction authorizer.
transaction {
	prepare(account: AuthAccount) {
	  let collectionCap = account.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)
    if collectionCap.check() == false {
      log("init collection for user")
      account.save(<- Artist.createCollection(), to: /storage/ArtistPictureCollection )
      account.link<&Artist.Collection>(/public/ArtistPictureCollection, target: /storage/ArtistPictureCollection)
      log("init done")
      } else {
        log("collection already exist")
    }
	}
}