import { VariantFn, VariantDefaultsFn, ColorFallbackFn, VariantConfigOpts, VariantColorProps, Color, CombinedVariantProps, Variant } from './types'
import merge from './merge'
import { PaletteColor } from '../primitives/colors/palette'
import { mix } from '../primitives/colors/swatches/mix'

export type OutlineProps = {
  /** Outline the background variant or use a solid background */
  outline?: boolean;
}

export type BackgroundVariantProps = CombinedVariantProps<OutlineProps, PaletteColor | "link">

const backgroundLinkColor: ColorFallbackFn = ({ color, theme: { colors } }: VariantColorProps, fallback) => {
  if (!color) return fallback

  let matchColor: Color = color
  if (colors && colors[color as PaletteColor])
    matchColor = colors[color as PaletteColor]

  return matchColor
}

export type PaletteColorDefaults<T extends string=PaletteColor> = {
  [K in T]: Variant
} & {
  link: Variant
}

export type ColorDefaults = PaletteColorDefaults

const backgroundDefaults: VariantDefaultsFn<ColorDefaults> = props => ({
  link: {
    color : backgroundLinkColor(props, 'brand'),
    bg    : 'transparent',
    borderColor: 'transparent',
  },
  brand: {
    color      : props.outline ? 'brand' : 'light',
    bg         : props.outline ? 'light' : 'brand',
    borderColor: 'brand',
  },
  primary: {
    color      : props.outline ? 'primary' : 'light',
    bg         : props.outline ? 'light' : 'primary',
    borderColor: 'primary',
  },
  secondary: {
    color      : props.outline ? 'secondary' : 'light',
    bg         : props.outline ? 'light' : 'secondary',
    borderColor: 'secondary',
  },
  tertiary: {
    color      : props.outline ? 'tertiary' : 'light',
    bg         : props.outline ? 'light' : 'tertiary',
    borderColor: 'tertiary',
  },
  accent: {
    color      : props.outline ? 'accent' : 'white',
    bg         : props.outline ? 'white' : 'accent',
    borderColor: 'accent',
  },
  info: {
    color      : props.outline ? 'info' : 'white',
    bg         : props.outline ? 'white' : 'info',
    borderColor: 'info',
  },
  warning: {
    color      : props.outline ? 'warning' : 'white',
    bg         : props.outline ? 'white' : 'warning',
    borderColor: 'warning',
  },
  negative: {
    color      : props.outline ? 'negative' : 'white',
    bg         : props.outline ? 'white' : 'negative',
    borderColor: 'negative',
  },
  positive: {
    color      : props.outline ? 'positive' : 'white',
    bg         : props.outline ? 'white' : 'positive',
    borderColor: 'positive',
  },
  light: {
    color      : props.outline ? 'lights.4' : 'light',
    bg         : props.outline ? 'light' : 'lights.4',
    borderColor: 'lights.4',
  },
  dark: {
    color      : props.outline ? 'darks.2' : 'light',
    bg         : props.outline ? 'light' : 'darks.2',
    borderColor: 'darks.2',
  },
  white: {
    color      : props.outline ? 'whites.4' : 'white',
    bg         : props.outline ? 'white' : 'whites.4',
    borderColor: 'whites.4',
  },
  black: {
    color      : props.outline ? 'blacks.2' : 'white',
    bg         : props.outline ? 'white' : 'blacks.2',
    borderColor: 'blacks.2',
  },
})

const hoverLinkColor: ColorFallbackFn = ({ color, theme: { colors } }: VariantColorProps, fallback) => {
  if (!color) return fallback

  let mixColor: Color = color
  if (colors && colors[color as PaletteColor])
    mixColor = colors[color as PaletteColor]

  return mix(mixColor, '#000', 0.1).rgb().string()
}

