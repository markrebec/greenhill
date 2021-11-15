/* eslint-disable @typescript-eslint/ban-types */

import * as CSS from 'csstype'
import { ObjectOrArray, Scale } from 'styled-system'

export interface Layout {
  breakpoints?: ObjectOrArray<number | string | symbol>
  sizes?: ObjectOrArray<CSS.Property.Height<{}> | CSS.Property.Width<{}>>
  space?: ObjectOrArray<CSS.Property.Margin<number | string>>
  zIndices?: ObjectOrArray<CSS.Property.ZIndex>
}

export const breakpoints: Scale = [
  '481px',
  '769px',
  '1025px',
  '1201px',
]

export const sizes: Scale = [
  '480px',
  '768px',
  '1024px',
  '1200px',
]

export const space: Scale = [
  0,
  4,
  8,
  16,
  24,
  32,
  40,
  48,
  64,
  80,
  96,
  112,
  128,
]

export const zIndices: ObjectOrArray<CSS.Property.ZIndex> | undefined = undefined

export const layout: Layout = {
  breakpoints,
  sizes,
  space,
  zIndices,
}

export default layout
