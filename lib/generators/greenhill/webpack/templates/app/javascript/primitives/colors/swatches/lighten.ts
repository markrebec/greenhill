import Color from 'color'
import { shades, ShadeSwatches } from './swatches'

export const lighten: (c: string | Color) => ShadeSwatches = (c: string | Color): ShadeSwatches => {
  const color: Color = Color(c)
  const lightened: ShadeSwatches = new ShadeSwatches(...shades.map((val: number): string => color.mix(Color('#fff'), val).rgb().string()))

  return lightened
}

export default lighten