const hoverDefaults: VariantDefaultsFn = props => ({
  link: {
    color : hoverLinkColor(props, 'branding.4'),
    bg    : 'transparent',
    borderColor: 'transparent',
  },
  brand: {
    color      : 'light',
    bg         : 'branding.4',
    borderColor: 'branding.4',
  },
  primary: {
    color      : 'light',
    bg         : 'primaries.4',
    borderColor: 'primaries.4',
  },
  secondary: {
    color      : 'light',
    bg         : 'secondaries.4',
    borderColor: 'secondaries.4',
  },
  tertiary: {
    color      : 'light',
    bg         : 'tertiaries.4',
    borderColor: 'tertiaries.4',
  },
  accent: {
    color      : 'white',
    bg         : 'accents.4',
    borderColor: 'accents.4',
  },
  info: {
    color      : 'white',
    bg         : 'infos.4',
    borderColor: 'infos.4',
  },
  warning: {
    color      : 'white',
    bg         : 'warnings.4',
    borderColor: 'warnings.4',
  },
  negative: {
    color      : 'white',
    bg         : 'negatives.4',
    borderColor: 'negatives.4',
  },
  positive: {
    color      : 'white',
    bg         : 'positives.4',
    borderColor: 'positives.4',
  },
  light: {
    color      : 'light',
    bg         : 'lights.5',
    borderColor: 'lights.5',
  },
  dark: {
    color      : 'light',
    bg         : 'darks.4',
    borderColor: 'darks.4',
  },
  white: {
    color      : 'white',
    bg         : 'whites.5',
    borderColor: 'whites.5',
  },
  black: {
    color      : 'white',
    bg         : 'blacks.4',
    borderColor: 'blacks.4',
  },
})

const activeLinkColor: ColorFallbackFn = ({ color, theme: { colors } }: VariantColorProps, fallback) => {
  if (!color) return fallback

  let matchColor: Color = color
  if (colors && colors[color as PaletteColor])
    matchColor = colors[color as PaletteColor]

  return matchColor
}

const activeDefaults: VariantDefaultsFn = props => ({
  link: {
    color : activeLinkColor(props, 'brand'),
    bg    : 'transparent',
    borderColor: 'transparent',
  },
  brand: {
    color      : 'light',
    bg         : 'brand',
    borderColor: 'brand',
  },
  primary: {
    color      : 'light',
    bg         : 'primary',
    borderColor: 'primary',
  },
  secondary: {
    color      : 'light',
    bg         : 'secondary',
    borderColor: 'secondary',
  },
  tertiary: {
    color      : 'light',
    bg         : 'tertiary',
    borderColor: 'tertiary',
  },
  accent: {
    color      : 'white',
    bg         : 'accent',
    borderColor: 'accent',
  },
  info: {
    color      : 'white',
    bg         : 'info',
    borderColor: 'info',
  },
  warning: {
    color      : 'white',
    bg         : 'warning',
    borderColor: 'warning',
  },
  negative: {
    color      : 'white',
    bg         : 'negative',
    borderColor: 'negative',
  },
  positive: {
    color      : 'white',
    bg         : 'positive',
    borderColor: 'positive',
  },
  light: {
    color      : 'light',
    bg         : 'lights.4',
    borderColor: 'lights.4',
  },
  dark: {
    color      : 'light',
    bg         : 'darks.2',
    borderColor: 'darks.2',
  },
  white: {
    color      : 'white',
    bg         : 'whites.4',
    borderColor: 'whites.4',
  },
  black: {
    color      : 'white',
    bg         : 'blacks.2',
    borderColor: 'blacks.2',
  },
})

export type BackgroundFn = VariantFn<BackgroundVariantProps, VariantColorProps>

export const background: BackgroundFn = ({ scale, prop, variants={} }: VariantConfigOpts) => props => merge({ scale, prop, variants }, backgroundDefaults(props))(props)
export const backgroundHover: VariantFn = ({ scale, prop, variants={} }: VariantConfigOpts) => props => merge({ scale, prop, variants }, hoverDefaults(props))(props)
export const backgroundActive: VariantFn = ({ scale, prop, variants={} }: VariantConfigOpts) => props => merge({ scale, prop, variants }, activeDefaults(props))(props)

export default background
