import { VariantFn, VariantConfigOpts } from './types'
import { PaletteColor } from '../primitives/colors/palette'
import merge from './merge'

export type ColorVariantProps = { variant?: PaletteColor | 'link' }

const colorVariantDefaults: Record<string, Record<string, string>> = {
  link: {
    color: 'brand'
  },
  brand: {
    color: 'brand',
  },
  primary: {
    color: 'primary',
  },
  secondary: {
    color: 'secondary',
  },
  tertiary: {
    color: 'tertiary',
  },
  accent: {
    color: 'accent',
  },
  info: {
    color: 'info',
  },
  warning: {
    color: 'warning',
  },
  negative: {
    color: 'negative',
  },
  positive: {
    color: 'positive',
  },
  light: {
    color: 'light',
  },
  dark: {
    color: 'dark',
  },
  white: {
    color: 'white',
  },
  black: {
    color: 'black',
  },
}

export const colorVariant: VariantFn = ({ scale, prop, variants={} }: VariantConfigOpts) => merge({ scale, prop, variants }, colorVariantDefaults)

export default colorVariant
