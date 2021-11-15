import { FriendlyPalette } from '.'
import { SwatchPalette } from './swatches'

/*
export type CSSColorPalette = {
  [index in PaletteColor]: CSS.Property.Color;
}

export type ColorSwatchPalette = {
  [index in PaletteColorGroup]: ColorSwatches;
}

export type FriendlyPalette = CSSColorPalette & ColorSwatchPalette
*/

export const friendlyPalette: (palette: SwatchPalette) => FriendlyPalette = (palette: SwatchPalette): FriendlyPalette => ({
  brand      : palette.brand.default,
  branding   : palette.brand,
  primary    : palette.primary.default,
  primaries  : palette.primary,
  secondary  : palette.secondary.default,
  secondaries: palette.secondary,
  tertiary   : palette.tertiary.default,
  tertiaries : palette.tertiary,
  accent     : palette.accent.default,
  accents    : palette.accent,
  info       : palette.info.default,
  infos      : palette.info,
  warning    : palette.warning.default,
  warnings   : palette.warning,
  negative   : palette.negative.default,
  negatives  : palette.negative,
  positive   : palette.positive.default,
  positives  : palette.positive,
  light      : palette.light.default,
  lights     : palette.light,
  dark       : palette.dark.default,
  darks      : palette.dark,
  white      : palette.white.default,
  whites     : palette.white,
  black      : palette.black.default,
  blacks     : palette.black,
})

export default friendlyPalette
