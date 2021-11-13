import Color from 'color'
import { shades, Swatches } from './swatches'

export const alpha: (c: string | Color) => Swatches = (c: string | Color): Swatches => {
  const color: Color = Color(c)
  return new Swatches(...shades.map((val: number): string => color.alpha(val).rgb().string()))
}

export default alpha
