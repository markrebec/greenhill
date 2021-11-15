/* eslint-disable @typescript-eslint/ban-types */

import * as CSS from 'csstype'
import { ObjectOrArray, TLengthStyledSystem, Scale } from 'styled-system'

export interface Accents<TLength = TLengthStyledSystem> {
  borders?: ObjectOrArray<CSS.Property.Border<{}>>
  borderStyles?: ObjectOrArray<CSS.Property.Border<{}>>
  borderWidths?: ObjectOrArray<CSS.Property.BorderWidth<TLength>>
  radii?: ObjectOrArray<CSS.Property.BorderRadius<TLength>>
  shadows?: ObjectOrArray<CSS.Property.BoxShadow>
}

export const borders: Scale | undefined = undefined

export const borderStyles: Scale | undefined = undefined

export const borderWidths: Scale = [ 0, 1 ]

export const radii: Scale = [ 0, 3, 6, 100 ]

export const shadows: ObjectOrArray<CSS.Property.BoxShadow> | undefined = undefined

export const accents: Accents = {
  borders,
  borderStyles,
  borderWidths,
  radii,
  shadows,
}

export default accents
