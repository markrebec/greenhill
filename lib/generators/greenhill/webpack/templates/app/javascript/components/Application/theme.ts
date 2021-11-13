import { Theme } from 'styled-system'
import { colors, accents, typography, layout } from '../../primitives'
import { Colors } from '../../primitives/colors'

export interface CustomTheme extends Theme {
  colors: Colors
}

export const theme: CustomTheme = {
  colors: colors(),
  ...layout,
  ...typography,
  ...accents,
}

export default theme
