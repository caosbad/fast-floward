pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    self.pixels = pixels
  }
}

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub resource Picture {

  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
  }

}

pub resource Printer {

  pub var records:{String:Bool}

  pub fun print(canvas: Canvas): @Picture? {
  
    if canvas.width == 5 && canvas.height == 5 && self.records[canvas.pixels] == nil {
    
      self.records[canvas.pixels] = true
      display(canvas: canvas)
    }
    return <- create Picture(canvas: canvas)
  }

  init() {
    self.records = {}
  }

}

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let canvasX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )

  let canvasY = Canvas(
    width: 6,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )

  let canvasZ = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
  //display(canvas: canvasX)
  let letterX <- create Picture(canvas: canvasX)
  //log(letterX.canvas)
  let printer <- create Printer()
  let picX <- printer.print(canvas: canvasX)
  let picY <- printer.print(canvas: canvasY)
  let picZ <- printer.print(canvas: canvasZ)

  destroy picX
  destroy picY
  destroy picZ
  destroy printer
  destroy letterX
}

  pub fun display(canvas: Canvas) {
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