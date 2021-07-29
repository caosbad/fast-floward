import Artist from "./contract.cdc"

pub fun display(canvas: Artist.Canvas) {
  var lineNum:UInt8 = 0
  var idx: UInt8 = 0
  log("+-----+")
  while lineNum < canvas.width {
        var idx = Int(lineNum * canvas.height)
        var line = "|"
        let endIndex = idx+ Int(canvas.width)
        line = line.concat(canvas.pixels.slice(from: idx, upTo: endIndex ))
        line = line.concat("|")
        lineNum = lineNum + 1
        log(line)
  }
  log("+-----+")
}

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {

	let account = getAccount(address)
  let collectionCap = account.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)

	if collectionCap.check() == false {
		return nil
	}
  let collection = collectionCap.borrow()

  let count = collection.picCount
  var id:UInt64 = 0

	var results:[Sting]？ = []

  while id < count {
    let pic = &collection.myPics[id] as &Artist.Picture
    display(canvas: pic.canvas)
    id = id + 1
		result.append(pic.canvas.pixels)
  }

	return results
}