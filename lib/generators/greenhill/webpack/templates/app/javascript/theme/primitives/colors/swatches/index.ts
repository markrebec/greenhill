import { ColorSwatches } from './swatches'

export { ColorSwatches }

export type SwatchesFn = (color: string, invert?: boolean) => ColorSwatches

export const swatches: SwatchesFn = (c, invert=false) => new ColorSwatches(c, invert)
export default swatches