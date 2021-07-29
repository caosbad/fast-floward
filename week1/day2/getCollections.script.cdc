import Artist from 0x01

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

pub fun main(address: Address) {
  // user adress
  let account = getAccount(address)
  let collectionCap = account.getCapability<&Artist.Collection>(/public/ArtistPictureCollection)

  let collection = collectionCap.borrow() ?? panic("user has no collection yet")

  let count = collection.picCount
  var id:UInt64 = 0

  while id < count {
    let pic = &collection.myPics[id] as &Artist.Picture
    display(canvas: pic.canvas)
    id = id + 1
  }

}

