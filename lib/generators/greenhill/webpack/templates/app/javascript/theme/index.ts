import { Theme } from 'styled-system'
import { Colors } from './primitives/colors'
import { colors, accents, typography, layout } from './primitives'
import { variants } from './variants'

export { ThemeProvider } from './ThemeProvider'
export { Common, Border, Layout, Position, Flex, Grid } from './constants'
export type { CommonProps, BorderProps, LayoutProps, PositionProps, FlexProps, GridProps } from './constants'

export interface CustomTheme extends Theme {
  colors: Colors
}

export const theme: CustomTheme = {
  colors: colors(),
  ...layout,
  ...typography,
  ...accents,
  ...variants,
}

export default theme
