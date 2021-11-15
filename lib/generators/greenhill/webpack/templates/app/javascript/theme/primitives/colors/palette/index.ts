import * as CSS from 'csstype'
import merge from './merge'
import { swatchPalette, ColorSwatches } from './swatches'
import { friendlyPalette } from './friendly'

export type PaletteColor = 'brand' | 'primary' | 'secondary' | 'tertiary' | 'accent' | 'info' | 'positive' | 'negative' | 'warning' | 'light' | 'dark' | 'white' | 'black'
export type PaletteColorGroup = 'branding' | 'primaries' | 'secondaries' | 'tertiaries' | 'accents' | 'infos' | 'positives' | 'negatives' | 'warnings' | 'lights' | 'darks' | 'whites' | 'blacks'

export type ColorPalette = {
  [index in PaletteColor]: string
}

export type Palette = ColorPalette & {
  invert?: boolean
}

export type CSSColorPalette = {
  [index in PaletteColor]: CSS.Property.Color
}

export type ColorSwatchPalette = {
  [index in PaletteColorGroup]: ColorSwatches
}

export type FriendlyPalette = CSSColorPalette & ColorSwatchPalette

export type PaletteFn = (palette?: Palette) => FriendlyPalette

export const palette: PaletteFn = (customPalette) => friendlyPalette(swatchPalette(merge(customPalette)))
export default palette