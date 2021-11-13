import { concat } from 'lodash'
import Color from 'color'
import { alpha } from './alpha'
import { darken } from './darken'
import { lighten } from './lighten'

export const shades: number[] = [
  //0.9,
  0.7,
  0.5,
  0.3,
  //0.1
]

export type SwatchesClass = Array<string>

export class Swatches extends Array implements SwatchesClass {
  constructor(...swatches: string[]) {
    super()
    swatches.map((s) => this.push(s))
  }
}

export interface ShadeSwatchesClass extends Array<string> {
  alpha: SwatchesClass[]
}

export class ShadeSwatches extends Swatches {
  alpha: Swatches[]

  constructor(...swatches: string[]) {
    super(...swatches)
    this.alpha = swatches.map((val: string): Swatches => alpha(val))
  }
}

export interface AlphaSwatchesClass extends Array<Swatches> {
  default: SwatchesClass
}

export class AlphaSwatches extends Array implements AlphaSwatchesClass {
  default: Swatches

  constructor(...alphas: Swatches[]) {
    super()
    alphas.map((a) => this.push(a))
    this.default = alphas[Math.floor(alphas.length / 2)]
  }
}

export interface ColorSwatchesClass extends Array<string> {
  alpha: AlphaSwatchesClass
  default: string
}

export class ColorSwatches extends Array {
  alpha: AlphaSwatches
  default: string

  constructor(c: string, invert=false) {
    super()

    const color: Color = Color(c)
    const rgb: string = color.rgb().string()
    const alphas: Swatches = alpha(color)
    const lightened: ShadeSwatches = lighten(color)
    const darkened: ShadeSwatches = darken(color)

    if (invert) {
      darkened.reverse().map((s) => this.push(s))
    } else {
      lightened.map((s) => this.push(s))
    }

    this.push(rgb)

    if (invert) {
      lightened.reverse().map((s) => this.push(s))
    } else {
      darkened.map((s) => this.push(s))
    }

    this.default = rgb

    this.alpha = new AlphaSwatches(...concat(
      (invert ? darkened.alpha.reverse() : lightened.alpha),
      [alphas],
      (invert ? lightened.alpha.reverse() : darkened.alpha)
    ))
  }
}
