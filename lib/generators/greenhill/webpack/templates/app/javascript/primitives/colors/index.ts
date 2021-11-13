import { palette as colorPalette, Palette, FriendlyPalette, PaletteColor } from './palette'

export type Colors = FriendlyPalette //ObjectOrArray<CSS.Property.Color>
export const colors: (palette?: Palette) => FriendlyPalette = (customPalette?: Palette): FriendlyPalette => colorPalette(customPalette)

export type { PaletteColor }
export default colors
