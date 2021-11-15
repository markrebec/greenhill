import Color from 'color'
import { shades, ShadeSwatches } from './swatches'

export const darken: (c: string | Color) => ShadeSwatches = (c: string | Color): ShadeSwatches => {
  const color: Color = Color(c)
  const darkened: ShadeSwatches = new ShadeSwatches(...shades.map((val: number): string => color.mix(Color('#000'), val).rgb().string()).reverse())

  return darkened
}

export default darken
