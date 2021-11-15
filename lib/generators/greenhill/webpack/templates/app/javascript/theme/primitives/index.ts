import { colors, Colors } from './colors'
import { accents, Accents } from './accents'
import { typography, Typography } from './typography'
import { layout, Layout } from './layout'


export interface Primitives {
    colors: Colors
    accents: Accents
    typography: Typography
    layout: Layout
}

const primitives: Primitives = {
  colors: colors(),
  accents,
  typography,
  layout,
}

export {
  colors,
  accents,
  typography,
  layout,
}

export default primitives
