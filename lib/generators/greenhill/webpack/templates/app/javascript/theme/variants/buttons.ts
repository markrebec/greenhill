import { colors as primitiveColors } from '../primitives'
import { Colors } from '../primitives/colors'
import { PaletteColor } from '../primitives/colors/palette'

const colors: Colors = primitiveColors()

export interface ButtonVariant {
  [key: string]: string | number | (string | number)[] | ButtonVariant
}

export type Buttons = {
  [key in PaletteColor]?: ButtonVariant
}

export const buttons: Buttons = {
  brand: {
    color: colors.light,
    backgroundColor: colors.brand,
    borderColor: colors.brand,
    '&:hover, &:focus': {
      backgroundColor: colors.branding[2],
      borderColor: colors.branding[2],
    },
    '&:active': {
      backgroundColor: colors.brand,
      borderColor: colors.brand,
    },
  },

  primary: {
    color: colors.light,
    backgroundColor: colors.primary,
    borderColor: colors.primary,
    '&:hover, &:focus': {
      backgroundColor: colors.primaries[2],
      borderColor: colors.primaries[2],
    },
    '&:active': {
      backgroundColor: colors.primary,
      borderColor: colors.primary,
    },
  },

  secondary: {
    color: colors.light,
    backgroundColor: colors.secondary,
    borderColor: colors.secondary,
    '&:hover, &:focus': {
      backgroundColor: colors.secondaries[2],
      borderColor: colors.secondaries[2],
    },
    '&:active': {
      backgroundColor: colors.secondary,
      borderColor: colors.secondary,
    },
  },

  tertiary: {
    color: colors.light,
    backgroundColor: colors.tertiary,
    borderColor: colors.tertiary,
    '&:hover, &:focus': {
      backgroundColor: colors.tertiaries[2],
      borderColor: colors.tertiaries[2],
    },
    '&:active': {
      backgroundColor: colors.tertiary,
      borderColor: colors.tertiary,
    },
  },

  accent: {
    color: colors.light,
    backgroundColor: colors.accent,
    borderColor: colors.accent,
    '&:hover, &:focus': {
      backgroundColor: colors.accents[2],
      borderColor: colors.accents[2],
    },
    '&:active': {
      backgroundColor: colors.accent,
      borderColor: colors.accent,
    },
  },

  info: {
    color: colors.light,
    backgroundColor: colors.info,
    borderColor: colors.info,
    '&:hover, &:focus': {
      backgroundColor: colors.infos[2],
      borderColor: colors.infos[2],
    },
    '&:active': {
      backgroundColor: colors.info,
      borderColor: colors.info,
    },
  },

  warning: {
    color: colors.light,
    backgroundColor: colors.warning,
    borderColor: colors.warning,
    '&:hover, &:focus': {
      backgroundColor: colors.warnings[2],
      borderColor: colors.warnings[2],
    },
    '&:active': {
      backgroundColor: colors.warning,
      borderColor: colors.warning,
    },
  },

  positive: {
    color: colors.light,
    backgroundColor: colors.positive,
    borderColor: colors.positive,
    '&:hover, &:focus': {
      backgroundColor: colors.positives[2],
      borderColor: colors.positives[2],
    },
    '&:active': {
      backgroundColor: colors.positive,
      borderColor: colors.positive,
    },
  },

  negative: {
    color: colors.light,
    backgroundColor: colors.negative,
    borderColor: colors.negative,
    '&:hover, &:focus': {
      backgroundColor: colors.negatives[2],
      borderColor: colors.negatives[2],
    },
    '&:active': {
      backgroundColor: colors.negative,
      borderColor: colors.negative,
    },
  },
}

export default buttons