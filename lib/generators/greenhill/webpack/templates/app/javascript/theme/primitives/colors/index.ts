import { palette as colorPalette, PaletteColors, Palette, FriendlyPalette, PaletteColor } from './palette'

export type Colors = FriendlyPalette //ObjectOrArray<CSS.Property.Color>
export const colors: (palette?: Palette) => FriendlyPalette = (customPalette) => colorPalette(customPalette)

export { PaletteColors }
export type { PaletteColor }
export default colors
