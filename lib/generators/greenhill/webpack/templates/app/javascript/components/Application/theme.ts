/* eslint-disable @typescript-eslint/ban-types */

import { Theme } from 'styled-system'
import { colors as primitiveColors, accents, typography, layout } from '../../primitives'
import { Colors } from '../../primitives/colors'

export interface CustomTheme extends Theme {
  colors: Colors
}

export const colors: Colors = primitiveColors()

export interface Variants {
  buttons?: {}
  colorStyles?: {}
  textStyles?: {}
}

export const variants: Variants = {
  buttons: {
    primary: {
      color: colors.light,
      backgroundColor: colors.primary,
      borderColor: colors.primary,
      '&:hover': {
        backgroundColor: colors.primaries[2],
        borderColor: colors.primaries[2],
      },
      '&:active': {
        backgroundColor: colors.primary,
        borderColor: colors.primary,
      },
    },
    secondary: {},
    tertiary: {},
  },
  // colorStyles: {},
  // textStyles: {},
}

export const theme: CustomTheme = {
  colors,
  ...layout,
  ...typography,
  ...accents,
  ...variants,
}

export default theme
