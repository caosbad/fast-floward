pub contract Artist {

  pub event PicturePrintSuccess(pixels: String)
  pub event PicturePrintFailure(pixels: String)


  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }

  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        emit PicturePrintFailure(pixels: canvas.pixels)
        return nil
      }

      // Canvas can only use visible ASCII characters.
      for symbol in canvas.pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          emit PicturePrintFailure(pixels: canvas.pixels)
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas
        emit PicturePrintSuccess(pixels: canvas.pixels)
        return <- picture
      } else {
        return nil
      }
    }
  }

pub resource Collection {
    pub var myPics: @{UInt64: Picture}

    pub var picCount: UInt64
    
    pub fun deposit(picture: @Picture) {
        let id = self.picCount
        let oldPic <- self.myPics[id] <- picture
        self.picCount = id + 1
        destroy oldPic
    }
    init(){
        self.myPics <- {}
        self.picCount = 0
    }

    destroy() {
      destroy self.myPics
    }

}

  pub fun createCollection(): @Collection {
    let collection <- create Collection()
    return <- collection
  }


  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )

    self.account.save(<- self.createCollection(), to: /storage/ArtistPictureCollection )
    self.account.link<&Collection>(
      /public/ArtistPictureCollection,
      target: /storage/ArtistPictureCollection
    )
  }
}
