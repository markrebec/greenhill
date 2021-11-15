import { isArray, mergeWith } from 'lodash'
import { defaultPalette } from './palette'
import { Palette } from '.'

// TODO don't need custom mergeWith now that we cleaned up the base palette shape
const replaceArrays: (objVal: string | string[], srcVal: string | string[]) => string | string[] | undefined = (_objVal: string | string[], srcVal: string | string[]): string | string[] | undefined => {
  if (isArray(srcVal))
    return srcVal

  return
}

export const mergePalettes: (target: Palette, source: Palette) => Palette = (target: Palette, source: Palette): Palette => mergeWith({}, target, source, replaceArrays)

export const merge: (palette?: Palette) => Palette = (customPalette?: Palette): Palette => {
  if (!customPalette) return defaultPalette

  return mergePalettes(defaultPalette, customPalette)
}

export default merge
