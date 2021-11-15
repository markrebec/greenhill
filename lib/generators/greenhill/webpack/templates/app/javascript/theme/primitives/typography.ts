export class Fonts extends Array {
  body: string[]
  mono: string[]

  constructor(body: string[], mono: string[]) {
    super()
    body.map(f => this.push(f))
    this.body = body
    this.mono = mono
  }
}

export class FontSizes extends Array {
  small: (string | number)
  normal: (string | number)
  large: (string | number)
  xlarge: (string | number)

  constructor(...sizes: (string | number)[]) {
    super()
    sizes.map((s) => this.push(s))
    this.small = sizes[0]
    this.normal = sizes[1]
    this.large = sizes[3]
    this.xlarge = sizes[5]
  }
}

export class FontWeights extends Array {
  light: number
  normal: number
  semibold: number
  bold: number

  constructor(...weights: number[]) {
    super()
    weights.map((w) => this.push(w))
    this.light = weights[0]
    this.normal = weights[1]
    this.semibold = weights[2]
    this.bold = weights[3]
  }
}

export class LineHeights extends Array {
  condensedUltra: (string | number)
  condensed: (string | number)
  default: (string | number)

  constructor(...heights: (string | number)[]) {
    super()
    heights.map((h) => this.push(h))
    this.condensedUltra = heights[0]
    this.condensed = heights[1]
    this.default = heights[2]
  }
}

export class LetterSpacings extends Array {
  default: (string | number)
  headline: (string | number)

  constructor(...spacings: (string | number)[]) {
    super()
    spacings.map((s) => this.push(s))
    this.default = spacings[0]
    this.headline = spacings[1]
  }
}

export interface Typography {
  fontSizes?: FontSizes;
  fonts?: Fonts;
  fontWeights?: FontWeights;
  lineHeights?: LineHeights;
  letterSpacings?: LetterSpacings;
}

export const fonts: Fonts = new Fonts(
  [ '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Helvetica', 'Arial', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji' ],
  [ 'SFMono-Regular', 'Consolas', 'Liberation Mono', 'Menlo', 'Courier', 'monospace' ]
)

export const fontSizes: FontSizes = new FontSizes(10, 12, 14, 16, 20, 24, 32, 40, 48)

export const fontWeights: FontWeights = new FontWeights(300, 400, 500, 600)

export const lineHeights: LineHeights = new LineHeights(1, 1.25, 1.5)

export const letterSpacings: LetterSpacings = new LetterSpacings(1, 1.75)

export const typography: Typography = {
  fonts,
  fontSizes,
  fontWeights,
  lineHeights,
  letterSpacings,
}

export default typography