import { swatches, ColorSwatches } from '../swatches'
import { Palette, PaletteColor } from '.'

export { ColorSwatches }

export type SwatchPalette = {
  [index in PaletteColor]: ColorSwatches
}

export type SwatchPaletteFn = (palette: Palette) => SwatchPalette

export const swatchPalette: SwatchPaletteFn = ({ invert=false, ...palette }): SwatchPalette => ({
  brand    : swatches(palette.brand, invert),
  primary  : swatches(palette.primary, invert),
  secondary: swatches(palette.secondary, invert),
  tertiary : swatches(palette.tertiary, invert),
  accent   : swatches(palette.accent, invert),
  info     : swatches(palette.info, invert),
  positive : swatches(palette.positive, invert),
  negative : swatches(palette.negative, invert),
  warning  : swatches(palette.warning, invert),
  light    : swatches((invert ? palette.dark : palette.light), invert),
  dark     : swatches((invert ? palette.light : palette.dark), invert),
  white    : swatches(palette.white, invert),
  black    : swatches(palette.black, invert),
})

export default swatchPalette